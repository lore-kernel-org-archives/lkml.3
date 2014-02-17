Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaBQLL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:11:58 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42913 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBQLL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:11:57 -0500
From: Bob Liu <lliubbo@gmail.com>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] drivers:xen-selfballoon:reset 'frontswap_inertia_counter' after frontswap_shrink
Date: Mon, 17 Feb 2014 19:11:39 +0800
Message-Id: <1392635499-24878-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I looked at this issue https://lkml.org/lkml/2013/11/21/158, I found that
frontswap_selfshrink() doesn't work as expected sometimes.
Pages are continuously added to frontswap and gotten back soon. It's a waste of
cpu time and increases the memory pressue of Guest OS.

Take an example.
First time in frontswap_selfshrink():
1. last_frontswap_pages = cur_frontswap_pages = 0
2. cur_frontswap_pages  = frontswap_curr_pages() = 100

When 'frontswap_inertia_counter' decreased to 0:
1. last_frontswap_pages = cur_frontswap_pages = 100
2. cur_frontswap_pages = frontswap_curr_pages() = 100
3. call frontswap_shrink() and let's assumption that 10 pages are gotten back
   from frontswap.
4. now frontswap_curr_pages() is 90.

If then memory is not enough in Guest OS and 9 more pages(smaller than gotten
back) added to frontswap.
Now frontswap_curr_pages() is 99 and we don't expect to get back more pages from
frontswap because geust os is under memory pressure.

But next time in frontswap_selfshrink():
1. last_frontswap_pages is set to the old value of cur_frontswap_pages(still
   100)
2. cur_frontswap_pages(99) is still smaller than last_frontswap_pages.
3. call frontswap_shrink() and continue to get back pages from frontswap!!

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/xen/xen-selfballoon.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 21e18c1..bd0b416 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -170,6 +170,7 @@ static void frontswap_selfshrink(void)
 		tgt_frontswap_pages = cur_frontswap_pages -
 			(cur_frontswap_pages / frontswap_hysteresis);
 	frontswap_shrink(tgt_frontswap_pages);
+	frontswap_inertia_counter = frontswap_inertia;
 }
 
 #endif /* CONFIG_FRONTSWAP */
-- 
1.7.10.4

