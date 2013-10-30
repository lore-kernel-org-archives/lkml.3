Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3J3UZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:25:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55829 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3J3UZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:25:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/6] edac: Don't try to cancel workqueue when it's never setup
Date: Wed, 30 Oct 2013 13:25:31 -0700
Message-Id: <1383164736-1849-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
References: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
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
(unwind_backtrace+0x0/0x144)
(show_stack+0x20/0x24)
(dump_stack+0x74/0xb4)
(warn_slowpath_common+0x78/0x9c)
(warn_slowpath_fmt+0x40/0x48)
(debug_print_object+0x98/0xc0)
(debug_object_assert_init+0xdc/0xec)
(del_timer+0x24/0x7c)
(try_to_grab_pending+0xc0/0x1b0)
(cancel_delayed_work+0x2c/0xa0)
(edac_device_workq_teardown+0x1c/0x38)
(edac_device_del_device+0xb8/0xe4)
(krait_edac_remove+0x50/0x70 [krait_edac])
(platform_drv_remove+0x24/0x28)
(__device_release_driver+0x68/0xc0)
(driver_detach+0xc4/0xc8)
(bus_remove_driver+0xac/0x114)
(driver_unregister+0x38/0x58)
(platform_driver_unregister+0x1c/0x20)
(krait_edac_driver_exit+0x14/0x1c [krait_edac])
(SyS_delete_module+0x178/0x2b4)

Fix it by skipping the workqueue teardown for such devices.

Acked-by: Borislav Petkov <bp@suse.de>
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

