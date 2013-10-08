Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3JHHTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:19:16 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:1340 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416Ab3JHHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:19:13 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h1de097h8275bhz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinctrl-adi2: GPIO output value should be set after the GPIO interrupt is disabled.
Date: Tue, 8 Oct 2013 15:31:21 +0800
Message-ID: <1381217481-17252-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Use BIT macro as well.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/pinctrl-adi2.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index a74e6f4..7a39562 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -766,9 +766,9 @@ static void adi_gpio_set_value(struct gpio_chip *chip, unsigned offset,
 	spin_lock_irqsave(&port->lock, flags);
 
 	if (value)
-		writew(1 << offset, &regs->data_set);
+		writew(BIT(offset), &regs->data_set);
 	else
-		writew(1 << offset, &regs->data_clear);
+		writew(BIT(offset), &regs->data_clear);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -780,12 +780,14 @@ static int adi_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	struct gpio_port_t *regs = port->regs;
 	unsigned long flags;
 
-	adi_gpio_set_value(chip, offset, value);
-
 	spin_lock_irqsave(&port->lock, flags);
 
-	writew(readw(&regs->inen) & ~(1 << offset), &regs->inen);
-	writew(1 << offset, &regs->dir_set);
+	writew(readw(&regs->inen) & ~BIT(offset), &regs->inen);
+	if (value)
+		writew(BIT(offset), &regs->data_set);
+	else
+		writew(BIT(offset), &regs->data_clear);
+	writew(BIT(offset), &regs->dir_set);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 
-- 
1.8.2.3


