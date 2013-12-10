Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3LJPfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:35:38 -0500
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:36052 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab3LJPfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:35:36 -0500
Date: Tue, 10 Dec 2013 15:35:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ethan Zhao <ethan.kernel@gmail.com>
cc: alokk@calsoftinc.com, shobhit@calsoftinc.com, shai@scalex86.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slab.c: check pointer slabp before using it in
 alloc_slabmgmt()
In-Reply-To: <CABawtvM6MpwHH7kFjnqSr69QWboFXsEiu6Fv0MMJkhQbaXCLxw@mail.gmail.com>
Message-ID: <00000142dd262a23-776dfc34-c3e4-4229-8684-d99131a2f758-000000@email.amazonses.com>
References: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com> <00000142d82085d4-edeac9e1-d603-458f-9ceb-904e2b706679-000000@email.amazonses.com> <CABawtvPdQ2smcawTywp605KceKAQF+CsvpBqG1zEaKfP-PLB6A@mail.gmail.com>
 <CABawtvM6MpwHH7kFjnqSr69QWboFXsEiu6Fv0MMJkhQbaXCLxw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Ethan Zhao wrote:

>      No, stable 3.12.4 and 3.12.3 need this patch.  3.13RC doesn't
> need it anymore.

Hmmm.. Then this commit may have fixed it:

commit 0172f779e4314639a8ed440082cfe9e3450954e8
Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date:   Wed Oct 30 19:04:00 2013 +0900

    slab: fix to calm down kmemleak warning

    After using struct page as slab management, we should not call
    kmemleak_scan_area(), since struct page isn't the tracking object of
    kmemleak. Without this patch and if CONFIG_DEBUG_KMEMLEAK is enabled,
    so many kmemleak warnings are printed.

    Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    Signed-off-by: Pekka Enberg <penberg@iki.fi>

diff --git a/mm/slab.c b/mm/slab.c
index af2db76..a8a9349 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2531,14 +2531,6 @@ static struct freelist *alloc_slabmgmt(struct
kmem_cache *cachep,
                /* Slab management obj is off-slab. */
                freelist = kmem_cache_alloc_node(cachep->freelist_cache,
                                              local_flags, nodeid);
-               /*
-                * If the first object in the slab is leaked (it's allocated
-                * but no one has a reference to it), we want to make sure
-                * kmemleak does not treat the ->s_mem pointer as a reference
-                * to the object. Otherwise we will not report the leak.
-                */
-               kmemleak_scan_area(&page->lru, sizeof(struct list_head),
-                                  local_flags);
                if (!freelist)
                        return NULL;
        } else {


