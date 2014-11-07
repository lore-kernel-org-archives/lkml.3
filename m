Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaKGDY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:24:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15994 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:24:27 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <tj@kernel.org>, <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH] sysfs: driver core: Fix glue dir race condition by gdp_mutex
Date: Fri, 7 Nov 2014 12:05:49 +0800
Message-ID: <1415333149-13099-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
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

This is a "classic" problem we have of a kref in a list
that can be found while the last instance could be removed
at the same time.

This patch reuse gdp_mutex to fix this race condition.

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
 drivers/base/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 14d1629..842d047 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -724,12 +724,12 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
 	return &dir->kobj;
 }
 
+static DEFINE_MUTEX(gdp_mutex);
 
 static struct kobject *get_device_parent(struct device *dev,
 					 struct device *parent)
 {
 	if (dev->class) {
-		static DEFINE_MUTEX(gdp_mutex);
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
 		struct kobject *k;
@@ -793,7 +793,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 	    glue_dir->kset != &dev->class->p->glue_dirs)
 		return;
 
+	mutex_lock(&gdp_mutex);
 	kobject_put(glue_dir);
+	mutex_unlock(&gdp_mutex);
 }
 
 static void cleanup_device_parent(struct device *dev)
-- 
1.7.1

