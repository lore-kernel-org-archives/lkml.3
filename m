Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaFPVIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:08:19 -0400
Received: from mail-wi0-f201.google.com ([209.85.212.201]:65529 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaFPVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:08:18 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Christoph Lameter <clameter@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] mm: page_alloc: simplify drain_zone_pages by using min()
Date: Mon, 16 Jun 2014 23:08:14 +0200
Message-Id: <1402952894-13200-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding getting minimal value of two, just use min macro.
That is why it is there for.  While changing the function also change
type of batch local variable to match type of per_cpu_pages::batch
(which is int).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..26aa003 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1224,15 +1224,11 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	unsigned long flags;
-	int to_drain;
-	unsigned long batch;
+	int to_drain, batch;
 
 	local_irq_save(flags);
 	batch = ACCESS_ONCE(pcp->batch);
-	if (pcp->count >= batch)
-		to_drain = batch;
-	else
-		to_drain = pcp->count;
+	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		free_pcppages_bulk(zone, to_drain, pcp);
 		pcp->count -= to_drain;
-- 
2.0.0.526.g5318336

