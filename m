Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaJ1Dqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:46:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbaJ1Dqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:46:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 105/127] sparc: bpf_jit: fix support for ldx/stx mem and SKF_AD_VLAN_TAG
Date: Tue, 28 Oct 2014 11:35:40 +0800
Message-Id: <20141028033425.436657684@linuxfoundation.org>
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

[ Upstream commit f6f2332dce0efeea8c5653b6e9d1e8c379ace65c ]

fix several issues in sparc BPF JIT compiler.

ldx/stx related:
. classic BPF instructions that access mem[] slots were not setting
  SEEN_MEM flag, so stack wasn't allocated. Fix that by advertising
  correct flags

. LDX/STX instructions were missing SEEN_XREG, so register value
  could have leaked to user space. Fix it.

. since stack for mem[] slots is allocated with 'sub %sp' instead
  of 'save %sp', use %sp as base register instead of %fp.

. ldx mem[0] means first slot in classic BPF which should have
  -4 offset instead of 0.

. sparc64 needs 2047 stack bias as per ABI to access stack

. emit_stmem() was using LD32I macro instead of ST32I

SKF_AD_VLAN_TAG* related:
. SKF_AD_VLAN_TAG_PRESENT must return 1 or 0 instead of '> 0' or 0
  as per classic BPF de facto standard

. SKF_AD_VLAN_TAG needs to mask the field correctly

Fixes: 2809a2087cc4 ("net: filter: Just In Time compiler for sparc")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/net/bpf_jit_comp.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -234,12 +234,18 @@ do {	BUILD_BUG_ON(FIELD_SIZEOF(STRUCT, F
 	__emit_load8(BASE, STRUCT, FIELD, DEST);			\
 } while (0)
 
-#define emit_ldmem(OFF, DEST)					\
-do {	*prog++ = LD32I | RS1(FP) | S13(-(OFF)) | RD(DEST);	\
+#ifdef CONFIG_SPARC64
+#define BIAS (STACK_BIAS - 4)
+#else
+#define BIAS (-4)
+#endif
+
+#define emit_ldmem(OFF, DEST)						\
+do {	*prog++ = LD32I | RS1(SP) | S13(BIAS - (OFF)) | RD(DEST);	\
 } while (0)
 
-#define emit_stmem(OFF, SRC)					\
-do {	*prog++ = LD32I | RS1(FP) | S13(-(OFF)) | RD(SRC);	\
+#define emit_stmem(OFF, SRC)						\
+do {	*prog++ = ST32I | RS1(SP) | S13(BIAS - (OFF)) | RD(SRC);	\
 } while (0)
 
 #ifdef CONFIG_SMP
@@ -615,10 +621,11 @@ void bpf_jit_compile(struct sk_filter *f
 			case BPF_ANC | SKF_AD_VLAN_TAG:
 			case BPF_ANC | SKF_AD_VLAN_TAG_PRESENT:
 				emit_skb_load16(vlan_tci, r_A);
-				if (code == (BPF_ANC | SKF_AD_VLAN_TAG)) {
-					emit_andi(r_A, VLAN_VID_MASK, r_A);
+				if (code != (BPF_ANC | SKF_AD_VLAN_TAG)) {
+					emit_alu_K(SRL, 12);
+					emit_andi(r_A, 1, r_A);
 				} else {
-					emit_loadimm(VLAN_TAG_PRESENT, r_TMP);
+					emit_loadimm(~VLAN_TAG_PRESENT, r_TMP);
 					emit_and(r_A, r_TMP, r_A);
 				}
 				break;
@@ -630,15 +637,19 @@ void bpf_jit_compile(struct sk_filter *f
 				emit_loadimm(K, r_X);
 				break;
 			case BPF_LD | BPF_MEM:
+				seen |= SEEN_MEM;
 				emit_ldmem(K * 4, r_A);
 				break;
 			case BPF_LDX | BPF_MEM:
+				seen |= SEEN_MEM | SEEN_XREG;
 				emit_ldmem(K * 4, r_X);
 				break;
 			case BPF_ST:
+				seen |= SEEN_MEM;
 				emit_stmem(K * 4, r_A);
 				break;
 			case BPF_STX:
+				seen |= SEEN_MEM | SEEN_XREG;
 				emit_stmem(K * 4, r_X);
 				break;
 


