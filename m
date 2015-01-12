Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbbALSmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:42:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbbALSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 182/216] dm thin: fix inability to discard blocks when in out-of-data-space mode
Date: Mon, 12 Jan 2015 18:29:20 +0000
Message-Id: <1421087394-2712-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 45ec9bd0fd7abf8705e7cf12205ff69fe9d51181 upstream.

When the pool was in PM_OUT_OF_SPACE mode its process_prepared_discard
function pointer was incorrectly being set to
process_prepared_discard_passdown rather than process_prepared_discard.

This incorrect function pointer meant the discard was being passed down,
but not effecting the mapping.  As such any discard that was issued, in
an attempt to reclaim blocks, would not successfully free data space.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6f75083a81cc..c13efb1020d9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1759,7 +1759,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_discard;
 		pool->process_prepared_mapping = process_prepared_mapping;
-		pool->process_prepared_discard = process_prepared_discard_passdown;
+		pool->process_prepared_discard = process_prepared_discard;
 
 		if (!pool->pf.error_if_no_space && no_space_timeout)
 			queue_delayed_work(pool->wq, &pool->no_space_timeout, no_space_timeout);
-- 
2.1.4

