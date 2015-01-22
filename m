Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbbAVLlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:41:17 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44028 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbbAVLlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:41:15 -0500
Date: Thu, 22 Jan 2015 12:41:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.19-rc6
Message-ID: <20150122124102.20fa57f9@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012211-0009-0000-0000-000002DA6D27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Five more bug fixes from Michael for the s390 BPF jit.

Michael Holzheu (5):
      s390/bpf: Fix JMP_JGE_K (A >= K) and JMP_JGT_K (A > K)
      s390/bpf: Fix skb_copy_bits() parameter passing
      s390/bpf: Fix offset parameter for skb_copy_bits()
      s390/bpf: Fix sk_load_byte_msh()
      s390/bpf: Zero extend parameters before calling C function

 arch/s390/net/bpf_jit.S      | 28 ++++++++++++++++------------
 arch/s390/net/bpf_jit_comp.c |  9 +++------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/s390/net/bpf_jit.S b/arch/s390/net/bpf_jit.S
index 7e45d13..ba44c9f 100644
--- a/arch/s390/net/bpf_jit.S
+++ b/arch/s390/net/bpf_jit.S
@@ -22,8 +22,8 @@
  * skb_copy_bits takes 4 parameters:
  *   %r2 = skb pointer
  *   %r3 = offset into skb data
- *   %r4 = length to copy
- *   %r5 = pointer to temp buffer
+ *   %r4 = pointer to temp buffer
+ *   %r5 = length to copy
  */
 #define SKBDATA	%r8
 
@@ -44,8 +44,9 @@ ENTRY(sk_load_word)
 
 sk_load_word_slow:
 	lgr	%r9,%r2			# save %r2
-	lhi	%r4,4			# 4 bytes
-	la	%r5,160(%r15)		# pointer to temp buffer
+	lgr	%r3,%r1			# offset
+	la	%r4,160(%r15)		# pointer to temp buffer
+	lghi	%r5,4			# 4 bytes
 	brasl	%r14,skb_copy_bits	# get data from skb
 	l	%r5,160(%r15)		# load result from temp buffer
 	ltgr	%r2,%r2			# set cc to (%r2 != 0)
@@ -69,8 +70,9 @@ ENTRY(sk_load_half)
 
 sk_load_half_slow:
 	lgr	%r9,%r2			# save %r2
-	lhi	%r4,2			# 2 bytes
-	la	%r5,162(%r15)		# pointer to temp buffer
+	lgr	%r3,%r1			# offset
+	la	%r4,162(%r15)		# pointer to temp buffer
+	lghi	%r5,2			# 2 bytes
 	brasl	%r14,skb_copy_bits	# get data from skb
 	xc	160(2,%r15),160(%r15)
 	l	%r5,160(%r15)		# load result from temp buffer
@@ -95,8 +97,9 @@ ENTRY(sk_load_byte)
 
 sk_load_byte_slow:
 	lgr	%r9,%r2			# save %r2
-	lhi	%r4,1			# 1 bytes
-	la	%r5,163(%r15)		# pointer to temp buffer
+	lgr	%r3,%r1			# offset
+	la	%r4,163(%r15)		# pointer to temp buffer
+	lghi	%r5,1			# 1 byte
 	brasl	%r14,skb_copy_bits	# get data from skb
 	xc	160(3,%r15),160(%r15)
 	l	%r5,160(%r15)		# load result from temp buffer
@@ -104,11 +107,11 @@ sk_load_byte_slow:
 	lgr	%r2,%r9			# restore %r2
 	br	%r8
 
-	/* A = (*(u8 *)(skb->data+K) & 0xf) << 2 */
+	/* X = (*(u8 *)(skb->data+K) & 0xf) << 2 */
 ENTRY(sk_load_byte_msh)
 	llgfr	%r1,%r3			# extend offset
 	clr	%r11,%r3		# hlen < offset ?
-	jle	sk_load_byte_slow
+	jle	sk_load_byte_msh_slow
 	lhi	%r12,0
 	ic	%r12,0(%r1,%r10)	# get byte from skb
 	nill	%r12,0x0f
@@ -118,8 +121,9 @@ ENTRY(sk_load_byte_msh)
 
 sk_load_byte_msh_slow:
 	lgr	%r9,%r2			# save %r2
-	lhi	%r4,2			# 2 bytes
-	la	%r5,162(%r15)		# pointer to temp buffer
+	lgr	%r3,%r1			# offset
+	la	%r4,163(%r15)		# pointer to temp buffer
+	lghi	%r5,1			# 1 byte
 	brasl	%r14,skb_copy_bits	# get data from skb
 	xc	160(3,%r15),160(%r15)
 	l	%r12,160(%r15)		# load result from temp buffer
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 524496d..bbd1981 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -448,15 +448,12 @@ static int bpf_jit_insn(struct bpf_jit *jit, struct sock_filter *filter,
 		mask = 0x800000; /* je */
 kbranch:	/* Emit compare if the branch targets are different */
 		if (filter->jt != filter->jf) {
-			if (K <= 16383)
-				/* chi %r5,<K> */
-				EMIT4_IMM(0xa75e0000, K);
-			else if (test_facility(21))
+			if (test_facility(21))
 				/* clfi %r5,<K> */
 				EMIT6_IMM(0xc25f0000, K);
 			else
-				/* c %r5,<d(K)>(%r13) */
-				EMIT4_DISP(0x5950d000, EMIT_CONST(K));
+				/* cl %r5,<d(K)>(%r13) */
+				EMIT4_DISP(0x5550d000, EMIT_CONST(K));
 		}
 branch:		if (filter->jt == filter->jf) {
 			if (filter->jt == 0)

