Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaJTX2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:28:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60826 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJTX2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:28:09 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] pinctrl: rockchip: Set wake_enabled
Date: Mon, 20 Oct 2014 16:27:47 -0700
Message-Id: <1413847670-12245-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rockchip pinctrl driver uses irq_gc_set_wake() but doesn't setup
the .wake_enabled member.  That means that we can never actually use a
pin for wakeup.  When "irq_set_irq_wake()" tries to call through it
will always get a failure from set_irq_wake_real() and will then set
wake_depth to 0.  Assuming you can resume you'll later get an error
message about "Unbalanced IRQ x wake disable".

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 016f457..230d8f3 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1563,6 +1563,7 @@ static int rockchip_interrupts_register(struct platform_device *pdev,
 		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_set_type = rockchip_irq_set_type;
+		gc->wake_enabled = IRQ_MSK(bank->nr_pins);
 
 		irq_set_handler_data(bank->irq, bank);
 		irq_set_chained_handler(bank->irq, rockchip_irq_demux);
-- 
2.1.0.rc2.206.gedb03e5

