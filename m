Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLERH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:07:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45408 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLERHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:07:55 -0500
Date: Fri, 5 Dec 2014 17:07:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        Peter Maydell <Peter.Maydell@arm.com>
Subject: Re: [RFC v2] arm:extend the reserved mrmory for initrd to be page
 aligned
Message-ID: <20141205170745.GA31222@e104818-lin.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D103D6DB491609@CNBJMBX05.corpusers.net>
 <20140915113325.GD12361@n2100.arm.linux.org.uk>
 <20141204120305.GC17783@e104818-lin.cambridge.arm.com>
 <20141205120506.GH1630@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205120506.GH1630@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:05:06PM +0000, Will Deacon wrote:
> On Thu, Dec 04, 2014 at 12:03:05PM +0000, Catalin Marinas wrote:
> > On Mon, Sep 15, 2014 at 12:33:25PM +0100, Russell King - ARM Linux wrote:
> > > On Mon, Sep 15, 2014 at 07:07:20PM +0800, Wang, Yalin wrote:
> > > > @@ -636,6 +646,11 @@ static int keep_initrd;
> > > >  void free_initrd_mem(unsigned long start, unsigned long end)
> > > >  {
> > > >  	if (!keep_initrd) {
> > > > +		if (start == initrd_start)
> > > > +			start = round_down(start, PAGE_SIZE);
> > > > +		if (end == initrd_end)
> > > > +			end = round_up(end, PAGE_SIZE);
> > > > +
> > > >  		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
> > > >  		free_reserved_area((void *)start, (void *)end, -1, "initrd");
> > > >  	}
> > > 
> > > is the only bit of code you likely need to achieve your goal.
> > > 
> > > Thinking about this, I think that you are quite right to align these.
> > > The memory around the initrd is defined to be system memory, and we
> > > already free the pages around it, so it *is* wrong not to free the
> > > partial initrd pages.
> > 
> > Actually, I think we have a problem, at least on arm64 (raised by Peter
> > Maydell). There is no guarantee that the page around start/end of initrd
> > is free, it may contain the dtb for example. This is even more obvious
> > when we have a 64KB page kernel (the boot loader doesn't know the page
> > size that the kernel is going to use).
> > 
> > The bug was there before as we had poison_init_mem() already (not it
> > disappeared since free_reserved_area does the poisoning).
> > 
> > So as a quick fix I think we need the rounding the other way (and in the
> > general case we probably lose a page at the end of initrd):
> > 
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index 494297c698ca..39fd080683e7 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -335,9 +335,9 @@ void free_initrd_mem(unsigned long start, unsigned long end)
> >  {
> >  	if (!keep_initrd) {
> >  		if (start == initrd_start)
> > -			start = round_down(start, PAGE_SIZE);
> > +			start = round_up(start, PAGE_SIZE);
> >  		if (end == initrd_end)
> > -			end = round_up(end, PAGE_SIZE);
> > +			end = round_down(end, PAGE_SIZE);
> >  
> >  		free_reserved_area((void *)start, (void *)end, 0, "initrd");
> >  	}
> > 
> > A better fix would be to check what else is around the start/end of
> > initrd.
> 
> Care to submit this as a proper patch? We should at least fix Peter's issue
> before doing things like extending headers, which won't work for older
> kernels anyway.

Quick fix is the revert of the whole patch, together with removing
PAGE_ALIGN(end) in poison_init_mem() on arm32. If Russell is ok with
this patch, we can take it via the arm64 tree, otherwise I'll send you a
partial revert only for the arm64 part.

-------------8<-----------------------

>From 8e317c6be00abe280de4dcdd598d2e92009174b6 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 5 Dec 2014 16:41:52 +0000
Subject: [PATCH] Revert "ARM: 8167/1: extend the reserved memory for initrd to
 be page aligned"

This reverts commit 421520ba98290a73b35b7644e877a48f18e06004. There is
no guarantee that the boot-loader places other images like dtb in a
different page than initrd start/end. When this happens, such pages must
not be freed. The free_reserved_area() already takes care of rounding up
"start" and rounding down "end" to avoid freeing partially used pages.

In addition to the revert, this patch also removes the arm32
PAGE_ALIGN(end) when calculating the size of the memory to be poisoned.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Peter Maydell <Peter.Maydell@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: <stable@vger.kernel.org> # 3.17+
---
 arch/arm/mm/init.c   | 7 +------
 arch/arm64/mm/init.c | 8 +-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 92bba32d9230..108d6949c727 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -636,12 +636,7 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd) {
-		if (start == initrd_start)
-			start = round_down(start, PAGE_SIZE);
-		if (end == initrd_end)
-			end = round_up(end, PAGE_SIZE);
-
-		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
+		poison_init_mem((void *)start, end - start);
 		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 	}
 }
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 494297c698ca..fff81f02251c 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -333,14 +333,8 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd) {
-		if (start == initrd_start)
-			start = round_down(start, PAGE_SIZE);
-		if (end == initrd_end)
-			end = round_up(end, PAGE_SIZE);
-
+	if (!keep_initrd)
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
-	}
 }
 
 static int __init keepinitrd_setup(char *__unused)
