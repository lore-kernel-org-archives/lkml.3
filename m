Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab3IXHrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:47:45 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56996 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXHro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:47:44 -0400
Message-ID: <1380008861.28920.3.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: adi2: Fix dead lock in
 adi_gpio_direction_output
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 15:47:41 +0800
In-Reply-To: <1380008771.28920.1.camel@phoenix>
References: <1380008771.28920.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code hold port->lock spinlock and then try to grab the lock again
in adi_gpio_set_value(). Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-adi2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index f2aa877..8089fda 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -776,10 +776,11 @@ static int adi_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	struct gpio_port_t *regs = port->regs;
 	unsigned long flags;
 
+	adi_gpio_set_value(chip, offset, value);
+
 	spin_lock_irqsave(&port->lock, flags);
 
 	writew(readw(&regs->inen) & ~(1 << offset), &regs->inen);
-	adi_gpio_set_value(chip, offset, value);
 	writew(1 << offset, &regs->dir_set);
 
 	spin_unlock_irqrestore(&port->lock, flags);
-- 
1.8.1.2



