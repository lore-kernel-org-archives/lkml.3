Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaI1PFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:05:13 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:42935 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaI1PFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:05:11 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com (maintainer:DEVICE-MAPPER (LVM)),
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [RESEND PATCH] drivers/md: Use rcu_dereference() for accessing rcu pointer
Date: Sun, 28 Sep 2014 11:05:04 -0400
Message-Id: <1411916712-17631-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got Paul's email wrong the first time.

The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
while accessing it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 746411b..fbdf0bb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2211,7 +2211,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	merge_is_optional = dm_table_merge_is_optional(t);
 
-	old_map = md->map;
+	old_map = rcu_dereference(md->map);
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
@@ -2230,7 +2230,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
  */
 static struct dm_table *__unbind(struct mapped_device *md)
 {
-	struct dm_table *map = md->map;
+	struct dm_table *map = rcu_dereference(md->map);
 
 	if (!map)
 		return NULL;
@@ -2624,7 +2624,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2718,7 +2718,7 @@ int dm_resume(struct mapped_device *md)
 	if (!dm_suspended_md(md))
 		goto out;
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
-- 
1.9.1

