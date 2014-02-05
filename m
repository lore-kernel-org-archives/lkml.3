Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbaBEUnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:43:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:55084 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaBEUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 118/213] ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled
Date: Wed, 5 Feb 2014 15:01:13 -0500
Message-ID: <1391630568-49251-119-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b88a634a903d9670aa5f2f785aa890628ce0dece upstream.

If cpuidle is disabled, that means that:

	per_cpu(acpi_cpuidle_device, pr->id)

is set to NULL as the acpi_processor_power_init ends up failing at

	 retval = cpuidle_register_driver(&acpi_idle_driver)

(in acpi_processor_power_init) and never sets the per_cpu idle
device.  So when acpi_processor_hotplug on CPU online notification
tries to reference said device it crashes:

cpu 3 spinlock event irq 62
BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffff81381013>] acpi_processor_setup_cpuidle_cx+0x3f/0x105
PGD a259b067 PUD ab38b067 PMD 0
Oops: 0002 [#1] SMP
odules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c nouveau mxm_wmi wmi radeon ttm sg sr_mod sd_mod cdrom ata_generic ata_piix libata crc32c_intel scsi_mod atl1c i915 fbcon tileblit font bitblit softcursor drm_kms_helper video xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd mperf
CPU 1
Pid: 3047, comm: bash Not tainted 3.8.0-rc3upstream-00250-g165c029 #1 MSI MS-7680/H61M-P23 (MS-7680)
RIP: e030:[<ffffffff81381013>]  [<ffffffff81381013>] acpi_processor_setup_cpuidle_cx+0x3f/0x105
RSP: e02b:ffff88001742dca8  EFLAGS: 00010202
RAX: 0000000000010be9 RBX: ffff8800a0a61800 RCX: ffff880105380000
RDX: 0000000000000003 RSI: 0000000000000200 RDI: ffff8800a0a61800
RBP: ffff88001742dce8 R08: ffffffff81812360 R09: 0000000000000200
R10: aaaaaaaaaaaaaaaa R11: 0000000000000001 R12: ffff8800a0a61800
R13: 00000000ffffff01 R14: 0000000000000000 R15: ffffffff81a907a0
FS:  00007fd6942f7700(0000) GS:ffff880105280000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 00000000a6773000 CR4: 0000000000042660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 3047, threadinfo ffff88001742c000, task ffff880017944000)
Stack:
 0000000000000150 ffff880100f59e00 ffff88001742dcd8 ffff8800a0a61800
 0000000000000000 00000000ffffff01 0000000000000000 ffffffff81a907a0
 ffff88001742dd18 ffffffff813815b1 ffff88001742dd08 ffffffff810ae336
Call Trace:
 [<ffffffff813815b1>] acpi_processor_hotplug+0x7c/0x9f
 [<ffffffff810ae336>] ? schedule_delayed_work_on+0x16/0x20
 [<ffffffff8137ee8f>] acpi_cpu_soft_notify+0x90/0xca
 [<ffffffff8166023d>] notifier_call_chain+0x4d/0x70
 [<ffffffff810bc369>] __raw_notifier_call_chain+0x9/0x10
 [<ffffffff81094a4b>] __cpu_notify+0x1b/0x30
 [<ffffffff81652cf7>] _cpu_up+0x103/0x14b
 [<ffffffff81652e18>] cpu_up+0xd9/0xec
 [<ffffffff8164a254>] store_online+0x94/0xd0
 [<ffffffff814122fb>] dev_attr_store+0x1b/0x20
 [<ffffffff81216404>] sysfs_write_file+0xf4/0x170

This patch fixes it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 346b758c47ed..10e6efe75daf 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1064,6 +1064,9 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		return -EINVAL;
 	}
 
+	if (!dev)
+		return -EINVAL;
+
 	dev->cpu = pr->id;
 	for (i = 0; i < CPUIDLE_STATE_MAX; i++) {
 		dev->states[i].name[0] = '\0';
-- 
1.8.5.2

