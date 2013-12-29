Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3L2Cht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:37:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55273 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab3L2CKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:40 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Scott Wood" <scottwood@freescale.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Liu Gang" <Gang.Liu@freescale.com>,
        "Anatolij Gustschin" <agust@denx.de>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.390297699@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/185] powerpc/gpio: Fix the wrong GPIO input data
 on MPC8572/MPC8536
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Gang <Gang.Liu@freescale.com>

commit 1aeef303b5d9e243c41d5b80f8bb059366514a10 upstream.

For MPC8572/MPC8536, the status of GPIOs defined as output
cannot be determined by reading GPDAT register, so the code
use shadow data register instead. But the code may give the
wrong status of GPIOs defined as input under some scenarios:

1. If some pins were configured as inputs and were asserted
high before booting the kernel, the shadow data has been
initialized with those pin values.
2. Some pins have been configured as output first and have
been set to the high value, then reconfigured as input.

The above cases will make the shadow data for those input
pins to be set to high. Then reading the pin status will
always return high even if the actual pin status is low.

The code should eliminate the effects of the shadow data to
the input pins, and the status of those pins should be
read directly from GPDAT.

Acked-by: Scott Wood <scottwood@freescale.com>
Acked-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-mpc8xxx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -69,10 +69,14 @@ static int mpc8572_gpio_get(struct gpio_
 	u32 val;
 	struct of_mm_gpio_chip *mm = to_of_mm_gpio_chip(gc);
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = to_mpc8xxx_gpio_chip(mm);
+	u32 out_mask, out_shadow;
 
-	val = in_be32(mm->regs + GPIO_DAT) & ~in_be32(mm->regs + GPIO_DIR);
+	out_mask = in_be32(mm->regs + GPIO_DIR);
 
-	return (val | mpc8xxx_gc->data) & mpc8xxx_gpio2mask(gpio);
+	val = in_be32(mm->regs + GPIO_DAT) & ~out_mask;
+	out_shadow = mpc8xxx_gc->data & out_mask;
+
+	return (val | out_shadow) & mpc8xxx_gpio2mask(gpio);
 }
 
 static int mpc8xxx_gpio_get(struct gpio_chip *gc, unsigned int gpio)

