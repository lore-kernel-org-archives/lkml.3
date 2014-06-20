Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240AbaFTRhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:37:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934970AbaFTRhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:37:50 -0400
Message-ID: <1403285834.755.39.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
From: Mark Salter <msalter@redhat.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2014 13:37:14 -0400
In-Reply-To: <xa1tfvj01z57.fsf@mina86.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com>
	 <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
	 <xa1t61jzwfo6.fsf@mina86.com> <1403201524.32688.62.camel@deneb.redhat.com>
	 <xa1tfvj01z57.fsf@mina86.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 21:24 +0200, Michal Nazarewicz wrote:
> On Thu, Jun 19 2014, Mark Salter <msalter@redhat.com> wrote:
> > On Tue, 2014-06-17 at 20:32 +0200, Michal Nazarewicz wrote:
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 5dba293..6e657ce 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -801,7 +801,15 @@ void __init init_cma_reserved_pageblock(struct page *page)
> >>  
> >>  	set_page_refcounted(page);
> >>  	set_pageblock_migratetype(page, MIGRATE_CMA);
> >> -	__free_pages(page, pageblock_order);
> >> +	if (pageblock_order > MAX_ORDER) {
> >> +		struct page *subpage = p;
> >> +		unsigned count = 1 << (pageblock_order - MAX_ORDER);
> >> +		do {
> >> +			__free_pages(subpage, pageblock_order);
> >                                                ^^^^^^^
> >                                                MAX_ORDER
> 
> D'oh!  I'll send a revised patch.
> 
> >> +		} while (subpage += MAX_ORDER_NR_PAGES, --count);
> >> +	} else {
> >> +		__free_pages(page, pageblock_order);
> >> +	}
> >>  	adjust_managed_page_count(page, pageblock_nr_pages);
> >>  }
> >>  #endif
> >> --------- >8 ---------------------------------------------------------
> >> 
> >> Thoughts?  This has not been tested and I think it may cause performance
> >> degradation in some cases since pageblock_order is not always
> >> a constant, so the comparison may end up not being stripped away even on
> >> systems where it's always false.
> 
> > This works with the above tweak. So it fixes the problm here, but I was
> > not sure if we'd get bitten elsewhere by pageblock_order > MAX_ORDER.
> 
> This is always a possibility, but in such cases, it's a bug in CMA.
> I've tried to keep in mind that pageblock_order may be greater than
> MAX_ORDER when writing CMA, but I've never tested on such a system.
> 
> > It will be slower, but does it only gets called a few time at most at
> > boot time, right?
> 
> Yes.  The performance degradation should be negligible since
> init_cma_reserved is hardly a critical path and is called at most
> MAX_CMA_AREAS times which by default is 8.  And I mean it will be slower
> because it will have to perform a branch.
> 

I ended up needing this (on top of your patch) to get the system to
boot. Each MAX_ORDER-1 group needs the refcount and migratetype set so
that __free_pages does the right thing.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 02fb1ed..a7ca6cc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -799,17 +799,18 @@ void __init init_cma_reserved_pageblock(struct page *page)
 		set_page_count(p, 0);
 	} while (++p, --i);
 
-	set_page_refcounted(page);
-	set_pageblock_migratetype(page, MIGRATE_CMA);
-
-	if (pageblock_order > MAX_ORDER) {
-		i = pageblock_order - MAX_ORDER;
+	if (pageblock_order >= MAX_ORDER) {
+		i = pageblock_order - MAX_ORDER + 1;
 		i = 1 << i;
 		p = page;
 		do {
-			__free_pages(p, MAX_ORDER);
+			set_page_refcounted(p);
+			set_pageblock_migratetype(p, MIGRATE_CMA);
+			__free_pages(p, MAX_ORDER - 1);
 		} while (p += MAX_ORDER_NR_PAGES, --i);
 	} else {
+		set_page_refcounted(page);
+		set_pageblock_migratetype(page, MIGRATE_CMA);
 		__free_pages(page, pageblock_order);
 	}



