Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbaCUAEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbaCUAEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philippe De Muyter <phdm@macqel.be>,
        Huang Shijie <b32955@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 083/149] spi: spi-imx: spi_imx_remove: do not disable disabled clocks
Date: Thu, 20 Mar 2014 17:04:06 -0700
Message-Id: <20140321000439.833983129@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philippe De Muyter <phdm@macqel.be>

commit fd40dccb1a170ba689664481a3de83617b7194d2 upstream.

Currently, at module removal, one gets the following warnings:
------------[ cut here ]------------
WARNING: at drivers/clk/clk.c:780 clk_disable+0x18/0x24()
Modules linked in: spi_imx(-) [last unloaded: ev76c560]
CPU: 1 PID: 16337 Comm: rmmod Tainted: G        W    3.10.17-80548-g90191eb-dirty #33
[<80013b4c>] (unwind_backtrace+0x0/0xf8) from [<800115dc>] (show_stack+0x10/0x14)
[<800115dc>] (show_stack+0x10/0x14) from [<800257b8>] (warn_slowpath_common+0x4c/0x68)
[<800257b8>] (warn_slowpath_common+0x4c/0x68) from [<800257f0>] (warn_slowpath_null+0x1c/0x24)
[<800257f0>] (warn_slowpath_null+0x1c/0x24) from [<803f60ec>] (clk_disable+0x18/0x24)
[<803f60ec>] (clk_disable+0x18/0x24) from [<7f02c9cc>] (spi_imx_remove+0x54/0x9c [spi_imx])
[<7f02c9cc>] (spi_imx_remove+0x54/0x9c [spi_imx]) from [<8025868c>] (platform_drv_remove+0x18/0x1c)
[<8025868c>] (platform_drv_remove+0x18/0x1c) from [<80256f60>] (__device_release_driver+0x70/0xcc)
[<80256f60>] (__device_release_driver+0x70/0xcc) from [<80257770>] (driver_detach+0xcc/0xd0)
[<80257770>] (driver_detach+0xcc/0xd0) from [<80256d90>] (bus_remove_driver+0x7c/0xc0)
[<80256d90>] (bus_remove_driver+0x7c/0xc0) from [<80068668>] (SyS_delete_module+0x144/0x1f8)
[<80068668>] (SyS_delete_module+0x144/0x1f8) from [<8000e080>] (ret_fast_syscall+0x0/0x30)
---[ end trace 1f5df9ad54996300 ]---
------------[ cut here ]------------
WARNING: at drivers/clk/clk.c:780 clk_disable+0x18/0x24()
Modules linked in: spi_imx(-) [last unloaded: ev76c560]
CPU: 1 PID: 16337 Comm: rmmod Tainted: G        W    3.10.17-80548-g90191eb-dirty #33
[<80013b4c>] (unwind_backtrace+0x0/0xf8) from [<800115dc>] (show_stack+0x10/0x14)
[<800115dc>] (show_stack+0x10/0x14) from [<800257b8>] (warn_slowpath_common+0x4c/0x68)
[<800257b8>] (warn_slowpath_common+0x4c/0x68) from [<800257f0>] (warn_slowpath_null+0x1c/0x24)
[<800257f0>] (warn_slowpath_null+0x1c/0x24) from [<803f60ec>] (clk_disable+0x18/0x24)
[<803f60ec>] (clk_disable+0x18/0x24) from [<7f02c9e8>] (spi_imx_remove+0x70/0x9c [spi_imx])
[<7f02c9e8>] (spi_imx_remove+0x70/0x9c [spi_imx]) from [<8025868c>] (platform_drv_remove+0x18/0x1c)
[<8025868c>] (platform_drv_remove+0x18/0x1c) from [<80256f60>] (__device_release_driver+0x70/0xcc)
[<80256f60>] (__device_release_driver+0x70/0xcc) from [<80257770>] (driver_detach+0xcc/0xd0)
[<80257770>] (driver_detach+0xcc/0xd0) from [<80256d90>] (bus_remove_driver+0x7c/0xc0)
[<80256d90>] (bus_remove_driver+0x7c/0xc0) from [<80068668>] (SyS_delete_module+0x144/0x1f8)
[<80068668>] (SyS_delete_module+0x144/0x1f8) from [<8000e080>] (ret_fast_syscall+0x0/0x30)
---[ end trace 1f5df9ad54996301 ]---

Since commit 9e556dcc55774c9a1032f32baa0e5cfafede8b70, "spi: spi-imx: only
enable the clocks when we start to transfer a message", clocks are always
disabled except when transmitting messages.  There is thus no need to
disable them at module removal.

Fixes: 9e556dcc55774 (spi: spi-imx: only enable the clocks when we start to transfer a message)
Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Acked-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-imx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -925,8 +925,8 @@ static int spi_imx_remove(struct platfor
 	spi_bitbang_stop(&spi_imx->bitbang);
 
 	writel(0, spi_imx->base + MXC_CSPICTRL);
-	clk_disable_unprepare(spi_imx->clk_ipg);
-	clk_disable_unprepare(spi_imx->clk_per);
+	clk_unprepare(spi_imx->clk_ipg);
+	clk_unprepare(spi_imx->clk_per);
 	spi_master_put(master);
 
 	return 0;


