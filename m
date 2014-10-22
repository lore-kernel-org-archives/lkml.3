Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaJVIKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:10:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45853 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJVIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:10:02 -0400
Message-ID: <544765D0.70302@huawei.com>
Date: Wed, 22 Oct 2014 16:07:44 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Frans Klaver <fransklaver@gmail.com>, <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Wangyijing <wangyijing@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543E1754.8040701@huawei.com> <543F25D3.8010708@huawei.com> <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com> <543F7289.8010807@huawei.com> <20141016091328.GB24374@kroah.com>
In-Reply-To: <20141016091328.GB24374@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/16 17:13, Greg KH wrote:
> On Thu, Oct 16, 2014 at 03:23:53PM +0800, Weng Meiling wrote:
>> On 2014/10/16 15:07, Frans Klaver wrote:
>>> On Thu, Oct 16, 2014 at 3:56 AM, Weng Meiling
>>> <wengmeiling.weng@huawei.com> wrote:
>>>>
>>>> Would you please give me some of your views on this issue? Any suggestion is appreciative.
>>>
>>> It'll come. Be patient.
>>>
>>> .
>>>
>> yeah, maybe I'm too impatient :)
> 
> *plonk*
> 
> .
> 

The former patch still can't fix the race. Tejun had commited a fix patch about
race in get_device_parent():

commit 77d3d7c1d561f49f755d7390f0764dff90765974
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Feb 5 17:57:02 2010 +0900

    driver-core: fix race condition in get_device_parent()

    sysfs is creating several devices in cuse class concurrently and with
    CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.

     BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
     IP: [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
     PGD 75bb067 PUD 75be067 PMD 0
     Oops: 0000 [#1] PREEMPT SMP
     last sysfs file: /sys/devices/system/cpu/cpu7/topology/core_siblings
     CPU 1
     Modules linked in: cuse fuse
     Pid: 4737, comm: osspd Not tainted 2.6.31-work #77
     RIP: 0010:[<ffffffff81158b0a>]  [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
     RSP: 0018:ffff88000042f8f8  EFLAGS: 00010296
     RAX: ffff88000042ffd8 RBX: 0000000000000000 RCX: 0000000000000000
     RDX: 0000000000000000 RSI: ffff880007eef660 RDI: 0000000000000001
     RBP: ffff88000042f918 R08: 0000000000000000 R09: 0000000000000000
     R10: 0000000000000001 R11: ffffffff81158b0a R12: ffff88000042f928
     R13: 00000000fffffff4 R14: 0000000000000000 R15: ffff88000042f9a0
     FS:  00007fe93905a950(0000) GS:ffff880008600000(0000) knlGS:0000000000000000
     CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
     CR2: 0000000000000038 CR3: 00000000077c9000 CR4: 00000000000006e0
     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
     DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
     Process osspd (pid: 4737, threadinfo ffff88000042e000, task ffff880007eef040)
     Stack:
      ffff880005da10e8 0000000011cc8d6e ffff88000042f928 ffff880003d28a28
     <0> ffff88000042f988 ffffffff811592d7 0000000000000000 0000000000000000
     <0> 0000000000000000 0000000000000000 ffff88000042f958 0000000011cc8d6e
     Call Trace:
      [<ffffffff811592d7>] create_dir+0x67/0xe0
      [<ffffffff811593a8>] sysfs_create_dir+0x58/0xb0
      [<ffffffff8128ca7c>] ? kobject_add_internal+0xcc/0x220
      [<ffffffff812942e1>] ? vsnprintf+0x3c1/0xb90
      [<ffffffff8128cab7>] kobject_add_internal+0x107/0x220
      [<ffffffff8128cd37>] kobject_add_varg+0x47/0x80
      [<ffffffff8128ce53>] kobject_add+0x53/0x90
      [<ffffffff81357d84>] device_add+0xd4/0x690
      [<ffffffff81356c2b>] ? dev_set_name+0x4b/0x70
      [<ffffffffa001a884>] cuse_process_init_reply+0x2b4/0x420 [cuse]
      ...

    The problem is that kobject_add_internal() first adds a kobject to the
    kset and then try to create sysfs directory for it.  If the creation
    fails, it remove the kobject from the kset.  get_device_parent()
    accesses class_dirs kset while only holding class_dirs.list_lock to
    see whether the cuse class dir exists.  But when it exists, it may not
    have finished initialization yet or may fail and get removed soon.  In
    the above case, the former happened so the second one ends up trying
    to create subdirectory under NULL sysfs_dirent.

    Fix it by grabbing a mutex in get_device_parent().

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Colin Guthrie <cguthrie@mandriva.org>
    Cc: stable <stable@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


But this patch didn't cover our situation. So maybe the following patch is more
suitable to fix the race:

Subject: [PATCH] kobject: fix the race between kobject_put and get_device_parent

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
---
 drivers/base/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 28b808c..645eacf 100644
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
1.8.2.2



