Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3GXSRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:17:36 -0400
Received: from mx2.eo.pl ([217.17.46.130]:58702 "EHLO exchange.eo.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656Ab3GXSRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:17:35 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2013 14:17:35 EDT
Message-ID: <51F018FB.1050106@eo.pl>
Date: Wed, 24 Jul 2013 20:12:11 +0200
From: Adrian Brzezinski <adrian.brzezinski@eo.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <adrian.brzezinski@eo.pl>
Subject: [PATCH 1/1] fs/proc: cached = pagecache - shmem
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.42.173.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cached value taken from /proc/meminfo counts also shmem pages.
This can be very confusing when we encounter OOM problems.

Maybe the better solution would be, to not increment NR_FILE_PAGES,
when we have NR_SHMEM page? Should I rewrote and resend this patch?

Signed-off-by: Adrian Brzezinski <adrian.brzezinski@eo.pl>
---
 fs/proc/meminfo.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 5aa847a..d00aef5 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -40,7 +40,12 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
        allowed = ((totalram_pages - hugetlb_total_pages())
                * sysctl_overcommit_ratio / 100) + total_swap_pages;

+       /*
+        * NR_SHMEM pages can't be treated as a cache,
+        * but they are counted in NR_FILE_PAGES
+        */
        cached = global_page_state(NR_FILE_PAGES) -
+                       global_page_state(NR_SHMEM) -
                        total_swapcache_pages() - i.bufferram;
        if (cached < 0)
                cached = 0;
@@ -59,6 +64,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
                "Buffers:        %8lu kB\n"
                "Cached:         %8lu kB\n"
                "SwapCached:     %8lu kB\n"
+               "PageCache:      %8lu kB\n"
                "Active:         %8lu kB\n"
                "Inactive:       %8lu kB\n"
                "Active(anon):   %8lu kB\n"
@@ -111,6 +117,7 @@ static int meminfo_proc_show(struct seq_file *m,
void *v)
                K(i.bufferram),
                K(cached),
                K(total_swapcache_pages()),
+               K(global_page_state(NR_FILE_PAGES)),
                K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
                K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE]),
                K(pages[LRU_ACTIVE_ANON]),
--
1.7.1
