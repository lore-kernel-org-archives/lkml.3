Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaJIMoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:44:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38453 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJIMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:44:16 -0400
Message-ID: <54368308.90202@huawei.com>
Date: Thu, 9 Oct 2014 20:43:52 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, <tom.leiming@gmail.com>,
        <tj@kernel.org>
CC: <tt.rantala@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Qiang <h.huangqiang@huawei.com>, "Li Zefan" <lizefan@huawei.com>
Subject: kernel BUG at fs/sysfs/group.c:65!
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I see the mails you discussed the BUG at fs/sysfs/group.c:65! triggered by duplicated sysfs link.

the detail mail:

https://lkml.org/lkml/2013/3/8/370

but it seems the problems has no conclusion. In our environment, we triggered the bug too, but for error ENOENT:

we use 3.4 kernel, and do virtual disk device create / remove for many times. Before remove we can see the devices:

#ll /sys/devices/virtual/block/
drwxr-xr-x 7 root root 0 Oct  6 09:17 sd-1a
drwxr-xr-x 7 root root 0 Oct  6 09:17 sd-2a

when the two virtual devices were removed, the directory block/ was delete too.

after many times create / remove, the kernel trigger the bug (just the main call trace):

[ 3965.441713] WARNING: at /usr/src/packages/BUILD/linux-3.4/lib/kobject.c:202 kobject_add_internal+0x11f/0x280()
[ 3965.441716] Hardware name: Romley
[ 3965.441718] kobject_add_internal failed for sd-1a (error: -2 parent: block)

[ 3965.441817] Call Trace:
[ 3965.441820]  [<ffffffff8103717a>] warn_slowpath_common+0x7a/0xb0
[ 3965.441823]  [<ffffffff81037251>] warn_slowpath_fmt+0x41/0x50
[ 3965.441826]  [<ffffffff81215e0f>] kobject_add_internal+0x11f/0x280
[ 3965.441830]  [<ffffffff81216267>] kobject_add+0x67/0xc0
[ 3965.441833]  [<ffffffff812d2305>] device_add+0x105/0x6d0
[ 3965.441836]  [<ffffffff812d0dbc>] ? dev_set_name+0x3c/0x40
[ 3965.441839]  [<ffffffff812030ac>] add_disk+0x1bc/0x490

[ 3965.441912] kernel BUG at /usr/src/packages/BUILD/linux-3.4/fs/sysfs/group.c:65!
[ 3965.441915] invalid opcode: 0000 [#1] SMP
[ 3965.686738] Call Trace:
[ 3965.686743]  [<ffffffff811a677e>] sysfs_create_group+0xe/0x10
[ 3965.686748]  [<ffffffff810cfb04>] blk_trace_init_sysfs+0x14/0x20
[ 3965.686753]  [<ffffffff811fcabb>] blk_register_queue+0x3b/0x120
[ 3965.686756]  [<ffffffff812030bc>] add_disk+0x1cc/0x490

from the error "kobject_add_internal failed for sd-1a (error: -2 parent: block)", we found that the first
warning was caused by the disk device's parent_sd was null when it was added into sysfs:

int sysfs_create_dir(struct kobject * kobj)
{
    ...
    if (kobj->parent)
        parent_sd = kobj->parent->sd;
    else
        parent_sd = &sysfs_root;

    if (!parent_sd)
        return -ENOENT;
    ...
}

The virtual disk device was not added into sysfs because of the above failure, and the kobj->sd was
not set, then trigger the bug when creating attribute group under the device's directory:

static int internal_create_group(struct kobject *kobj, int update,
                 const struct attribute_group *grp)
{
    ...
    BUG_ON(!kobj || (!update && !kobj->sd));
    ...
}

Walk the code, it seems there maybe a race between block/ remove and virtual disk devices' register:

when the two virtual devices were removed, the block/ directory's refcount became 0, will into:

path0(remove the block/)                                             path1(register virtual device sd-1a)

kobject_del(){                                                       get_device_parent(){
...                                                                  ...
   sysfs_remove_dir(kobj);  //kobj->sd=0                                 spin_lock(&dev->class->p->glue_dirs.list_lock);
...                                                      <=========      list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)  //get parent kobject from kset list
   kobj_kset_leave(kobj);   //remove kobj from kset list             ...
}                                                                    }

If getting parent object between " kobj->sd=0 " and "remove_kset_leave(kobj)", the sysfs_create_dir() will return ENOENT and trigger the BUG later.

The lastest kernel seems to be the same. But I am not familiar with block device, I am not sure whether the analysis is right or I am missing something.
what do you think about this situation? Any suggestion is appreciative. Thanks!



