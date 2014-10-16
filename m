Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaJPUu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:50:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34340 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaJPUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:50:23 -0400
Date: Thu, 16 Oct 2014 16:50:17 -0400 (EDT)
Message-Id: <20141016.165017.1151349565275102498.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141016.162001.599580415052560455.davem@redhat.com>
References: <20141016.160742.1639247937393238792.davem@redhat.com>
	<alpine.LRH.2.11.1410162313440.19924@adalberg.ut.ee>
	<20141016.162001.599580415052560455.davem@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Oct 2014 13:50:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@redhat.com>
Date: Thu, 16 Oct 2014 16:20:01 -0400 (EDT)

> So I'm going to audit all the code paths to make sure we don't put garbage
> into the fault_code value.

There are two code paths where we can put garbage into the fault_code
value.  And for the dtlb_prot.S case, the value we put in there is
TLB_TAG_ACCESS which is 0x30, which include bit 0x20 which is that
FAULT_CODE_BAD_RA indication which is erroneously triggering.

The other path is via hugepage TLB misses, for the situation where
we haven't allocated the huge TSB for the thread yet.  That might
explain some other longer-term problems we've had.

I'm about to test the following fix:

diff --git a/arch/sparc/kernel/dtlb_prot.S b/arch/sparc/kernel/dtlb_prot.S
index b2c2c5b..d668ca14 100644
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
diff --git a/arch/sparc/kernel/tsb.S b/arch/sparc/kernel/tsb.S
index 14158d4..be98685 100644
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
