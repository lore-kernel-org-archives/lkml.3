Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaLBUqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:46:32 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35908 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871AbaLBUqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:46:30 -0500
Date: Tue, 2 Dec 2014 20:46:28 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: linux-spi@vger.kernel.org, pantelis.antoniou@konsulko.com,
        grant.likely@linaro.org
cc: linux-kernel@vger.kernel.org, broonie@kernel.org, fengguang.wu@intel.com
Subject: [PATCH] spi/of: fix warning due to missing CONFIG_OF_DYNAMIC
 dependency
Message-ID: <alpine.DEB.2.02.1412022041580.16734@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


linux-next commit ce79d54ae447d65117303ca9f61ffe9dcbc2465d ("spi/of: Add OF
notifier handler") is causing the following warning during boot:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at drivers/spi/spi.c:2424 spi_init+0x8c/0xc8()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc6-next-20141201+ #77
Hardware name: NVIDIA Tegra132 Norrin (DT)
Call trace:
[<ffffffc00008a0f8>] dump_backtrace+0x0/0x12c
[<ffffffc00008a234>] show_stack+0x10/0x1c
[<ffffffc00056c474>] dump_stack+0x74/0xc4
[<ffffffc0000b1938>] warn_slowpath_common+0x98/0xcc
[<ffffffc0000b1a30>] warn_slowpath_null+0x14/0x20
[<ffffffc0007892fc>] spi_init+0x88/0xc8
[<ffffffc0000828c4>] do_one_initcall+0x88/0x1a8
[<ffffffc00076aad4>] kernel_init_freeable+0x140/0x1e8
[<ffffffc000567208>] kernel_init+0xc/0xd4
---[ end trace 39b2574b2cb43456 ]---

This was reported by Fengguang Wu on November 22:

https://lkml.org/lkml/2014/11/22/109

and November 28:

http://www.gossamer-threads.com/lists/linux/kernel/2059702

The warning is generated when the code tests the return value of
of_reconfig_notifier_register(), which returns -EINVAL.  This occurs
whenever CONFIG_OF_DYNAMIC is not set.  This warning will likely
affect any configuration with CONFIG_SPI && CONFIG_OF &&
!CONFIG_OF_DYNAMIC.

Fix by modifying the preceding kernel configuration option test to
test for CONFIG_OF_DYNAMIC, not CONFIG_OF.  This patch applies on
linux-next 20141201.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8a0e4b006a78..4431a578bd30 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2415,7 +2415,7 @@ static int __init spi_init(void)
 	if (status < 0)
 		goto err2;
 
-	if (IS_ENABLED(CONFIG_OF))
+	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
 
 	return 0;
-- 
2.1.3

