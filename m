Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967645AbaFTNXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:23:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45666 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966834AbaFTNXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:23:21 -0400
Date: Fri, 20 Jun 2014 08:23:10 -0500
From: Nishanth Menon <nm@ti.com>
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Mark Brown <broonie@kernel.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Keerthy <j-keerthy@ti.com>, Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Palmas regulator broken (was Re: [PATCH] ARM: tegra: TN7: relax some
 regulators)
Message-ID: <20140620132310.GA11936@kahuna>
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
 <53A308C8.2070004@wwwdotorg.org>
 <20140619175643.GR5099@sirena.org.uk>
 <53A3C613.8030207@nvidia.com>
 <53A3D85E.7030704@nvidia.com>
 <20140620094119.GT5099@sirena.org.uk>
 <53A4039B.7000504@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53A4039B.7000504@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ l-o,
	http://marc.info/?t=140316427500004&r=1&w=2 full thread

Minor change in subject to indicate palmas regulator fail

On 18:49-20140620, Alexandre Courbot wrote:
> On 06/20/2014 06:41 PM, Mark Brown wrote:
> >* PGP Signed by an unknown key
> >
> >On Fri, Jun 20, 2014 at 03:44:46PM +0900, Alexandre Courbot wrote:
> >
> >>dbabd624d
> >>regulator: palmas: Reemove open coded functions with helper functions
> >
> >>Keerthy, Nishanth, could it be that there is still something wrong with the
> >>REGULATOR_LINEAR_RANGE() definitions?
> >
> >>This seems to be the cause for our trouble, but the other questions might
> >>still stand, in case there is interest in discussing them.
> >
> >There was a bug fix to the Palmas driver which just went to Linus the
> >other day, are you sure this isn't fixed in mainline (or -next, it's
> >been in -next for a week or something)?
> 
> If you are talking about
> 
> 6b7f2d82d5
> regulator: palmas: Fix SMPS list for 0V
> 
> then it is in my tree. There is actually no difference on
> palmas-regulator.c between my tree and the current -next (or Linus'
> tree for that instance).
> 
> So it seems to be something else we are dealing with here.

Your quote earlier in the thread
"
_regulator_is_enabled() *also* returns false
"

Got me curious. Looking at the patch:
dbabd624d4eec50b623bab070d1e39a854b2d65c (regulator: palmas: Reemove
open coded functions with helper functions)
I noticed the following change
palmas_is_enabled_smps -> regulator_is_enabled_regmap

So I decided to search for enable_reg in palmas-regulator.c and I think
it needs valid enable_reg, mask, value for regulator_is_enabled_regmap to work
:).

Maybe to be sure, we could print the following:
PALMAS_SMPS8_VOLTAGE, PALMAS_SMPS8_CTRL, PALMAS_SMPS8_TSTEP,

Anyways, I quickly boot tested the following on DRA7evm (which also uses Palmas):
[    1.933939] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
[    1.944210] smps123: 850 <--> 1250 mV at 1060 mV 
[    1.950717] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
[    1.960754] smps45: 850 <--> 1150 mV at 1060 mV 
[    1.967048] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
[    1.977072] smps6: 850 <--> 1650 mV at 1060 mV 
[    1.983077] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
[    1.992994] smps7: 850 <--> 1030 mV at 1030 mV 
[    1.999238] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00
[    2.009161] smps8: 850 <--> 1250 mV at 1060 mV 
[    2.015304] palmas-pmic 48070000.i2c:tps659038@58:tps659038_pmic: enable_reg = 0x00, mask =0x00

It does seem to me that either set_mode also should use core functions
OR you still need a palmas specific is_enable, enable/disable functions
(contrary to the claim of the patch in question - which I think
 introduced regressions).

Otherwise, completely untested diff below - can you  give this a shot?

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index b982f0f..bbfe22f 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -964,6 +964,20 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 				return ret;
 			pmic->current_reg_mode[id] = reg &
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+
+			dev_err(&pdev->dev, "enable_reg = 0x%02x, mask =0x%02x\n",
+				pmic->desc[id].enable_reg,
+				pmic->desc[id].enable_mask);
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].ctrl_addr);
+			pmic->desc[id].enable_mask =
+					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+			/*
+			 * The following completely ignores
+			 * pmic->current_reg_mode[id] (set_mode)
+			 */
+			pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
 		}
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
-- 
Regards,
Nishanth Menon
