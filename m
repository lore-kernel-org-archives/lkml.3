Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaFJMbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:31:51 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57305 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaFJMbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:31:48 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: tc3589x: translate onecell, not twocell
Date: Tue, 10 Jun 2014 14:31:32 +0200
Message-Id: <1402403492-24960-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something changed in the OF parser in the v3.16 merge window
making it be strict about passing the number of IRQ cells
correctly and disturbing the irqdomain xlate function guard
to crash when subdevices try to obtain IRQs like this:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at
/home/linus/linux-stericsson/kernel/irq/irqdomain.c:676
irq_domain_xlate_twocell+0x40/0x48()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted
 3.15.0-07915-gf6d059821ce9-dirty #46
[<c0014660>] (unwind_backtrace)
 from [<c0011424>] (show_stack+0x10/0x14)
[<c0011424>] (show_stack)
 from [<c0432630>] (dump_stack+0x9c/0xd4)
[<c0432630>] (dump_stack)
 from [<c001d5c0>] (warn_slowpath_common+0x6c/0x88)
[<c001d5c0>] (warn_slowpath_common)
 from [<c001d678>] (warn_slowpath_null+0x1c/0x24)
[<c001d678>] (warn_slowpath_null)
 from [<c005acd0>] (irq_domain_xlate_twocell+0x40/0x48)
[<c005acd0>] (irq_domain_xlate_twocell)
 from [<c005b658>] (irq_create_of_mapping+0x64/0x110)
[<c005b658>] (irq_create_of_mapping)
 from [<c02e147c>] (of_irq_get+0x38/0x48)
[<c02e147c>] (of_irq_get)
 from [<c01f8910>] (tc3589x_gpio_probe+0x38/0x1e4)
[<c01f8910>] (tc3589x_gpio_probe)
 from [<c022eedc>] (platform_drv_probe+0x18/0x48)
[<c022eedc>] (platform_drv_probe)
 from [<c022d80c>] (driver_probe_device+0x118/0x24c)
[<c022d80c>] (driver_probe_device)
 from [<c022bf20>] (bus_for_each_drv+0x58/0x8c)
[<c022bf20>] (bus_for_each_drv)
 from [<c022d6c4>] (device_attach+0x74/0x88)
[<c022d6c4>] (device_attach)
 from [<c022cdac>] (bus_probe_device+0x84/0xa8)
[<c022cdac>] (bus_probe_device)
 from [<c022b35c>] (device_add+0x440/0x520)
[<c022b35c>] (device_add)
 from [<c022ec50>] (platform_device_add+0xb4/0x218)
[<c022ec50>] (platform_device_add)
 from [<c0243508>] (mfd_add_device+0x220/0x31c)
[<c0243508>] (mfd_add_device)
 from [<c02436a8>] (mfd_add_devices+0xa4/0x100)
[<c02436a8>] (mfd_add_devices)
 from [<c024312c>] (tc3589x_probe+0x334/0x3c0)
[<c024312c>] (tc3589x_probe)
 from [<c022d80c>] (driver_probe_device+0x118/0x24c)

The TC3589x device trees specify the MFD core device
as having one interrupt cell (cannot specify flags) so the
twocell translation function is clearly wrong, changing it to
onecell, as it should be, fixes the regression.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/tc3589x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index bd83accc0f6d..0072e668c208 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -236,7 +236,7 @@ static void tc3589x_irq_unmap(struct irq_domain *d, unsigned int virq)
 static struct irq_domain_ops tc3589x_irq_ops = {
 	.map    = tc3589x_irq_map,
 	.unmap  = tc3589x_irq_unmap,
-	.xlate  = irq_domain_xlate_twocell,
+	.xlate  = irq_domain_xlate_onecell,
 };
 
 static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)
-- 
1.9.3

