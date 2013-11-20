Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3KTNgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:36:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37539 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3KTNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:35:59 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>, <santosh.shilimkar@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] PM / Clocks: fix pm_clk_resume/suspend if CONFIG_PM_RUNTIME is set
Date: Wed, 20 Nov 2013 15:31:47 +0200
Message-ID: <1384954307-27094-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning is shown and clk_enable() failed on Keystone platform
if CONFIG_PM_RUNTIME is set and Runtime PM is enabled for Davinci gpio driver:
[    0.564486] ------------[ cut here ]------------
[    0.569221] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:883__clk_enable+0x8c/0x98()
[    0.577070] Modules linked in:
[    0.580231] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-10116-g11d59938-dirty #259
[    0.588368] [<c0014d34>] (unwind_backtrace+0x0/0xf8) from [<c0011eb8>] (show_stack+0x10/0x14)
[    0.597018] [<c0011eb8>] (show_stack+0x10/0x14) from [<c03c5df0>] (dump_stack+0x64/0xa4)
[    0.605235] [<c03c5df0>] (dump_stack+0x64/0xa4) from [<c00216b8>] (warn_slowpath_common+0x68/0x88)
[    0.614315] [<c00216b8>] (warn_slowpath_common+0x68/0x88) from [<c00216f4>] (warn_slowpath_null+0x1c/0x24)
[    0.624092] [<c00216f4>] (warn_slowpath_null+0x1c/0x24) from [<c0287a60>] (__clk_enable+0x8c/0x98)
[    0.633173] [<c0287a60>] (__clk_enable+0x8c/0x98) from [<c0287c54>] (clk_enable+0x18/0x2c)
[    0.641556] [<c0287c54>] (clk_enable+0x18/0x2c) from [<c023677c>] (pm_clk_resume+0x5c/0x80)
[    0.650025] [<c023677c>] (pm_clk_resume+0x5c/0x80) from [<c001eba8>] (keystone_pm_runtime_resume+0xc/0x18)
[    0.659800] [<c001eba8>] (keystone_pm_runtime_resume+0xc/0x18) from [<c02344e4>] (__rpm_callback+0x34/0x70)
[    0.669662] [<c02344e4>] (__rpm_callback+0x34/0x70) from [<c0234548>] (rpm_callback+0x28/0x88)
[    0.678390] [<c0234548>] (rpm_callback+0x28/0x88) from [<c023590c>] (rpm_resume+0x3c8/0x684)
[    0.686942] [<c023590c>] (rpm_resume+0x3c8/0x684) from [<c0235e40>] (__pm_runtime_resume+0x4c/0x64)
[    0.696111] [<c0235e40>] (__pm_runtime_resume+0x4c/0x64) from [<c0204798>] (davinci_gpio_probe+0x20c/0x5ac)
[    0.705983] [<c0204798>] (davinci_gpio_probe+0x20c/0x5ac) from [<c02310cc>] (platform_drv_probe+0x18/0x48)
[    0.715758] [<c02310cc>] (platform_drv_probe+0x18/0x48) from [<c022fa0c>] (driver_probe_device+0x80/0x21c)
[    0.725532] [<c022fa0c>] (driver_probe_device+0x80/0x21c) from [<c022fc34>] (__driver_attach+0x8c/0x90)
[    0.735044] [<c022fc34>] (__driver_attach+0x8c/0x90) from [<c022e35c>] (bus_for_each_dev+0x60/0x94)
[    0.744207] [<c022e35c>] (bus_for_each_dev+0x60/0x94) from [<c022f24c>] (bus_add_driver+0xdc/0x1d0)
[    0.753371] [<c022f24c>] (bus_add_driver+0xdc/0x1d0) from [<c023002c>] (driver_register+0x78/0xf4)
[    0.762449] [<c023002c>] (driver_register+0x78/0xf4) from [<c00088fc>] (do_one_initcall+0xec/0x148)
[    0.771616] [<c00088fc>] (do_one_initcall+0xec/0x148) from [<c0538c0c>] (kernel_init_freeable+0xfc/0x1c8)
[    0.781303] [<c0538c0c>] (kernel_init_freeable+0xfc/0x1c8) from [<c03c19d0>] (kernel_init+0x8/0x110)
[    0.790553] [<c03c19d0>] (kernel_init+0x8/0x110) from [<c000e318>] (ret_from_fork+0x14/0x3c)
[    0.799117] ---[ end trace 6588a0ec7fbc847a ]---

This happens because the clk_enable() is called without clk_prepare()
from pm_clk_resume().

Hence, switch to use clk_prepare_enable()/clk_disable_unprepare()
instead of clk_enable()/clk_disable() in case if CONFIG_PM_RUNTIME is
set.
Actually, This is remainder fix of the earlier commit c122f27e1c
"base: power - use clk_prepare_enable and clk_prepare_disable".

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/base/power/clock_ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index 9d8fde7..60d389a 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -230,7 +230,7 @@ int pm_clk_suspend(struct device *dev)
 	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
 		if (ce->status < PCE_STATUS_ERROR) {
 			if (ce->status == PCE_STATUS_ENABLED)
-				clk_disable(ce->clk);
+				clk_disable_unprepare(ce->clk);
 			ce->status = PCE_STATUS_ACQUIRED;
 		}
 	}
@@ -259,7 +259,7 @@ int pm_clk_resume(struct device *dev)
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (ce->status < PCE_STATUS_ERROR) {
-			clk_enable(ce->clk);
+			clk_prepare_enable(ce->clk);
 			ce->status = PCE_STATUS_ENABLED;
 		}
 	}
-- 
1.7.9.5

