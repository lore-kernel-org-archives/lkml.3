Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3J2Abi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:31:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39787 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3J2Abd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:31:33 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/6] edac: Don't try to cancel workqueue when it's never setup
Date: Mon, 28 Oct 2013 17:31:25 -0700
Message-Id: <1383006690-6754-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
In-Reply-To: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only setup a workqueue for edac devices that use the polling
method. We still try to cancel the workqueue if an edac_device
uses the irq method though. This causes a warning from debug
objects when we remove an edac device:

WARNING: CPU: 0 PID: 56 at lib/debugobjects.c:260 debug_print_object+0x98/0xc0()
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: stub_timer+0x0/0x28
Modules linked in: krait_edac(-)
CPU: 0 PID: 56 Comm: rmmod Not tainted 3.12.0-rc2-00035-g15292a0 #69
[<c02179b4>] (unwind_backtrace+0x0/0x144) from [<c0213e58>] (show_stack+0x20/0x24)
[<c0213e58>] (show_stack+0x20/0x24) from [<c06f7fc4>] (dump_stack+0x74/0xb4)
[<c06f7fc4>] (dump_stack+0x74/0xb4) from [<c0223c34>] (warn_slowpath_common+0x78/0x9c)
[<c0223c34>] (warn_slowpath_common+0x78/0x9c) from [<c0223d14>] (warn_slowpath_fmt+0x40/0x48)
[<c0223d14>] (warn_slowpath_fmt+0x40/0x48) from [<c04cf078>] (debug_print_object+0x98/0xc0)
[<c04cf078>] (debug_print_object+0x98/0xc0) from [<c04cfb54>] (debug_object_assert_init+0xdc/0xec)
[<c04cfb54>] (debug_object_assert_init+0xdc/0xec) from [<c02310c4>] (del_timer+0x24/0x7c)
[<c02310c4>] (del_timer+0x24/0x7c) from [<c023fef8>] (try_to_grab_pending+0xc0/0x1b0)
[<c023fef8>] (try_to_grab_pending+0xc0/0x1b0) from [<c0240014>] (cancel_delayed_work+0x2c/0xa0)
[<c0240014>] (cancel_delayed_work+0x2c/0xa0) from [<c059fa14>] (edac_device_workq_teardown+0x1c/0x38)
[<c059fa14>] (edac_device_workq_teardown+0x1c/0x38) from [<c059fae8>] (edac_device_del_device+0xb8/0xe4)
[<c059fae8>] (edac_device_del_device+0xb8/0xe4) from [<bf000050>] (krait_edac_remove+0x50/0x70 [krait_edac])
[<bf000050>] (krait_edac_remove+0x50/0x70 [krait_edac]) from [<c0511e34>] (platform_drv_remove+0x24/0x28)
[<c0511e34>] (platform_drv_remove+0x24/0x28) from [<c050fffc>] (__device_release_driver+0x68/0xc0)
[<c050fffc>] (__device_release_driver+0x68/0xc0) from [<c0510adc>] (driver_detach+0xc4/0xc8)
[<c0510adc>] (driver_detach+0xc4/0xc8) from [<c050fd98>] (bus_remove_driver+0xac/0x114)
[<c050fd98>] (bus_remove_driver+0xac/0x114) from [<c05111d8>] (driver_unregister+0x38/0x58)
[<c05111d8>] (driver_unregister+0x38/0x58) from [<c0511fe8>] (platform_driver_unregister+0x1c/0x20)
[<c0511fe8>] (platform_driver_unregister+0x1c/0x20) from [<bf0005c4>] (krait_edac_driver_exit+0x14/0x1c [krait_edac])
[<bf0005c4>] (krait_edac_driver_exit+0x14/0x1c [krait_edac]) from [<c028b248>] (SyS_delete_module+0x178/0x2b4)
[<c028b248>] (SyS_delete_module+0x178/0x2b4) from [<c020f760>] (ret_fast_syscall+0x0/0x48)

Fix it by skipping the workqueue teardown for such devices.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/edac/edac_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 211021d..203561b 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -437,6 +437,9 @@ void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev)
 {
 	int status;
 
+	if (!edac_dev->edac_check)
+		return;
+
 	status = cancel_delayed_work(&edac_dev->work);
 	if (status == 0) {
 		/* workq instance might be running, wait for it */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

