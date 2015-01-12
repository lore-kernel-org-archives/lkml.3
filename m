Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbbALSxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:53:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbbALSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 151/216] dm space map metadata: fix sm_bootstrap_get_nr_blocks()
Date: Mon, 12 Jan 2015 18:28:49 +0000
Message-Id: <1421087394-2712-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c1c6156fe4d4577444b769d7edd5dd503e57bbc9 upstream.

This function isn't right and it causes a static checker warning:

	drivers/md/dm-thin.c:3016 maybe_resize_data_dev()
	error: potentially using uninitialized 'sb_data_size'.

It should set "*count" and return zero on success the same as the
sm_metadata_get_nr_blocks() function does earlier.

Fixes: 3241b1d3e0aa ('dm: add persistent data library')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 786b689bdfc7..f4e22bcc7fb8 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -564,7 +564,9 @@ static int sm_bootstrap_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	return smm->ll.nr_blocks;
+	*count = smm->ll.nr_blocks;
+
+	return 0;
 }
 
 static int sm_bootstrap_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
-- 
2.1.4

