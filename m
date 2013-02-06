Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3BFKRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:17:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65324 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3BFKRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:17:15 -0500
X-IronPort-AV: E=Sophos;i="4.84,614,1355068800"; 
   d="scan'208";a="6696552"
Message-ID: <51122D9A.6040002@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 18:16:58 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Yinghai Lu <yinghai@kernel.org>, "'Lin Feng'" <linfeng@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, izumi.taku@jp.fujitsu.com,
        Jiang Liu <liuj97@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: pci-sysfs: queue sysfs rescan routine into workqueue to avoid potential
 deadlock situation
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 18:15:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 18:15:54,
	Serialize complete at 2013/02/06 18:15:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential deadlock situation when we manipulate the pci-sysfs user
interfaces from different bus hierarchy simultaneously, described as following:

path1: sysfs remove device:             | path2: sysfs rescan device:
sysfs_schedule_callback_work()          | sysfs_write_file()
  remove_callback()                     |   flush_write_buffer()
*1* mutex_lock(&pci_remove_rescan_mutex)|*2*  sysfs_get_active(attr_sd)
      ...                               |     dev_attr_store()
        device_remove_file()            |       dev_rescan_store()
          ...                           |*4*
mutex_lock(&pci_remove_rescan_mutex)
*3*       sysfs_deactivate(sd)          |     ...
            wait_for_completion()       |*5*  sysfs_put_active(attr_sd)
*6* mutex_unlock(&pci_remove_rescan_mutex)

If path1 first holds the pci_remove_rescan_mutex at *1*, then another path
called path2 actived and runs to *2* before path1 runs to *3*, we now runs
to a deadlock situation:
Path1 holds the mutex waiting path2 to decrease sysfs_dirent's s_active
counter at *5*, but path2 is blocked at *4* when trying to get the
pci_remove_rescan_mutex. The mutex won't be put by path1 until it reach
*6*, but it's now blocked at *3*.

Under the suggestion of Bjorn, and base on Yinghai Lu's patch:
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=277df390baeab7ba6aa136356b677a096c890c0c

The circumvent approach is queuing the sysfs rescan routine into workqueue just
like removal to avoid manipulating(remove/scan) the pci-tree at the same time.


*dmesg ifno*:
(snip)
1000e 0000:1c:00.0: eth9: Intel(R) PRO/1000 Network Connection
sd 13:2:0:0: [sdb] Attached SCSI disk
e1000e 0000:1c:00.0: eth9: MAC: 0, PHY: 4, PBA No: D50228-005
e1000e 0000:1c:00.1: Disabling ASPM  L1
e1000e 0000:1c:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic
conservative mode
e1000e 0000:1c:00.1: irq 143 for MSI/MSI-X
e1000e 0000:1c:00.1: eth10: (PCI Express:2.5GT/s:Width x4) 00:15:17:cd:96:bf
e1000e 0000:1c:00.1: eth10: Intel(R) PRO/1000 Network Connection
e1000e 0000:1c:00.1: eth10: MAC: 0, PHY: 4, PBA No: D50228-005
INFO: task bash:62982 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash            D 0000000000000000     0 62982  62978 0x00000080
 ffff88038b277db8 0000000000000082 ffff88038b277fd8 0000000000013940
 ffff88038b276010 0000000000013940 0000000000013940 0000000000013940
 ffff88038b277fd8 0000000000013940 ffff880377449e30 ffff8806e822c670
Call Trace:
 [<ffffffff8151ba79>] schedule+0x29/0x70
 [<ffffffff8151bd6e>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff8151a4e3>] __mutex_lock_slowpath+0xd3/0x150
 [<ffffffff8151a3eb>] mutex_lock+0x2b/0x50
 [<ffffffff812821dc>] dev_rescan_store+0x5c/0x80
 [<ffffffff81341800>] dev_attr_store+0x20/0x30
 [<ffffffff811e3eef>] sysfs_write_file+0xef/0x170
 [<ffffffff81173d08>] vfs_write+0xc8/0x190
 [<ffffffff81173ed1>] sys_write+0x51/0x90
 [<ffffffff81524b29>] system_call_fastpath+0x16/0x1b
INFO: task bash:64141 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bash            D ffffffff81610460     0 64141  64136 0x00000080
 ffff8803540e9db8 0000000000000086 ffff8803540e9fd8 0000000000013940
 ffff8803540e8010 0000000000013940 0000000000013940 0000000000013940
 ffff8803540e9fd8 0000000000013940 ffff8807db338a10 ffff8806f09abc60
Call Trace:
 [<ffffffff8151ba79>] schedule+0x29/0x70
 [<ffffffff8151bd6e>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff8151a4e3>] __mutex_lock_slowpath+0xd3/0x150
 [<ffffffff8151a3eb>] mutex_lock+0x2b/0x50
 [<ffffffff812821dc>] dev_rescan_store+0x5c/0x80
 [<ffffffff81341800>] dev_attr_store+0x20/0x30
 [<ffffffff811e3eef>] sysfs_write_file+0xef/0x170
 [<ffffffff81173d08>] vfs_write+0xc8/0x190
 [<ffffffff81173ed1>] sys_write+0x51/0x90
 [<ffffffff81524b29>] system_call_fastpath+0x16/0x1b
INFO: task kworker/u:3:64451 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u:3     D ffffffff81610460     0 64451      2 0x00000080
 ffff8807d51b7a30 0000000000000046 ffff8807d51b7fd8 0000000000013940
 ffff8807d51b6010 0000000000013940 0000000000013940 0000000000013940
 ffff8807d51b7fd8 0000000000013940 ffff8807db339420 ffff88037744b250
Call Trace:
 [<ffffffff8151ba79>] schedule+0x29/0x70
 [<ffffffff81519ded>] schedule_timeout+0x19d/0x220
 [<ffffffff81165f92>] ? __slab_free+0x1f2/0x2f0
 [<ffffffff8151b8fe>] wait_for_common+0x11e/0x190
 [<ffffffff8108a6e0>] ? try_to_wake_up+0x2c0/0x2c0
 [<ffffffff8151ba4d>] wait_for_completion+0x1d/0x20
 [<ffffffff811e53e8>] sysfs_addrm_finish+0xb8/0xd0
 [<ffffffff811e4320>] ? sysfs_schedule_callback+0x1e0/0x1e0
 [<ffffffff811e33f0>] sysfs_hash_and_remove+0x60/0xb0
 [<ffffffff811e43c9>] sysfs_remove_file+0x39/0x50
 [<ffffffff81342cb7>] device_remove_file+0x17/0x20
 [<ffffffff8134505c>] bus_remove_device+0xdc/0x180
 [<ffffffff81342eb0>] device_del+0x120/0x1d0
 [<ffffffff81342f82>] device_unregister+0x22/0x60
 [<ffffffff8127ade4>] pci_stop_bus_device+0x94/0xa0
 [<ffffffff8127ad90>] pci_stop_bus_device+0x40/0xa0
 [<ffffffff8127ad90>] pci_stop_bus_device+0x40/0xa0
 [<ffffffff8127ad90>] pci_stop_bus_device+0x40/0xa0
 [<ffffffff8127af66>] pci_stop_and_remove_bus_device+0x16/0x30
 [<ffffffff81282359>] remove_callback+0x29/0x40
 [<ffffffff811e4344>] sysfs_schedule_callback_work+0x24/0x70
 [<ffffffff81070009>] process_one_work+0x179/0x4b0
 [<ffffffff8107210e>] worker_thread+0x12e/0x330
 [<ffffffff81071fe0>] ? manage_workers+0x110/0x110
 [<ffffffff8107705e>] kthread+0x9e/0xb0
 [<ffffffff81525bc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81076fc0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81525bc0>] ? gs_change+0x13/0x13


Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 drivers/pci/pci-sysfs.c |   92 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c6e9bb..e66b498 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -285,21 +285,34 @@ msi_bus_store(struct device *dev, struct device_attribute
*attr,
 }

 static DEFINE_MUTEX(pci_remove_rescan_mutex);
+
+static void bus_rescan_callback(struct device *dev)
+{
+	struct pci_bus *b = NULL;
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	while ((b = pci_find_next_bus(b)) != NULL)
+		pci_rescan_bus(b);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
+	int err;
 	unsigned long val;
-	struct pci_bus *b = NULL;
+	struct device *dev = bus->dev_root;

 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;

-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		while ((b = pci_find_next_bus(b)) != NULL)
-			pci_rescan_bus(b);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (!val)
+		return count;
+
+	err = device_schedule_callback(dev, bus_rescan_callback);
+	if (err)
+		return err;
+
 	return count;
 }

@@ -308,21 +321,32 @@ struct bus_attribute pci_bus_attrs[] = {
 	__ATTR_NULL
 };

+static void dev_rescan_callback(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->is_added) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		pci_rescan_bus(pdev->bus);
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
+}
+
 static ssize_t
 dev_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int err;
 	unsigned long val;
-	struct pci_dev *pdev = to_pci_dev(dev);

 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;

-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (!val)
+		return count;
+	err = device_schedule_callback(dev, dev_rescan_callback);
+	if (err)
+		return err;
 	return count;
 }

@@ -339,7 +363,7 @@ static ssize_t
 remove_store(struct device *dev, struct device_attribute *dummy,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
+	int err;
 	unsigned long val;

 	if (strict_strtoul(buf, 0, &val) < 0)
@@ -348,31 +372,45 @@ remove_store(struct device *dev, struct device_attribute
*dummy,
 	/* An attribute cannot be unregistered by one of its own methods,
 	 * so we have to use this roundabout approach.
 	 */
-	if (val)
-		ret = device_schedule_callback(dev, remove_callback);
-	if (ret)
-		count = ret;
+	if (!val)
+		return count;
+
+	err = device_schedule_callback(dev, remove_callback);
+	if (err)
+		return err;
+
 	return count;
 }

+static void dev_bus_rescan_callback(struct device *dev)
+{
+	struct pci_bus *bus = to_pci_bus(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
+		pci_rescan_bus_bridge_resize(bus->self);
+	else
+		pci_rescan_bus(bus);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
 static ssize_t
 dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int err;
 	unsigned long val;
-	struct pci_bus *bus = to_pci_bus(dev);

 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;

-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
-			pci_rescan_bus_bridge_resize(bus->self);
-		else
-			pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (!val)
+		return count;
+
+	err = device_schedule_callback(dev, dev_bus_rescan_callback);
+	if (err)
+		return err;
+
 	return count;
 }

-- 1.7.7

