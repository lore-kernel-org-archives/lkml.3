Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaABRKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:10:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaABRKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:10:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Gang <Gang.Liu@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 86/91] powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536
Date: Thu,  2 Jan 2014 09:05:01 -0800
Message-Id: <1388682306-30859-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpio/gpio-mpc8xxx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 9ae29cc..06cf5c0 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -69,10 +69,14 @@ static int mpc8572_gpio_get(struct gpio_chip *gc, unsigned int gpio)
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
-- 
1.8.3.2

