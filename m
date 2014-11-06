Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaKFHfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:35:09 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:15364 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFHfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:35:04 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <tj@kernel.org>, <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH] sysfs: driver core: Fix glue dir race condition
Date: Thu, 6 Nov 2014 16:16:38 +0800
Message-ID: <1415261798-9671-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.545B24A6.00F4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 20b3d989dede07c2f78a37b892592c5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition when removing glue directory.
It can be reproduced in following test:

path 1: Add first child device
device_add()
	get_device_parent()
		/*find parent from glue_dirs.list*/
		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
			if (k->parent == parent_kobj) {
				kobj = kobject_get(k);
				break;
			}
		....
		class_dir_create_and_add()

path2: Remove last child device under glue dir
device_del()
	cleanup_device_parent()
		cleanup_glue_dir()
			kobject_put(glue_dir);

If path2 has been called cleanup_glue_dir(), but not
call kobject_put(glue_dir), the glue dir is still
in parent's kset list. Meanwhile, path1 find the glue
dir from the glue_dirs.list. Path2 may release glue dir
before path1 call kobject_get(). So kernel will report
the warning and bug_on.

This fix keep glue dir around once it created suggested
by Tejun Heo.

The following calltrace is captured in kernel 3.4, but
the latest kernel still has this bug.

-----------------------------------------------------
<4>[ 3965.441471] WARNING: at ...include/linux/kref.h:41 kobject_get+0x33/0x40()
<4>[ 3965.441474] Hardware name: Romley
<4>[ 3965.441475] Modules linked in: isd_iop(O) isd_xda(O)...
...
<4>[ 3965.441605] Call Trace:
<4>[ 3965.441611]  [<ffffffff8103717a>] warn_slowpath_common+0x7a/0xb0
<4>[ 3965.441615]  [<ffffffff810371c5>] warn_slowpath_null+0x15/0x20
<4>[ 3965.441618]  [<ffffffff81215963>] kobject_get+0x33/0x40
<4>[ 3965.441624]  [<ffffffff812d1e45>] get_device_parent.isra.11+0x135/0x1f0
<4>[ 3965.441627]  [<ffffffff812d22d4>] device_add+0xd4/0x6d0
<4>[ 3965.441631]  [<ffffffff812d0dbc>] ? dev_set_name+0x3c/0x40
....
<2>[ 3965.441912] kernel BUG at ..../fs/sysfs/group.c:65!
<4>[ 3965.441915] invalid opcode: 0000 [#1] SMP
...
<4>[ 3965.686743]  [<ffffffff811a677e>] sysfs_create_group+0xe/0x10
<4>[ 3965.686748]  [<ffffffff810cfb04>] blk_trace_init_sysfs+0x14/0x20
<4>[ 3965.686753]  [<ffffffff811fcabb>] blk_register_queue+0x3b/0x120
<4>[ 3965.686756]  [<ffffffff812030bc>] add_disk+0x1cc/0x490
....
-------------------------------------------------------

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Cc: <stable@vger.kernel.org> #3.4+
---
 drivers/base/core.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 14d1629..5b7a3e9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -761,7 +761,7 @@ static struct kobject *get_device_parent(struct device *dev,
 		spin_lock(&dev->class->p->glue_dirs.list_lock);
 		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
 			if (k->parent == parent_kobj) {
-				kobj = kobject_get(k);
+				kobj = k;
 				break;
 			}
 		spin_unlock(&dev->class->p->glue_dirs.list_lock);
@@ -786,21 +786,6 @@ static struct kobject *get_device_parent(struct device *dev,
 	return NULL;
 }
 
-static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
-{
-	/* see if we live in a "glue" directory */
-	if (!glue_dir || !dev->class ||
-	    glue_dir->kset != &dev->class->p->glue_dirs)
-		return;
-
-	kobject_put(glue_dir);
-}
-
-static void cleanup_device_parent(struct device *dev)
-{
-	cleanup_glue_dir(dev, dev->kobj.parent);
-}
-
 static int device_add_class_symlinks(struct device *dev)
 {
 	int error;
@@ -1094,7 +1079,6 @@ done:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
-	cleanup_device_parent(dev);
 	if (parent)
 		put_device(parent);
 name_error:
@@ -1215,7 +1199,6 @@ void device_del(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_REMOVED_DEVICE, dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
-	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
 	put_device(parent);
 }
@@ -1873,7 +1856,6 @@ int device_move(struct device *dev, struct device *new_parent,
 		 __func__, new_parent ? dev_name(new_parent) : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
-		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
 		goto out;
 	}
@@ -1902,7 +1884,6 @@ int device_move(struct device *dev, struct device *new_parent,
 					set_dev_node(dev, dev_to_node(old_parent));
 				}
 			}
-			cleanup_glue_dir(dev, new_parent_kobj);
 			put_device(new_parent);
 			goto out;
 		}
-- 
1.7.1

