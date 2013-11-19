Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3KSNKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:10:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:7191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3KSNKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:10:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="437786159"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] sysfs: handle duplicate removal attempts in sysfs_remove_group()
Date: Tue, 19 Nov 2013 15:09:58 +0200
Message-Id: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive) changed
the behavior so that directory removals will be done recursively. This
means that the sysfs group might already be removed if its parent directory
has been removed.

The current code outputs warnings similar to following log snippet when it
detects that there is no group for the given kobject:

 WARNING: CPU: 0 PID: 4 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
 sysfs group ffffffff81c6f1e0 not found for kobject 'host7'
 Modules linked in:
 CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0+ #13
 Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
 Workqueue: kacpi_hotplug acpi_hotplug_work_fn
  0000000000000009 ffff8801002459b0 ffffffff817daab1 ffff8801002459f8
  ffff8801002459e8 ffffffff810436b8 0000000000000000 ffffffff81c6f1e0
  ffff88006d440358 ffff88006d440188 ffff88006e8b4c28 ffff880100245a48
 Call Trace:
  [<ffffffff817daab1>] dump_stack+0x45/0x56
  [<ffffffff810436b8>] warn_slowpath_common+0x78/0xa0
  [<ffffffff81043727>] warn_slowpath_fmt+0x47/0x50
  [<ffffffff811ad319>] ? sysfs_get_dirent_ns+0x49/0x70
  [<ffffffff811ae526>] sysfs_remove_group+0xc6/0xd0
  [<ffffffff81432f7e>] dpm_sysfs_remove+0x3e/0x50
  [<ffffffff8142a0d0>] device_del+0x40/0x1b0
  [<ffffffff8142a24d>] device_unregister+0xd/0x20
  [<ffffffff8144131a>] scsi_remove_host+0xba/0x110
  [<ffffffff8145f526>] ata_host_detach+0xc6/0x100
  [<ffffffff8145f578>] ata_pci_remove_one+0x18/0x20
  [<ffffffff812e8f48>] pci_device_remove+0x28/0x60
  [<ffffffff8142d854>] __device_release_driver+0x64/0xd0
  [<ffffffff8142d8de>] device_release_driver+0x1e/0x30
  [<ffffffff8142d257>] bus_remove_device+0xf7/0x140
  [<ffffffff8142a1b1>] device_del+0x121/0x1b0
  [<ffffffff812e43d4>] pci_stop_bus_device+0x94/0xa0
  [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
  [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
  [<ffffffff812e44dd>] pci_stop_and_remove_bus_device+0xd/0x20
  [<ffffffff812fc743>] trim_stale_devices+0x73/0xe0
  [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
  [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
  [<ffffffff812fcb6e>] acpiphp_check_bridge+0x7e/0xd0
  [<ffffffff812fd90d>] hotplug_event+0xcd/0x160
  [<ffffffff812fd9c5>] hotplug_event_work+0x25/0x60
  [<ffffffff81316749>] acpi_hotplug_work_fn+0x17/0x22
  [<ffffffff8105cf3a>] process_one_work+0x17a/0x430
  [<ffffffff8105db29>] worker_thread+0x119/0x390
  [<ffffffff8105da10>] ? manage_workers.isra.25+0x2a0/0x2a0
  [<ffffffff81063a5d>] kthread+0xcd/0xf0
  [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180
  [<ffffffff817eb33c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180

On this particular machine I see ~16 of these message during Thunderbolt
hot-unplug.

Fix this in similar way that was done for sysfs_remove_one() by checking
if the parent directory has already been removed and bailing out early.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
I'm not 100% sure that this is the correct solution. It seem to fix my case
but I might be missing something as I'm not that familiar with sysfs.

 fs/sysfs/group.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 1898a10e38ce..8951bfb4e567 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -206,6 +206,15 @@ void sysfs_remove_group(struct kobject *kobj,
 	struct sysfs_dirent *dir_sd = kobj->sd;
 	struct sysfs_dirent *sd;
 
+	/*
+	 * Sysfs directories are now removed recursively by
+	 * sysfs_remove_dir(). This means that this function can be called
+	 * multiple times on the same group. If the parent directory is
+	 * already removed we don't do anything here.
+	 */
+	if (dir_sd->s_flags & SYSFS_FLAG_REMOVED)
+		return;
+
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, grp->name);
 		if (!sd) {
-- 
1.8.4.3

