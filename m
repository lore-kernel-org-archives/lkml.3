Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaJ1Dq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:46:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbaJ1Dqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:46:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 106/127] sparc: bpf_jit: fix loads from negative offsets
Date: Tue, 28 Oct 2014 11:35:41 +0800
Message-Id: <20141028033425.480964559@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit 35607b02dbef304fa5037236a3b43c1d8ab2aa52 ]

- fix BPF_LD|ABS|IND from negative offsets:
  make sure to sign extend lower 32 bits in 64-bit register
  before calling C helpers from JITed code, otherwise 'int k'
  argument of bpf_internal_load_pointer_neg_helper() function
  will be added as large unsigned integer, causing packet size
  check to trigger and abort the program.

  It's worth noting that JITed code for 'A = A op K' will affect
  upper 32 bits differently depending whether K is simm13 or not.
  Since small constants are sign extended, whereas large constants
  are stored in temp register and zero extended.
  That is ok and we don't have to pay a penalty of sign extension
  for every sethi, since all classic BPF instructions have 32-bit
  semantics and we only need to set correct upper bits when
  transitioning from JITed code into C.

- though instructions 'A &= 0' and 'A *= 0' are odd, JIT compiler
  should not optimize them out

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/net/bpf_jit_asm.S  |    3 +++
 arch/sparc/net/bpf_jit_comp.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/net/bpf_jit_asm.S
+++ b/arch/sparc/net/bpf_jit_asm.S
@@ -6,10 +6,12 @@
 #define SAVE_SZ		176
 #define SCRATCH_OFF	STACK_BIAS + 128
 #define BE_PTR(label)	be,pn %xcc, label
+#define SIGN_EXTEND(reg)	sra reg, 0, reg
 #else
 #define SAVE_SZ		96
 #define SCRATCH_OFF	72
 #define BE_PTR(label)	be label
+#define SIGN_EXTEND(reg)
 #endif
 
 #define SKF_MAX_NEG_OFF	(-0x200000) /* SKF_LL_OFF from filter.h */
@@ -135,6 +137,7 @@ bpf_slow_path_byte_msh:
 	save	%sp, -SAVE_SZ, %sp;			\
 	mov	%i0, %o0;				\
 	mov	r_OFF, %o1;				\
+	SIGN_EXTEND(%o1);				\
 	call	bpf_internal_load_pointer_neg_helper;	\
 	 mov	(LEN), %o2;				\
 	mov	%o0, r_TMP;				\
--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -184,7 +184,7 @@ do {								\
 	 */
 #define emit_alu_K(OPCODE, K)					\
 do {								\
-	if (K) {						\
+	if (K || OPCODE == AND || OPCODE == MUL) {		\
 		unsigned int _insn = OPCODE;			\
 		_insn |= RS1(r_A) | RD(r_A);			\
 		if (is_simm13(K)) {				\


