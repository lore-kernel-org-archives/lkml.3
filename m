Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbaBDWD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:03:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934150AbaBDVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 109/133] s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions
Date: Tue,  4 Feb 2014 13:08:30 -0800
Message-Id: <20140204210740.111160460@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit 3af57f78c38131b7a66e2b01e06fdacae01992a3 ]

The s390 bpf jit compiler emits the signed divide instructions "dr" and "d"
for unsigned divisions.
This can cause problems: the dividend will be zero extended to a 64 bit value
and the divisor is the 32 bit signed value as specified A or X accumulator,
even though A and X are supposed to be treated as unsigned values.

The divide instrunctions will generate an exception if the result cannot be
expressed with a 32 bit signed value.
This is the case if e.g. the dividend is 0xffffffff and the divisor either 1
or also 0xffffffff (signed: -1).

To avoid all these issues simply use unsigned divide instructions.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -368,16 +368,16 @@ static int bpf_jit_insn(struct bpf_jit *
 		EMIT4_PCREL(0xa7840000, (jit->ret0_ip - jit->prg));
 		/* lhi %r4,0 */
 		EMIT4(0xa7480000);
-		/* dr %r4,%r12 */
-		EMIT2(0x1d4c);
+		/* dlr %r4,%r12 */
+		EMIT4(0xb997004c);
 		break;
 	case BPF_S_ALU_DIV_K: /* A /= K */
 		if (K == 1)
 			break;
 		/* lhi %r4,0 */
 		EMIT4(0xa7480000);
-		/* d %r4,<d(K)>(%r13) */
-		EMIT4_DISP(0x5d40d000, EMIT_CONST(K));
+		/* dl %r4,<d(K)>(%r13) */
+		EMIT6_DISP(0xe340d000, 0x0097, EMIT_CONST(K));
 		break;
 	case BPF_S_ALU_MOD_X: /* A %= X */
 		jit->seen |= SEEN_XREG | SEEN_RET0;
@@ -387,8 +387,8 @@ static int bpf_jit_insn(struct bpf_jit *
 		EMIT4_PCREL(0xa7840000, (jit->ret0_ip - jit->prg));
 		/* lhi %r4,0 */
 		EMIT4(0xa7480000);
-		/* dr %r4,%r12 */
-		EMIT2(0x1d4c);
+		/* dlr %r4,%r12 */
+		EMIT4(0xb997004c);
 		/* lr %r5,%r4 */
 		EMIT2(0x1854);
 		break;
@@ -400,8 +400,8 @@ static int bpf_jit_insn(struct bpf_jit *
 		}
 		/* lhi %r4,0 */
 		EMIT4(0xa7480000);
-		/* d %r4,<d(K)>(%r13) */
-		EMIT4_DISP(0x5d40d000, EMIT_CONST(K));
+		/* dl %r4,<d(K)>(%r13) */
+		EMIT6_DISP(0xe340d000, 0x0097, EMIT_CONST(K));
 		/* lr %r5,%r4 */
 		EMIT2(0x1854);
 		break;


