Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaJ1Dkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaJ1Dkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 122/146] sparc64: Fix corrupted thread fault code.
Date: Tue, 28 Oct 2014 11:34:24 +0800
Message-Id: <20141028033348.737292192@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 84bd6d8b9c0f06b3f188efb479c77e20f05e9a8a ]

Every path that ends up at do_sparc64_fault() must install a valid
FAULT_CODE_* bitmask in the per-thread fault code byte.

Two paths leading to the label winfix_trampoline (which expects the
FAULT_CODE_* mask in register %g4) were not doing so:

1) For pre-hypervisor TLB protection violation traps, if we took
   the 'winfix_trampoline' path we wouldn't have %g4 initialized
   with the FAULT_CODE_* value yet.  Resulting in using the
   TLB_TAG_ACCESS register address value instead.

2) In the TSB miss path, when we notice that we are going to use a
   hugepage mapping, but we haven't allocated the hugepage TSB yet, we
   still have to take the window fixup case into consideration and
   in that particular path we leave %g4 not setup properly.

Errors on this sort were largely invisible previously, but after
commit 4ccb9272892c33ef1c19a783cfa87103b30c2784 ("sparc64: sun4v TLB
error power off events") we now have a fault_code mask bit
(FAULT_CODE_BAD_RA) that triggers due to this bug.

FAULT_CODE_BAD_RA triggers because this bit is set in TLB_TAG_ACCESS
(see #1 above) and thus we get seemingly random bus errors triggered
for user processes.

Fixes: 4ccb9272892c ("sparc64: sun4v TLB error power off events")
Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/dtlb_prot.S |    6 +++---
 arch/sparc/kernel/tsb.S       |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sparc/kernel/dtlb_prot.S
+++ b/arch/sparc/kernel/dtlb_prot.S
@@ -24,11 +24,11 @@
 	mov		TLB_TAG_ACCESS, %g4		! For reload of vaddr
 
 /* PROT ** ICACHE line 2: More real fault processing */
+	ldxa		[%g4] ASI_DMMU, %g5		! Put tagaccess in %g5
 	bgu,pn		%xcc, winfix_trampoline		! Yes, perform winfixup
-	 ldxa		[%g4] ASI_DMMU, %g5		! Put tagaccess in %g5
-	ba,pt		%xcc, sparc64_realfault_common	! Nope, normal fault
 	 mov		FAULT_CODE_DTLB | FAULT_CODE_WRITE, %g4
-	nop
+	ba,pt		%xcc, sparc64_realfault_common	! Nope, normal fault
+	 nop
 	nop
 	nop
 	nop
--- a/arch/sparc/kernel/tsb.S
+++ b/arch/sparc/kernel/tsb.S
@@ -162,10 +162,10 @@ tsb_miss_page_table_walk_sun4v_fastpath:
 	nop
 	.previous
 
-	rdpr	%tl, %g3
-	cmp	%g3, 1
+	rdpr	%tl, %g7
+	cmp	%g7, 1
 	bne,pn	%xcc, winfix_trampoline
-	 nop
+	 mov	%g3, %g4
 	ba,pt	%xcc, etrap
 	 rd	%pc, %g7
 	call	hugetlb_setup


