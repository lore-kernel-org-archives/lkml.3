Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaAGEBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 23:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbaAGEBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 23:01:40 -0500
Date: Mon, 6 Jan 2014 23:01:22 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>,
        linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        mingo@kernel.org
Subject: Re: kobject: provide kobject_put_wait to fix module unload race
In-Reply-To: <20140106213111.GA2536@redhat.com>
Message-ID: <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com> <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
 <20140106213111.GA2536@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Jan 2014, Mike Snitzer wrote:

> On Mon, Jan 06 2014 at  1:55pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Sun, 5 Jan 2014, Greg Kroah-Hartman wrote:
> > 
> > > On Sun, Jan 05, 2014 at 05:43:56PM +0100, Bart Van Assche wrote:
> > > > On 01/04/14 19:06, Mikulas Patocka wrote:
> > > > > -	if (t && !t->release)
> > > > > -		pr_debug("kobject: '%s' (%p): does not have a release() "
> > > > > -			 "function, it is broken and must be fixed.\n",
> > > > > -			 kobject_name(kobj), kobj);
> > > > > -
> > > > 
> > > > Has it been considered to issue a warning if no release function has
> > > > been defined and free_completion == NULL instead of removing the above
> > > > debug message entirely ? I think even with this patch applied it is
> > > > still wrong to invoke kobject_put() on an object without defining a
> > > > release function.
> > > 
> > > This patch isn't going to be applied, and I've reverted the original
> > > commit, so there shouldn't be any issues anymore with this code.
> > 
> > Why? This patch does the same thing as 
> > eee031649707db3c9920d9498f8d03819b74fc23, but it's smaller. So why did you 
> > accept eee031649707db3c9920d9498f8d03819b74fc23 and not this?
> > 
> > The code to wait for kobject destruction using completion already exists 
> > in cpufreq_sysfs_release, cpuidle_sysfs_release, 
> > cpuidle_state_sysfs_release, cpuidle_driver_sysfs_release, 
> > ext4_sb_release, ext4_feat_release, f2fs_sb_release (these are the only 
> > kobject users that are correct w.r.t. module unloading), so if you accept 
> > this patch, you can simplify them to use kobject_put_wait.
> 
> Hi Mikulas,
> 
> Please just submit a DM-only patch that follows the same racey pattern
> of firing a completion from the kobj_type .release method in dm_mod.
> I'll get it queued up for 3.14.
> 
> If/when we gets reports of a crash due to dm_mod unload racing with
> kobject_put we can revisit this.
> 
> Thanks,
> Mike

Here I'm sending dm-only patch.



dm: wait until kobject is destroyed

There may be other parts of the kernel taking reference to the dm kobject.
We must wait until they drop the references before deallocating the md
structure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-sysfs.c |   10 +++++++++-
 drivers/md/dm.c       |   11 +++++++++++
 drivers/md/dm.h       |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

Index: linux-3.13-rc7/drivers/md/dm-sysfs.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm-sysfs.c	2014-01-07 02:06:08.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm-sysfs.c	2014-01-07 02:07:09.000000000 +0100
@@ -79,6 +79,11 @@ static const struct sysfs_ops dm_sysfs_o
 	.show	= dm_attr_show,
 };
 
+static void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
@@ -86,6 +91,7 @@ static const struct sysfs_ops dm_sysfs_o
 static struct kobj_type dm_ktype = {
 	.sysfs_ops	= &dm_sysfs_ops,
 	.default_attrs	= dm_attrs,
+	.release	= dm_kobject_release,
 };
 
 /*
@@ -104,5 +110,7 @@ int dm_sysfs_init(struct mapped_device *
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
-	kobject_put(dm_kobject(md));
+	struct kobject *kobj = dm_kobject(md);
+	kobject_put(kobj);
+	wait_for_completion(dm_get_completion_from_kobject(kobj));
 }
Index: linux-3.13-rc7/drivers/md/dm.c
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm.c	2014-01-07 02:07:09.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm.c	2014-01-07 04:58:37.000000000 +0100
@@ -203,6 +203,9 @@ struct mapped_device {
 	/* sysfs handle */
 	struct kobject kobj;
 
+	/* wait until the kobject is released */
+	struct completion kobj_completion;
+
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
 
@@ -2049,6 +2052,7 @@ static struct mapped_device *alloc_dev(i
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
+	init_completion(&md->kobj_completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2931,6 +2935,13 @@ struct mapped_device *dm_get_from_kobjec
 	return md;
 }
 
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
+
+	return &md->kobj_completion;
+}
+
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
Index: linux-3.13-rc7/drivers/md/dm.h
===================================================================
--- linux-3.13-rc7.orig/drivers/md/dm.h	2014-01-07 02:06:08.000000000 +0100
+++ linux-3.13-rc7/drivers/md/dm.h	2014-01-07 02:07:09.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/completion.h>
 
 #include "dm-stats.h"
 
@@ -152,6 +153,7 @@ int dm_sysfs_init(struct mapped_device *
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
+struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings
