Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbaCEOgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:36:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41238 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbaCEO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/131] dm thin: fix the error path for the thin device constructor
Date: Wed,  5 Mar 2014 14:23:51 +0000
Message-Id: <1394029455-23128-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 1acacc0784aab45627b6009e0e9224886279ac0b upstream.

dm_pool_close_thin_device() must be called if dm_set_target_max_io_len()
fails in thin_ctr().  Otherwise __pool_destroy() will fail because the
pool will still have an open thin device:

 device-mapper: thin metadata: attempt to close pmd when 1 device(s) are still open
 device-mapper: thin: __pool_destroy: dm_pool_metadata_close() failed.

Also, must establish error code if failing thin_ctr() because the pool
is in fail_io mode.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 9189838..b75f2a4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2812,6 +2812,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	if (get_pool_mode(tc->pool) == PM_FAIL) {
 		ti->error = "Couldn't open thin device, Pool is in fail mode";
+		r = -EINVAL;
 		goto bad_thin_open;
 	}
 
@@ -2823,7 +2824,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
 	if (r)
-		goto bad_thin_open;
+		goto bad_target_max_io_len;
 
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
@@ -2844,6 +2845,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	return 0;
 
+bad_target_max_io_len:
+	dm_pool_close_thin_device(tc->td);
 bad_thin_open:
 	__pool_dec(tc->pool);
 bad_pool_lookup:
-- 
1.9.0

