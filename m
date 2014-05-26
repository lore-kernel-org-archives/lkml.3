Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaEZCCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 22:02:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54689 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaEZCCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 22:02:42 -0400
From: Chen Yucong <slaoub@gmail.com>
To: akpm@linux-foundation.org
Cc: ddstreet@ieee.org, mgorman@suse.de, hughd@google.com, shli@kernel.org,
        k.kozlowski@samsung.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] swap: Avoid scanning invalidated region for cheap seek
Date: Mon, 26 May 2014 10:00:59 +0800
Message-Id: <1401069659-29589-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cheap seek, when we scan the region between si->lowset_bit
and scan_base, if san_base is greater than si->highest_bit, the
scan operation between si->highest_bit and scan_base is not
unnecessary.

This patch can be used to avoid scanning invalidated region for
cheap seek.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mm/swapfile.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index beeeef8..7f0f27e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -489,6 +489,7 @@ static unsigned long scan_swap_map(struct swap_info_struct *si,
 {
 	unsigned long offset;
 	unsigned long scan_base;
+	unsigned long upper_bound;
 	unsigned long last_in_cluster = 0;
 	int latency_ration = LATENCY_LIMIT;
 
@@ -551,9 +552,11 @@ static unsigned long scan_swap_map(struct swap_info_struct *si,
 
 		offset = si->lowest_bit;
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
+		upper_bound = (scan_base <= si->highest_bit) ?
+				scan_base : (si->highest_bit + 1);
 
 		/* Locate the first empty (unaligned) cluster */
-		for (; last_in_cluster < scan_base; offset++) {
+		for (; last_in_cluster < upper_bound; offset++) {
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
-- 
1.7.10.4

