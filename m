Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3JCM6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:58:18 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:42593 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JCM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:58:17 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 08:58:16 EDT
Date: Thu, 3 Oct 2013 14:47:52 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [ 00/13] 3.0.99-stable review
Message-ID: <1380801873@msgid.manchmal.in-ulm.de>
References: <20131003040400.753642257@linuxfoundation.org>
 <524D0663.209@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D0663.209@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote...

> On 10/02/2013 09:04 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.0.99 release.

> Heads up: I am getting lots of build failures in 3.0 and 3.4 builds.
> 
> mm/built-in.o: In function `__put_compound_page':
> slab.c:(.text+0xaa3c): undefined reference to `PageHuge'
> mm/built-in.o: In function `put_compound_page':
> slab.c:(.text+0xaab0): undefined reference to `PageHuge'
> mm/built-in.o: In function `__get_page_tail':
> slab.c:(.text+0xb178): undefined reference to `PageHuge'
> make: *** [.tmp_vmlinux1] Error 1

This is obviously due to

| [ 11/13] mm: fix aio performance regression for database caused by THP

and happens if CONFIG_HUGETLB_PAGE is not set.

Looking closer, upstream commit 7cb2ef56 included linux/hugetlb.h
while the backport for 3.0 just defines PageHuge. Reverting that like
in the patch below causes the build to complete, and the resulting
kernel shows no anomalies here.

However did that backport, why was it done that way? Or did I miss an
important point?

    Christoph

--- a/mm/swap.c
+++ b/mm/swap.c
@@ -31,6 +31,7 @@
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
+#include <linux/hugetlb.h>

 #include "internal.h"

@@ -41,8 +42,6 @@
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);

-int PageHuge(struct page *page);
-
 /*
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.

