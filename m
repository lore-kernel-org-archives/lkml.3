Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaJOGnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:43:25 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:6123 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOGnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:43:24 -0400
Message-ID: <543E1754.8040701@huawei.com>
Date: Wed, 15 Oct 2014 14:42:28 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Xiang Rui <rui.xiang@huawei.com>,
        Li Zefan <lizefan@huawei.com>, Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Subject: [PATCH] kobject: fix the race between kobject_del and get_device_parent
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.543E1780.00D5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: b1f122a450a1ea4eb8b2f45c1b4debd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the last child kobject was deleted, it's parent kobject will be deleted,
when removing the parent kobject if the parent kobject's sd has been set NULL
and still not been removed from it's kset's list, at the same time another one
trigger an device adding event, the function get_parent_device() will get the
parent object from the kset's list for kobject_add(), but this time parent
kobject's sd has been NULL. This race will make the sysfs_create_dir() return
ENOENT, the new kobject will be failed to added into sysfs and trigger BUG()
when creating attribute group under the new device's directory. So move the
kobject removal from kset's list before kobj->sd=NULL.

The race situation:

path0(remove parent kobj, e.g:/sys/devices/virtual/block/)   path1(register a new device)

kobject_del(){                                               get_device_parent(){
...                                                          ...
sysfs_remove_dir(kobj);  //kobj->sd=NULL                     spin_lock(&dev->class->p->glue_dirs.list_lock);
...                                                  <===    list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
kobj_kset_leave(kobj);   //remove kobj from kset list        ...
}                                                           }


We had triggered the bug, the detail message link:
https://lkml.org/lkml/2014/10/13/40

Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
---
 lib/kobject.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 58751bb..af2b7bb 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -560,12 +560,13 @@ void kobject_del(struct kobject *kobj)
 	if (!kobj)
 		return;

+	kobj_kset_leave(kobj);
+
 	sd = kobj->sd;
 	sysfs_remove_dir(kobj);
 	sysfs_put(sd);

 	kobj->state_in_sysfs = 0;
-	kobj_kset_leave(kobj);
 	kobject_put(kobj->parent);
 	kobj->parent = NULL;
 }
-- 
1.8.2.2

