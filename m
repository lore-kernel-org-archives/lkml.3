Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaHALSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:18:24 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:44246 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHALSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:18:23 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com,
        Jianyu Zhan <Jianyu.Zhan@emc.com>
Subject: [PATCH RFC] sysfs: fix the race of "parent deleted before child added"
Date: Fri,  1 Aug 2014 19:18:12 +0800
Message-Id: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianyu Zhan <Jianyu.Zhan@emc.com>

I've met such a race conditon the same as what commit 3a198886
("sysfs: handle 'parent deleted before child added'") tackled.

The senario got triggered under a torturing test of quick disk
removal and plugging.

The forementioned commit 3a198886 didn't really fix this race,
it just narrows down the racy window.

A proper fix for this is to pin the parent kernfs_node on the
dir_entry creation point (sysfs_create_dir_ns), and to de-pin the parent
on the dir_entry deletion point(sysfs_remove_dir).

Though Tejun has added a comment in sysfs_remove_dir to warn such a
race and leave the option to upper layer. But wrt correct logic point,
I think it is good to add such pin behavior.

Note. another commit 26ea12de("kobject: grab an extra reference on kobject->sd
to allow duplicate deletes") also adds such a pin at the kobject layer.
But this commit tackles different issue - it pins an entry(not its parent)
after its creation, to allow duplicate deletions.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 fs/sysfs/dir.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0b45ff4..0ac82cd 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -49,7 +49,12 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 	else
 		parent = sysfs_root_kn;
 
-	if (!parent)
+	/*
+	 * We might race with the parent node removal.
+	 * To avoid such race and for logic correctness,
+	 * we pin the parent node here.
+	 */
+	if (!sysfs_get(parent))
 		return -ENOENT;
 
 	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
@@ -94,6 +99,10 @@ void sysfs_remove_dir(struct kobject *kobj)
 
 	if (kn) {
 		WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
+		/*
+		 * Drop our pin on parent
+		 */
+		sysfs_put(kn->parent);
 		kernfs_remove(kn);
 	}
 }
-- 
2.0.1.472.g6f92e5f

