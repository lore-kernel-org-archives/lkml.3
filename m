Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab3E1CcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:32:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:1992 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658Ab3E1Cbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:31:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,755,1363158000"; 
   d="scan'208";a="247435724"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, mytbk920423@gmail.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, stable@vger.kernel.org
Subject: [PATCH] Platform/HP: Fix misuse variable bluetooth_rfkill in the hp_wmi_rfkill_setup()
Date: Tue, 28 May 2013 10:25:33 +0800
Message-Id: <1369707933-8565-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HP wmi platform driver fails to initialize GPS and causes poweroff
failure in HP Elitebook 6930p.

[    9.462428] Call Trace:
[    9.462449]  [<ffffffffa088d25a>] hp_wmi_bios_setup+0x25a/0x3a0 [hp_wmi]
[    9.462493]  [<ffffffff8135978c>] platform_drv_probe+0x3c/0x70
[    9.462530]  [<ffffffff81356d6a>] ? driver_sysfs_add+0x7a/0xb0
[    9.462566]  [<ffffffff81357407>] driver_probe_device+0x87/0x3a0
[    9.462603]  [<ffffffff813577f3>] __driver_attach+0x93/0xa0
[    9.462636]  [<ffffffff81357760>] ? __device_attach+0x40/0x40
[    9.462671]  [<ffffffff81355403>] bus_for_each_dev+0x63/0xa0
[    9.462707]  [<ffffffff81356e8e>] driver_attach+0x1e/0x20
[    9.462740]  [<ffffffff81356a28>] bus_add_driver+0x1f8/0x2b0
[    9.462775]  [<ffffffff81357e81>] driver_register+0x71/0x150
[    9.462810]  [<ffffffff813594e6>] platform_driver_register+0x46/0x50
[    9.462849]  [<ffffffff813595ab>] platform_driver_probe+0x1b/0xa0
[    9.462886]  [<ffffffffa088d55e>] hp_wmi_init+0x1be/0x1fb [hp_wmi]
[    9.462925]  [<ffffffffa088d3a0>] ? hp_wmi_bios_setup+0x3a0/0x3a0 [hp_wmi]
[    9.462967]  [<ffffffff8100210a>] do_one_initcall+0x10a/0x160
[    9.463004]  [<ffffffff810bdac6>] load_module+0x1b46/0x2640
[    9.463038]  [<ffffffff8128da20>] ? ddebug_proc_write+0xf0/0xf0
[    9.463076]  [<ffffffff810be662>] sys_init_module+0xa2/0xf0
[    9.463111]  [<ffffffff814d975d>] system_call_fastpath+0x1a/0x1f
[    9.463146] Code: 48 ff ff ff 80 7b 24 00 74 d2 41 83 e5 01 45 38 ec 74 c9
48 8d bb a0 03 00 00 e8 ed fb aa e0 5b 41 5c 41 5d 44 89 f0 41 5e 5d c3 <0f> 0b
66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66
[    9.463479] RIP  [<ffffffffa05c57af>] rfkill_set_hw_state+0x9f/0xb0 [rfkill]
[    9.463526]  RSP <ffff880071523b60>

Check code and find this error is caused by misusing variable bluetooth_rfkill
where gps_rfkill should be.

Reported-and-tested-by: Iru Cai <mytbk920423@gmail.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=58401
Cc: stable@vger.kernel.org
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/platform/x86/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 45cacf7..9b60282 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -680,7 +680,7 @@ static int hp_wmi_rfkill_setup(struct platform_device *device)
 		}
 		rfkill_init_sw_state(gps_rfkill,
 				     hp_wmi_get_sw_state(HPWMI_GPS));
-		rfkill_set_hw_state(bluetooth_rfkill,
+		rfkill_set_hw_state(gps_rfkill,
 				    hp_wmi_get_hw_state(HPWMI_GPS));
 		err = rfkill_register(gps_rfkill);
 		if (err)
-- 
1.7.9.5

