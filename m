Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3IQQcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:32:10 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:63675 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3IQQcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:32:09 -0400
Date: Tue, 17 Sep 2013 11:31:53 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: s3c2410: fix clk_disable/clk_unprepare warnings
Message-Id: <20130917113153.41b0305d6892170ba8e1ecf7@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d16933b33914a6dff38a4ecbe8edce44a17898e8 "i2c: s3c2410: Move
location of clk_prepare_enable() call in probe function" refactored
clk_enable and clk_disable calls yet neglected to remove the
clk_disable_unprepare call in the module's remove().

It helps remove warnings on an arndale during unbind:

echo 12c90000.i2c > /sys/bus/platform/devices/12c90000.i2c/driver/unbind

------------[ cut here ]------------
WARNING: CPU: 0 PID: 2548 at drivers/clk/clk.c:842 clk_disable+0x18/0x24()
Modules linked in:
CPU: 0 PID: 2548 Comm: bash Not tainted 3.11.0-next-20130916-00003-gf4bddbc #6
[<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[<c00117d0>] (show_stack+0x10/0x14) from [<c0361be8>] (dump_stack+0x6c/0xac)
[<c0361be8>] (dump_stack+0x6c/0xac) from [<c001d864>] (warn_slowpath_common+0x64/0x88)
[<c001d864>] (warn_slowpath_common+0x64/0x88) from [<c001d8a4>] (warn_slowpath_null+0x1c/0x24)
[<c001d8a4>] (warn_slowpath_null+0x1c/0x24) from [<c02c4a64>] (clk_disable+0x18/0x24)
[<c02c4a64>] (clk_disable+0x18/0x24) from [<c028d0b0>] (s3c24xx_i2c_remove+0x28/0x70)
[<c028d0b0>] (s3c24xx_i2c_remove+0x28/0x70) from [<c0217a10>] (platform_drv_remove+0x18/0x1c)
[<c0217a10>] (platform_drv_remove+0x18/0x1c) from [<c0216358>] (__device_release_driver+0x58/0xb4)
[<c0216358>] (__device_release_driver+0x58/0xb4) from [<c02163d0>] (device_release_driver+0x1c/0x28)
[<c02163d0>] (device_release_driver+0x1c/0x28) from [<c02153c0>] (unbind_store+0x58/0x90)
[<c02153c0>] (unbind_store+0x58/0x90) from [<c0214c90>] (drv_attr_store+0x20/0x2c)
[<c0214c90>] (drv_attr_store+0x20/0x2c) from [<c01032c0>] (sysfs_write_file+0x168/0x198)
[<c01032c0>] (sysfs_write_file+0x168/0x198) from [<c00ae1c0>] (vfs_write+0xb0/0x194)
[<c00ae1c0>] (vfs_write+0xb0/0x194) from [<c00ae594>] (SyS_write+0x3c/0x70)
[<c00ae594>] (SyS_write+0x3c/0x70) from [<c000e3e0>] (ret_fast_syscall+0x0/0x30)
---[ end trace 4c9f9403066f57a6 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2548 at drivers/clk/clk.c:751 clk_unprepare+0x14/0x1c()
Modules linked in:
CPU: 0 PID: 2548 Comm: bash Tainted: G        W    3.11.0-next-20130916-00003-gf4bddbc #6
[<c0014d48>] (unwind_backtrace+0x0/0xf8) from [<c00117d0>] (show_stack+0x10/0x14)
[<c00117d0>] (show_stack+0x10/0x14) from [<c0361be8>] (dump_stack+0x6c/0xac)
[<c0361be8>] (dump_stack+0x6c/0xac) from [<c001d864>] (warn_slowpath_common+0x64/0x88)
[<c001d864>] (warn_slowpath_common+0x64/0x88) from [<c001d8a4>] (warn_slowpath_null+0x1c/0x24)
[<c001d8a4>] (warn_slowpath_null+0x1c/0x24) from [<c02c5834>] (clk_unprepare+0x14/0x1c)
[<c02c5834>] (clk_unprepare+0x14/0x1c) from [<c028d0b8>] (s3c24xx_i2c_remove+0x30/0x70)
[<c028d0b8>] (s3c24xx_i2c_remove+0x30/0x70) from [<c0217a10>] (platform_drv_remove+0x18/0x1c)
[<c0217a10>] (platform_drv_remove+0x18/0x1c) from [<c0216358>] (__device_release_driver+0x58/0xb4)
[<c0216358>] (__device_release_driver+0x58/0xb4) from [<c02163d0>] (device_release_driver+0x1c/0x28)
[<c02163d0>] (device_release_driver+0x1c/0x28) from [<c02153c0>] (unbind_store+0x58/0x90)
[<c02153c0>] (unbind_store+0x58/0x90) from [<c0214c90>] (drv_attr_store+0x20/0x2c)
[<c0214c90>] (drv_attr_store+0x20/0x2c) from [<c01032c0>] (sysfs_write_file+0x168/0x198)
[<c01032c0>] (sysfs_write_file+0x168/0x198) from [<c00ae1c0>] (vfs_write+0xb0/0x194)
[<c00ae1c0>] (vfs_write+0xb0/0x194) from [<c00ae594>] (SyS_write+0x3c/0x70)
[<c00ae594>] (SyS_write+0x3c/0x70) from [<c000e3e0>] (ret_fast_syscall+0x0/0x30)
---[ end trace 4c9f9403066f57a7 ]---

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
 drivers/i2c/busses/i2c-s3c2410.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 3535f3c..3747b9b 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1178,8 +1178,6 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adap);
 
-	clk_disable_unprepare(i2c->clk);
-
 	if (pdev->dev.of_node && IS_ERR(i2c->pctrl))
 		s3c24xx_i2c_dt_gpio_free(i2c);
 
-- 
1.8.4
