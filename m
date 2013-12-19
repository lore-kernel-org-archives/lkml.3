Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3LSL7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3LSL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/208] dm thin: re-establish read-only state when switching to fail mode
Date: Thu, 19 Dec 2013 11:54:34 +0000
Message-Id: <1387454106-19326-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 5383ef3a929a1366e2ced45cd6d74be7aa2a2281 upstream.

If the thin-pool transitioned to fail mode and the thin-pool's table
were reloaded for some reason: the new table's default pool mode would
be read-write, though it will transition to fail mode during resume.

When the pool mode transitions directly from PM_WRITE to PM_FAIL we need
to re-establish the intermediate read-only state in both the metadata
and persistent-data block manager (as is usually done with the normal
pool mode transition sequence: PM_WRITE -> PM_READ_ONLY -> PM_FAIL).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e36f81e..930a7e3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1389,6 +1389,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 	switch (mode) {
 	case PM_FAIL:
 		DMERR("switching pool to failure mode");
+		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
-- 
1.8.3.2

