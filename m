Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaBGLrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:47:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaBGLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/233] dm thin: switch to read-only mode if metadata space is exhausted
Date: Fri,  7 Feb 2014 11:43:48 +0000
Message-Id: <1391773652-25214-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 4a02b34e0cf1d0d0dd3737702841da4bf615a50a upstream.

Switch the thin pool to read-only mode in alloc_data_block() if
dm_pool_alloc_data_block() fails because the pool's metadata space is
exhausted.

Differentiate between data and metadata space in messages about no
free space available.

This issue was noticed with the device-mapper-test-suite using:
dmtest run --suite thin-provisioning -n /exhausting_metadata_space_causes_fail_mode/

The quantity of errors logged in this case must be reduced.

before patch:

device-mapper: thin: 253:4: reached low water mark for metadata device: sending event.
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
<snip ... these repeat for a _very_ long while ... >
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: commit failed: error = -28
device-mapper: thin: 253:4: switching pool to read-only mode

after patch:

device-mapper: thin: 253:4: reached low water mark for metadata device: sending event.
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: no free metadata space available.
device-mapper: thin: 253:4: switching pool to read-only mode

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 203c104..49ec256 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -951,7 +951,7 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 			 * doing all this checking and return -ENOSPC.
 			 */
 			if (!free_blocks) {
-				DMWARN("%s: no free space available.",
+				DMWARN("%s: no free data space available.",
 				       dm_device_name(pool->pool_md));
 				spin_lock_irqsave(&pool->lock, flags);
 				pool->no_free_space = 1;
@@ -962,8 +962,16 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 	}
 
 	r = dm_pool_alloc_data_block(pool->pmd, result);
-	if (r)
+	if (r) {
+		if (r == -ENOSPC &&
+		    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
+		    !free_blocks) {
+			DMWARN("%s: no free metadata space available.",
+			       dm_device_name(pool->pool_md));
+			set_pool_mode(pool, PM_READ_ONLY);
+		}
 		return r;
+	}
 
 	return 0;
 }
-- 
1.8.3.2

