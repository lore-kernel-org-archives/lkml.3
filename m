Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbbAYTVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:21:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbAYSJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3.14 39/98] clk: samsung: Fix double add of syscore ops after driver rebind
Date: Sun, 25 Jan 2015 10:06:57 -0800
Message-Id: <20150125180714.563348836@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit c31844ffdbd4e73a16c66e9d7df8ec290ab4b159 upstream.

During driver unbind the syscore ops were not unregistered which lead to
double add on syscore list:

$ echo "3810000.audss-clock-controller" > /sys/bus/platform/drivers/exynos-audss-clk/unbind
$ echo "3810000.audss-clock-controller" > /sys/bus/platform/drivers/exynos-audss-clk/bind
[ 1463.044061] ------------[ cut here ]------------
[ 1463.047255] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:36 __list_add+0x8c/0xc0()
[ 1463.054613] list_add double add: new=c06e52c0, prev=c06e52c0, next=c06d5f84.
[ 1463.061625] Modules linked in:
[ 1463.064623] CPU: 0 PID: 1 Comm: bash Tainted: G        W      3.18.0-rc5-next-20141121-00005-ga8fab06eab42-dirty #1022
[ 1463.075338] [<c0014e2c>] (unwind_backtrace) from [<c0011d80>] (show_stack+0x10/0x14)
[ 1463.083046] [<c0011d80>] (show_stack) from [<c048bb70>] (dump_stack+0x70/0xbc)
[ 1463.090236] [<c048bb70>] (dump_stack) from [<c00233d4>] (warn_slowpath_common+0x74/0xb0)
[ 1463.098295] [<c00233d4>] (warn_slowpath_common) from [<c00234a4>] (warn_slowpath_fmt+0x30/0x40)
[ 1463.106962] [<c00234a4>] (warn_slowpath_fmt) from [<c020fe80>] (__list_add+0x8c/0xc0)
[ 1463.114760] [<c020fe80>] (__list_add) from [<c0282094>] (register_syscore_ops+0x30/0x3c)
[ 1463.122819] [<c0282094>] (register_syscore_ops) from [<c0392f20>] (exynos_audss_clk_probe+0x36c/0x460)
[ 1463.132091] [<c0392f20>] (exynos_audss_clk_probe) from [<c0283084>] (platform_drv_probe+0x48/0xa4)
[ 1463.141013] [<c0283084>] (platform_drv_probe) from [<c0281a14>] (driver_probe_device+0x13c/0x37c)
[ 1463.149852] [<c0281a14>] (driver_probe_device) from [<c0280560>] (bind_store+0x90/0xe0)
[ 1463.157822] [<c0280560>] (bind_store) from [<c027fd10>] (drv_attr_store+0x20/0x2c)
[ 1463.165363] [<c027fd10>] (drv_attr_store) from [<c0143898>] (sysfs_kf_write+0x4c/0x50)
[ 1463.173252] [<c0143898>] (sysfs_kf_write) from [<c0142c80>] (kernfs_fop_write+0xbc/0x198)
[ 1463.181395] [<c0142c80>] (kernfs_fop_write) from [<c00e2be0>] (vfs_write+0xa0/0x1a8)
[ 1463.189104] [<c00e2be0>] (vfs_write) from [<c00e2f00>] (SyS_write+0x40/0x8c)
[ 1463.196122] [<c00e2f00>] (SyS_write) from [<c000f2a0>] (ret_fast_syscall+0x0/0x48)
[ 1463.203655] ---[ end trace 08f6710c9bc8d8f3 ]---
[ 1463.208244] exynos-audss-clk 3810000.audss-clock-controller: setup completed

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 1241ef94ccc3 ("clk: samsung: register audio subsystem clocks using common clock framework")
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/samsung/clk-exynos-audss.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -210,6 +210,10 @@ static int exynos_audss_clk_remove(struc
 {
 	int i;
 
+#ifdef CONFIG_PM_SLEEP
+	unregister_syscore_ops(&exynos_audss_clk_syscore_ops);
+#endif
+
 	of_clk_del_provider(pdev->dev.of_node);
 
 	for (i = 0; i < clk_data.clk_num; i++) {


