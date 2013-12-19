Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3LSML0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:11:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3LSL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 175/208] dm thin: switch to read only mode if a mapping insert fails
Date: Thu, 19 Dec 2013 11:54:33 +0000
Message-Id: <1387454106-19326-176-git-send-email-luis.henriques@canonical.com>
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

commit fafc7a815e40255d24e80a1cb7365892362fa398 upstream.

Switch the thin pool to read-only mode when dm_thin_insert_block() fails
since there is little reason to expect the cause of the failure to be
resolved without further action by user space.

This issue was noticed with the device-mapper-test-suite using:
dmtest run --suite thin-provisioning -n /exhausting_metadata_space_causes_fail_mode/

The quantity of errors logged in this case must be reduced.

before patch:

device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
<snip ... these repeat for a long while ... >
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: thin: 253:4: no free metadata space available.
device-mapper: thin: 253:4: switching pool to read-only mode

after patch:

device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: dm_thin_insert_block() failed: error = -28
device-mapper: thin: 253:4: switching pool to read-only mode

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 88f2f80..e36f81e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -640,7 +640,9 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 */
 	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
 	if (r) {
-		DMERR_LIMIT("dm_thin_insert_block() failed");
+		DMERR_LIMIT("%s: dm_thin_insert_block() failed: error = %d",
+			    dm_device_name(pool->pool_md), r);
+		set_pool_mode(pool, PM_READ_ONLY);
 		cell_error(pool, m->cell);
 		goto out;
 	}
-- 
1.8.3.2

