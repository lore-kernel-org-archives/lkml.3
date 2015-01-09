Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbbAIKxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:53:21 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44517 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757396AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 46/78] dm space map metadata: fix sm_bootstrap_get_nr_blocks()
Date: Fri,  9 Jan 2015 11:31:55 +0100
Message-Id: <f55c16cdf8a425447bf529756e3b5d895fc2d1e9.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 579b58200bf2..d9a5aa532017 100644
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
2.2.1

