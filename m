Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaHSEfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 00:35:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15604 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaHSEfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 00:35:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Aug 2014 21:21:40 -0700
Message-ID: <53F2D454.2020000@nvidia.com>
Date: Tue, 19 Aug 2014 12:36:36 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: [PATCH v3 03/15] clk: tegra: Add closed loop support for the
 DFLL
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi> <1408419205-10048-4-git-send-email-tuomas.tynkkynen@iki.fi>
In-Reply-To: <1408419205-10048-4-git-send-email-tuomas.tynkkynen@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/19/2014 11:33 AM, Tuomas Tynkkynen wrote:
> From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> With closed loop support, the clock rate of the DFLL can be adjusted.
>
> The oscillator itself in the DFLL is a free-running oscillator whose
> rate is directly determined the supply voltage. However, the DFLL
> module contains logic to compare the DFLL output rate to a fixed
> reference clock (51 MHz) and make a decision to either lower or raise
> the DFLL supply voltage. The DFLL module can then autonomously change
> the supply voltage by communicating with an off-chip PMIC via either I2C
> or PWM signals. This driver currently supports only I2C.
>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> ---
> v3: Fix incorrect order of arguments to dfll_scale_dvco_rate
> ---
>   drivers/clk/tegra/clk-dfll.c | 656 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 653 insertions(+), 3 deletions(-)
...
> +
> +/**
> + * dfll_init_out_if - prepare DFLL-to-PMIC interface
> + * @td: DFLL instance
> + *
> + * During DFLL driver initialization or resume from context loss,
> + * disable the I2C command output to the PMIC, set safe voltage and
> + * output limits, and disable and clear limit interrupts.
> + */
> +static void dfll_init_out_if(struct tegra_dfll *td)
> +{
> +	u32 val;
> +
> +	td->lut_min = 0;
> +	td->lut_max = td->i2c_lut_size - 1;
> +	td->lut_safe = td->lut_min + 1;
> +
> +	dfll_i2c_writel(td, 0, DFLL_OUTPUT_CFG);
> +	val = (td->lut_safe << DFLL_OUTPUT_CFG_SAFE_SHIFT) |
> +		(td->lut_max << DFLL_OUTPUT_CFG_MAX_SHIFT) |
> +		(td->lut_min << DFLL_OUTPUT_CFG_MIN_SHIFT);
> +	dfll_writel(td, val, DFLL_OUTPUT_CFG);
> +	dfll_wmb(td);
Sorry that I forgot to mention this in v2's comment. Could you squash 
the change below in this patch? And actually it's pretty easy to misuse 
the dfll read/write/wmb functions. We might want to have some generic 
functions for these, and let the generic functions handle the offset to 
different register blocks.

commit 4a1fdd54141b4f8f9425d54cdad13c42763e6186
Author: Vince Hsu <vinceh@nvidia.com>
Date:   Thu Aug 14 18:19:20 2014 +0800

     clk: tegra: use the correct write funtion for DFLL_OUTPUT_CFG

     Signed-off-by: Vince Hsu <vinceh@nvidia.com>

diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
index 9b3eded6b880..71e4b256ea0d 100644
--- a/drivers/clk/tegra/clk-dfll.c
+++ b/drivers/clk/tegra/clk-dfll.c
@@ -645,7 +645,7 @@ static void dfll_init_out_if(struct tegra_dfll *td)
         val = (td->lut_safe << DFLL_OUTPUT_CFG_SAFE_SHIFT) |
                 (td->lut_max << DFLL_OUTPUT_CFG_MAX_SHIFT) |
                 (td->lut_min << DFLL_OUTPUT_CFG_MIN_SHIFT);
-       dfll_writel(td, val, DFLL_OUTPUT_CFG);
+       dfll_i2c_writel(td, val, DFLL_OUTPUT_CFG);
-        dfll_wmb(td);
+        dfll_i2c_wmb(td);

         dfll_writel(td, 0, DFLL_OUTPUT_FORCE);
@@ -1146,7 +1146,8 @@ static int attr_registers_show(struct seq_file *s, 
void *data)
         seq_puts(s, "CONTROL REGISTERS:\n");
         for (offs = 0; offs <= DFLL_MONITOR_DATA; offs += 4)
                 seq_printf(s, "[0x%02x] = 0x%08x\n", offs,
-                          dfll_readl(td, offs));
+                               offs == DFLL_OUTPUT_CFG ? 
dfll_i2c_readl(td, offs) :
+                                       dfll_readl(td, offs));

         seq_puts(s, "\nI2C and INTR REGISTERS:\n");
         for (offs = DFLL_I2C_CFG; offs <= DFLL_I2C_STS; offs += 4)



Thanks,
Vince

















