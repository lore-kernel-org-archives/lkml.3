Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbbAUGRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:17:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38730 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbbAUGOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:14:37 -0500
X-Original-SENDERIP: 10.177.222.143
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>, Juneho Choi <juno.choi@lge.com>,
        Gunho Lee <gunho.lee@lge.com>, Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 07/10] zsmalloc: adjust ZS_ALMOST_FULL
Date: Wed, 21 Jan 2015 15:14:23 +0900
Message-Id: <1421820866-26521-8-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421820866-26521-1-git-send-email-minchan@kernel.org>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Curretly, zsmalloc regards a zspage as ZS_ALMOST_EMPTY if the zspage
has under 1/4 used objects(ie, fullness_threshold_frac).
It could make result in loose packing since zsmalloc migrates
only ZS_ALMOST_EMPTY zspage out.

This patch changes the rule so that zsmalloc makes zspage which has
above 3/4 used object ZS_ALMOST_FULL so it could make tight packing.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 99bf5bd..8217e8e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -477,7 +477,7 @@ static enum fullness_group get_fullness_group(struct page *page)
 		fg = ZS_EMPTY;
 	else if (inuse == max_objects)
 		fg = ZS_FULL;
-	else if (inuse <= max_objects / fullness_threshold_frac)
+	else if (inuse <= 3 * max_objects / fullness_threshold_frac)
 		fg = ZS_ALMOST_EMPTY;
 	else
 		fg = ZS_ALMOST_FULL;
-- 
1.9.3

