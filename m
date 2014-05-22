Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaEVLsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:48:17 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:50759 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEVLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:48:15 -0400
Date: Thu, 22 May 2014 12:48:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, sameo@linux.intel.com, grant.likely@linaro.org,
        ian@slimlogic.co.uk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@linaro.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mfd: tps65917: Add driver for the TPS65917 PMIC
Message-ID: <20140522114808.GU6679@lee--X1>
References: <1400731239-3180-1-git-send-email-j-keerthy@ti.com>
 <1400731239-3180-4-git-send-email-j-keerthy@ti.com>
 <20140522083707.GM6679@lee--X1>
 <537DD836.3040501@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537DD836.3040501@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>The TPS65917 chip is a power management IC for Portable Navigation Systems
> >>and Tablet Computing devices. It contains the following components:
> >>
> >>  - Regulators.
> >>  - Over Temperature warning and Shut down.
> >>
> >>This patch adds support for tps65917 mfd device. At this time only
> >>the regulator functionality is made available.
> >>
> >>Signed-off-by: Keerthy <j-keerthy@ti.com>
> >>---
> >>v3 Changes:
> >>
> >>  * Header file formating
> >>  * Changed the cache_type to REGCACHE_RBTREE
> >>  * removed unnecessary code
> >>  * Corrected documentation style
> >>  * Added pm_power_off function
> >>
> >>  v2 Changes:
> >>
> >>  * Added volatile register check as some of the registers
> >>    in the set are volatile.
> >>drivers/mfd/Kconfig          |   12 +
> >>  drivers/mfd/Makefile         |    1 +
> >>  drivers/mfd/tps65917.c       |  594 +++++++++++++++++
> >>  include/linux/mfd/tps65917.h | 1485 ++++++++++++++++++++++++++++++++++++++++++
> >>  4 files changed, 2092 insertions(+)
> >>  create mode 100644 drivers/mfd/tps65917.c
> >>  create mode 100644 include/linux/mfd/tps65917.h

[...]

> >>+	for (i = 0; i < TPS65917_NUM_CLIENTS; i++) {
> >>+		if (i == 0) {
> >>+			tps65917->i2c_clients[i] = i2c;
> >This is messy.  Move this line out of the loop and change the loop
> >parameters to start from 1.  Then we can reduce all of this
> >unnecessary indentation.
> 
> There is a common thing we do after if and else. Removing i == 0
> part out of the
> loop would mean repeating the common part. This way seems
> better.

Ah yes, good point.

> >>+		} else {
> >>+			tps65917->i2c_clients[i] =
> >>+					i2c_new_dummy(i2c->adapter,
> >>+						      i2c->addr + i);
> >>+			if (!tps65917->i2c_clients[i]) {
> >>+				dev_err(tps65917->dev,
> >>+					"can't attach client %d\n", i);
> >>+				ret = -ENOMEM;
> >>+				goto err_i2c;
> >>+			}
> >>+
> >>+			tps65917->i2c_clients[i]->dev.of_node = of_node_get(node);
> >Don't forget to decrement the reference when you've finished with it.
> 
> I did not get this.

Do you know what of_node_get() does?

[...]

> >What happens if !node?  Then no children get registered and this has
> >all been a waste of time?
> Only DT way is possible. This check is redundant. I will add a check
> at the beginning for !node.

If that's the case you should add 'depends on OF' in the Kconfig.

> >>+struct tps65917_reg_init {
> >>+	/*
> >>+	 * 0: reload default values from OTP on warm reset
> >>+	 * 1: maintain voltage from VSEL on warm reset
> >>+	 */
> >>+	bool warm_reset;
> >Where is this used?
> >
> >>+	/*
> >>+	 * 0: i2c selection of voltage
> >>+	 * 1: pin selection of voltage.
> >>+	 */
> >>+	bool roof_floor;
> >And this?
> >
> >>+	/*
> >>+	 * For SMPS
> >>+	 *
> >>+	 * 0: Off
> >>+	 * 1: AUTO
> >>+	 * 2: ECO
> >>+	 * 3: Forced PWM
> >>+	 *
> >>+	 * For LDO
> >>+	 *
> >>+	 * 0: Off
> >>+	 * 1: On
> >>+	 */
> >>+	int mode_sleep;
> >And this?
> >
> >>+	u8 vsel;
> >And this?
> 
> All of the above can be used by regulator driver.

Doesn't the regulator driver have its own header file?  Why are these
in a shared file if they're not used anywhere else?

[...]

> >>+	if (pdata->mux_from_pdata) {
> >>+		reg = pdata->pad1;
> >>+		ret = regmap_write(tps65917->regmap[slave], addr, reg);
> >>+		if (ret)
> >>+			goto err_irq;
> >>+	} else {
> >>+		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
> >>+		if (ret)
> >>+			goto err_irq;
> >>+	}
> >What does the read do?  You're not doing anything with the value.
> 
> This pad1 and pad2 stuff is not needed. I will remove this.

Then why is it in here?

Did you copy this code from somewhere, if so, where? 

Okay, I just answered my own question.  There is so much common code
in between this and palmas, there is no way I'm going to accept this
driver.  Please merge it in with the palmas driver!

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
