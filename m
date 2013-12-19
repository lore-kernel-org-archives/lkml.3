Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3LSMDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:03:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab3LSMAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 201/208] dm array: fix a reference counting bug in shadow_ablock
Date: Thu, 19 Dec 2013 11:54:59 +0000
Message-Id: <1387454106-19326-202-git-send-email-luis.henriques@canonical.com>
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

commit ed9571f0cf1fe09d3506302610f3ccdfa1d22c4a upstream.

An old array block could have its reference count decremented below
zero when it is being replaced in the btree by a new array block.

The fix is to increment the old ablock's reference count just before
inserting a new ablock into the btree.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/persistent-data/dm-array.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index af96e24..1d75b1d 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -317,8 +317,16 @@ static int shadow_ablock(struct dm_array_info *info, dm_block_t *root,
 	 * The shadow op will often be a noop.  Only insert if it really
 	 * copied data.
 	 */
-	if (dm_block_location(*block) != b)
+	if (dm_block_location(*block) != b) {
+		/*
+		 * dm_tm_shadow_block will have already decremented the old
+		 * block, but it is still referenced by the btree.  We
+		 * increment to stop the insert decrementing it below zero
+		 * when overwriting the old value.
+		 */
+		dm_tm_inc(info->btree_info.tm, b);
 		r = insert_ablock(info, index, *block, root);
+	}
 
 	return r;
 }
-- 
1.8.3.2

