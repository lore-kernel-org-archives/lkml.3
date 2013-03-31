Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3CaBeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 21:34:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48210 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab3CaBeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:34:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: gpf in pm_qos_remote_wakeup_show
Date: Sun, 31 Mar 2013 03:41:11 +0200
Message-ID: <2829731.BFs3ri3Eud@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51576A0C.5030907@oracle.com>
References: <512F8980.4040809@oracle.com> <25276895.qZKN0MF88v@vostro.rjw.lan> <51576A0C.5030907@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Moving the thread to the LKML.]

On Saturday, March 30, 2013 06:41:16 PM Sasha Levin wrote:
> On 03/15/2013 01:06 PM, Rafael J. Wysocki wrote:
[...]
> >> Rafael, Is there anything you would like me to test?
> > 
> > Please just test 3.9-rc2 (or later).
> 
> Hi Rafael,

Hi,

> I got this after a bit of fuzzing, it looks related to the fix:

So the complaint is that we shouldn't call pm_qos_sysfs_remove_flags() under
dev_pm_qos_mtx, because then it may deadlock with dev_pm_qos_update_flags()
called from pm_qos_remote_wakeup_store(), for example.  This appears to be a
valid one.

To avoid that, we can use a separate mutex for exposing/hiding the flags
(and the latency limit too) that won't be acquired by dev_pm_qos_update_flags()
or dev_pm_qos_update_request().

Can you please try the patch below?

Rafael


> 
> [  241.995620] ======================================================
> [  241.999545] [ INFO: possible circular locking dependency detected ]
> [  242.000021] 3.9.0-rc4-next-20130328-sasha-00014-g91a3267 #319 Tainted: G        W
> [  242.000021] -------------------------------------------------------
> [  242.000021] trinity-child6/12371 is trying to acquire lock:
> [  242.000021]  (s_active#54){++++.+}, at: [<ffffffff81301631>] sysfs_addrm_finish+0x31/0x60
> [  242.000021]
> [  242.000021] but task is already holding lock:
> [  242.000021]  (dev_pm_qos_mtx){+.+.+.}, at: [<ffffffff81f07cc3>] dev_pm_qos_constraints_destroy+0x23/0x250
> [  242.000021]
> [  242.000021] which lock already depends on the new lock.
> [  242.000021]
> [  242.000021]
> [  242.000021] the existing dependency chain (in reverse order) is:
> [  242.000021]
> -> #1 (dev_pm_qos_mtx){+.+.+.}:
> [  242.000021]        [<ffffffff811811da>] lock_acquire+0x1aa/0x240
> [  242.000021]        [<ffffffff83dab809>] __mutex_lock_common+0x59/0x5e0
> [  242.000021]        [<ffffffff83dabebf>] mutex_lock_nested+0x3f/0x50
> [  242.000021]        [<ffffffff81f07f2f>] dev_pm_qos_update_flags+0x3f/0xc0
> [  242.000021]        [<ffffffff81f05f4f>] pm_qos_remote_wakeup_store+0x3f/0x70
> [  242.000021]        [<ffffffff81efbb43>] dev_attr_store+0x13/0x20
> [  242.000021]        [<ffffffff812ffdaa>] sysfs_write_file+0xfa/0x150
> [  242.000021]        [<ffffffff8127f2c1>] __kernel_write+0x81/0x150
> [  242.000021]        [<ffffffff812afc2d>] write_pipe_buf+0x4d/0x80
> [  242.000021]        [<ffffffff812af57c>] splice_from_pipe_feed+0x7c/0x120
> [  242.000021]        [<ffffffff812afa25>] __splice_from_pipe+0x45/0x80
> [  242.000021]        [<ffffffff812b14fc>] splice_from_pipe+0x4c/0x70
> [  242.000021]        [<ffffffff812b1538>] default_file_splice_write+0x18/0x30
> [  242.000021]        [<ffffffff812afae3>] do_splice_from+0x83/0xb0
> [  242.000021]        [<ffffffff812afb2e>] direct_splice_actor+0x1e/0x20
> [  242.000021]        [<ffffffff812b0277>] splice_direct_to_actor+0xe7/0x200
> [  242.000021]        [<ffffffff812b15bc>] do_splice_direct+0x4c/0x70
> [  242.038959]        [<ffffffff8127eda9>] do_sendfile+0x169/0x300
> [  242.038959]        [<ffffffff8127ff94>] SyS_sendfile64+0x64/0xb0
> [  242.038959]        [<ffffffff83db7d18>] tracesys+0xe1/0xe6
> [  242.038959]
> -> #0 (s_active#54){++++.+}:
> [  242.038959]        [<ffffffff811800cf>] __lock_acquire+0x15bf/0x1e50
> [  242.038959]        [<ffffffff811811da>] lock_acquire+0x1aa/0x240
> [  242.038959]        [<ffffffff81300aa2>] sysfs_deactivate+0x122/0x1a0
> [  242.038959]        [<ffffffff81301631>] sysfs_addrm_finish+0x31/0x60
> [  242.038959]        [<ffffffff812ff77f>] sysfs_hash_and_remove+0x7f/0xb0
> [  242.038959]        [<ffffffff813035a1>] sysfs_unmerge_group+0x51/0x70
> [  242.038959]        [<ffffffff81f068f4>] pm_qos_sysfs_remove_flags+0x14/0x20
> [  242.038959]        [<ffffffff81f07490>] __dev_pm_qos_hide_flags+0x30/0x70
> [  242.038959]        [<ffffffff81f07cd5>] dev_pm_qos_constraints_destroy+0x35/0x250
> [  242.038959]        [<ffffffff81f06931>] dpm_sysfs_remove+0x11/0x50
> [  242.038959]        [<ffffffff81efcf6f>] device_del+0x3f/0x1b0
> [  242.038959]        [<ffffffff81efd128>] device_unregister+0x48/0x60
> [  242.038959]        [<ffffffff82d4083c>] usb_hub_remove_port_device+0x1c/0x20
> [  242.038959]        [<ffffffff82d2a9cd>] hub_disconnect+0xdd/0x160
> [  242.038959]        [<ffffffff82d36ab7>] usb_unbind_interface+0x67/0x170
> [  242.038959]        [<ffffffff81f001a7>] __device_release_driver+0x87/0xe0
> [  242.038959]        [<ffffffff81f00559>] device_release_driver+0x29/0x40
> [  242.038959]        [<ffffffff81effc58>] bus_remove_device+0x148/0x160
> [  242.038959]        [<ffffffff81efd07f>] device_del+0x14f/0x1b0
> [  242.038959]        [<ffffffff82d344f9>] usb_disable_device+0xf9/0x280
> [  242.038959]        [<ffffffff82d34ff8>] usb_set_configuration+0x268/0x840
> [  242.038959]        [<ffffffff82d3a7fc>] usb_remove_store+0x4c/0x80
> [  242.038959]        [<ffffffff81efbb43>] dev_attr_store+0x13/0x20
> [  242.038959]        [<ffffffff812ffdaa>] sysfs_write_file+0xfa/0x150
> [  242.038959]        [<ffffffff8127f71d>] do_loop_readv_writev+0x4d/0x90
> [  242.038959]        [<ffffffff8127f999>] do_readv_writev+0xf9/0x1e0
> [  242.038959]        [<ffffffff8127faba>] vfs_writev+0x3a/0x60
> [  242.038959]        [<ffffffff8127fc60>] SyS_writev+0x50/0xd0
> [  242.038959]        [<ffffffff83db7d18>] tracesys+0xe1/0xe6
> [  242.038959]
> [  242.038959] other info that might help us debug this:
> [  242.038959]
> [  242.038959]  Possible unsafe locking scenario:
> [  242.038959]
> [  242.038959]        CPU0                    CPU1
> [  242.038959]        ----                    ----
> [  242.038959]   lock(dev_pm_qos_mtx);
> [  242.038959]                                lock(s_active#54);
> [  242.038959]                                lock(dev_pm_qos_mtx);
> [  242.038959]   lock(s_active#54);
> [  242.038959]
> [  242.038959]  *** DEADLOCK ***
> [  242.038959]
> [  242.038959] 4 locks held by trinity-child6/12371:
> [  242.038959]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff812ffcf3>] sysfs_write_file+0x43/0x150
> [  242.038959]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff82d3a7d8>] usb_remove_store+0x28/0x80
> [  242.038959]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81f00551>] device_release_driver+0x21/0x40
> [  242.038959]  #3:  (dev_pm_qos_mtx){+.+.+.}, at: [<ffffffff81f07cc3>] dev_pm_qos_constraints_destroy+0x23/0x250
> [  242.038959]
> [  242.038959] stack backtrace:
> [  242.038959] Pid: 12371, comm: trinity-child6 Tainted: G        W    3.9.0-rc4-next-20130328-sasha-00014-g91a3267 #319
> [  242.038959] Call Trace:
> [  242.038959]  [<ffffffff83d6551c>] print_circular_bug+0x1fb/0x20c
> [  242.038959]  [<ffffffff811800cf>] __lock_acquire+0x15bf/0x1e50
> [  242.038959]  [<ffffffff8117cf45>] ? debug_check_no_locks_freed+0x175/0x1d0
> [  242.038959]  [<ffffffff811811da>] lock_acquire+0x1aa/0x240
> [  242.038959]  [<ffffffff81301631>] ? sysfs_addrm_finish+0x31/0x60
> [  242.038959]  [<ffffffff81300aa2>] sysfs_deactivate+0x122/0x1a0
> [  242.038959]  [<ffffffff81301631>] ? sysfs_addrm_finish+0x31/0x60
> [  242.038959]  [<ffffffff811500e8>] ? sched_clock_cpu+0xf8/0x110
> [  242.038959]  [<ffffffff83dac0d9>] ? mutex_unlock+0x9/0x10
> [  242.038959]  [<ffffffff83dac0d9>] ? mutex_unlock+0x9/0x10
> [  242.038959]  [<ffffffff81301631>] sysfs_addrm_finish+0x31/0x60
> [  242.038959]  [<ffffffff812ff77f>] sysfs_hash_and_remove+0x7f/0xb0
> [  242.038959]  [<ffffffff813035a1>] sysfs_unmerge_group+0x51/0x70
> [  242.038959]  [<ffffffff81f068f4>] pm_qos_sysfs_remove_flags+0x14/0x20
> [  242.038959]  [<ffffffff81f07490>] __dev_pm_qos_hide_flags+0x30/0x70
> [  242.038959]  [<ffffffff81f07cd5>] dev_pm_qos_constraints_destroy+0x35/0x250
> [  242.038959]  [<ffffffff81f06931>] dpm_sysfs_remove+0x11/0x50
> [  242.038959]  [<ffffffff83daf46b>] ? _raw_spin_unlock_irq+0x2b/0x80
> [  242.038959]  [<ffffffff81efcf6f>] device_del+0x3f/0x1b0
> [  242.038959]  [<ffffffff81efd128>] device_unregister+0x48/0x60
> [  242.038959]  [<ffffffff82d4083c>] usb_hub_remove_port_device+0x1c/0x20
> [  242.038959]  [<ffffffff82d2a9cd>] hub_disconnect+0xdd/0x160
> [  242.038959]  [<ffffffff82d36ab7>] usb_unbind_interface+0x67/0x170
> [  242.038959]  [<ffffffff81f001a7>] __device_release_driver+0x87/0xe0
> [  242.038959]  [<ffffffff81f00559>] device_release_driver+0x29/0x40
> [  242.038959]  [<ffffffff81effc58>] bus_remove_device+0x148/0x160
> [  242.038959]  [<ffffffff81efd07f>] device_del+0x14f/0x1b0
> [  242.038959]  [<ffffffff82d344f9>] usb_disable_device+0xf9/0x280
> [  242.038959]  [<ffffffff82d34ff8>] usb_set_configuration+0x268/0x840
> [  242.038959]  [<ffffffff8117dc1a>] ? __lock_is_held+0x5a/0x80
> [  242.038959]  [<ffffffff82d3a7d8>] ? usb_remove_store+0x28/0x80
> [  242.038959]  [<ffffffff82d3a7fc>] usb_remove_store+0x4c/0x80
> [  242.038959]  [<ffffffff81efbb43>] dev_attr_store+0x13/0x20
> [  242.038959]  [<ffffffff812ffdaa>] sysfs_write_file+0xfa/0x150
> [  242.038959]  [<ffffffff812ffcb0>] ? sysfs_chmod_file+0xb0/0xb0
> [  242.038959]  [<ffffffff8127f71d>] do_loop_readv_writev+0x4d/0x90
> [  242.038959]  [<ffffffff8127f999>] do_readv_writev+0xf9/0x1e0
> [  242.038959]  [<ffffffff83daf46b>] ? _raw_spin_unlock_irq+0x2b/0x80
> [  242.038959]  [<ffffffff8127faba>] vfs_writev+0x3a/0x60
> [  242.038959]  [<ffffffff8127fc60>] SyS_writev+0x50/0xd0
> [  242.038959]  [<ffffffff83db7d18>] tracesys+0xe1/0xe6

---
 drivers/base/power/qos.c |   60 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -46,6 +46,7 @@
 #include "power.h"
 
 static DEFINE_MUTEX(dev_pm_qos_mtx);
+static DEFINE_MUTEX(dev_pm_qos_sysfs_mtx);
 
 static BLOCKING_NOTIFIER_HEAD(dev_pm_notifiers);
 
@@ -216,12 +217,17 @@ void dev_pm_qos_constraints_destroy(stru
 	struct pm_qos_constraints *c;
 	struct pm_qos_flags *f;
 
-	mutex_lock(&dev_pm_qos_mtx);
+	mutex_lock(&dev_pm_qos_sysfs_mtx);
 
 	/*
 	 * If the device's PM QoS resume latency limit or PM QoS flags have been
 	 * exposed to user space, they have to be hidden at this point.
 	 */
+	pm_qos_sysfs_remove_latency(dev);
+	pm_qos_sysfs_remove_flags(dev);
+
+	mutex_lock(&dev_pm_qos_mtx);
+
 	__dev_pm_qos_hide_latency_limit(dev);
 	__dev_pm_qos_hide_flags(dev);
 
@@ -254,6 +260,8 @@ void dev_pm_qos_constraints_destroy(stru
 
  out:
 	mutex_unlock(&dev_pm_qos_mtx);
+
+	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 }
 
 /**
@@ -558,6 +566,14 @@ static void __dev_pm_qos_drop_user_reque
 	kfree(req);
 }
 
+static void dev_pm_qos_drop_user_request(struct device *dev,
+					 enum dev_pm_qos_req_type type)
+{
+	mutex_lock(&dev_pm_qos_mtx);
+	__dev_pm_qos_drop_user_request(dev, type);
+	mutex_unlock(&dev_pm_qos_mtx);
+}
+
 /**
  * dev_pm_qos_expose_latency_limit - Expose PM QoS latency limit to user space.
  * @dev: Device whose PM QoS latency limit is to be exposed to user space.
@@ -581,6 +597,8 @@ int dev_pm_qos_expose_latency_limit(stru
 		return ret;
 	}
 
+	mutex_lock(&dev_pm_qos_sysfs_mtx);
+
 	mutex_lock(&dev_pm_qos_mtx);
 
 	if (IS_ERR_OR_NULL(dev->power.qos))
@@ -591,26 +609,27 @@ int dev_pm_qos_expose_latency_limit(stru
 	if (ret < 0) {
 		__dev_pm_qos_remove_request(req);
 		kfree(req);
+		mutex_unlock(&dev_pm_qos_mtx);
 		goto out;
 	}
-
 	dev->power.qos->latency_req = req;
+
+	mutex_unlock(&dev_pm_qos_mtx);
+
 	ret = pm_qos_sysfs_add_latency(dev);
 	if (ret)
-		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
+		dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
 
  out:
-	mutex_unlock(&dev_pm_qos_mtx);
+	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_expose_latency_limit);
 
 static void __dev_pm_qos_hide_latency_limit(struct device *dev)
 {
-	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->latency_req) {
-		pm_qos_sysfs_remove_latency(dev);
+	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->latency_req)
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
-	}
 }
 
 /**
@@ -619,9 +638,15 @@ static void __dev_pm_qos_hide_latency_li
  */
 void dev_pm_qos_hide_latency_limit(struct device *dev)
 {
+	mutex_lock(&dev_pm_qos_sysfs_mtx);
+
+	pm_qos_sysfs_remove_latency(dev);
+
 	mutex_lock(&dev_pm_qos_mtx);
 	__dev_pm_qos_hide_latency_limit(dev);
 	mutex_unlock(&dev_pm_qos_mtx);
+
+	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_latency_limit);
 
@@ -649,6 +674,8 @@ int dev_pm_qos_expose_flags(struct devic
 	}
 
 	pm_runtime_get_sync(dev);
+	mutex_lock(&dev_pm_qos_sysfs_mtx);
+
 	mutex_lock(&dev_pm_qos_mtx);
 
 	if (IS_ERR_OR_NULL(dev->power.qos))
@@ -659,16 +686,19 @@ int dev_pm_qos_expose_flags(struct devic
 	if (ret < 0) {
 		__dev_pm_qos_remove_request(req);
 		kfree(req);
+		mutex_unlock(&dev_pm_qos_mtx);
 		goto out;
 	}
-
 	dev->power.qos->flags_req = req;
+
+	mutex_unlock(&dev_pm_qos_mtx);
+
 	ret = pm_qos_sysfs_add_flags(dev);
 	if (ret)
-		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
+		dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
 
  out:
-	mutex_unlock(&dev_pm_qos_mtx);
+	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 	pm_runtime_put(dev);
 	return ret;
 }
@@ -676,10 +706,8 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_flag
 
 static void __dev_pm_qos_hide_flags(struct device *dev)
 {
-	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->flags_req) {
-		pm_qos_sysfs_remove_flags(dev);
+	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->flags_req)
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
-	}
 }
 
 /**
@@ -689,9 +717,15 @@ static void __dev_pm_qos_hide_flags(stru
 void dev_pm_qos_hide_flags(struct device *dev)
 {
 	pm_runtime_get_sync(dev);
+	mutex_lock(&dev_pm_qos_sysfs_mtx);
+
+	pm_qos_sysfs_remove_flags(dev);
+
 	mutex_lock(&dev_pm_qos_mtx);
 	__dev_pm_qos_hide_flags(dev);
 	mutex_unlock(&dev_pm_qos_mtx);
+
+	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 	pm_runtime_put(dev);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_flags);


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
