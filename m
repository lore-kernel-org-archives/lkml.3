Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaG2QiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:38:17 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41291 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaG2QiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=X87BViAZ9LsDWcx=AGsSmR9VtqbbVaZSZ_1-P-tgV_ig@mail.gmail.com>
References: <1404565174-2923-1-git-send-email-addy.ke@rock-chips.com>
	<1404963109-3906-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=X87BViAZ9LsDWcx=AGsSmR9VtqbbVaZSZ_1-P-tgV_ig@mail.gmail.com>
Date: Tue, 29 Jul 2014 09:38:13 -0700
X-Google-Sender-Auth: m-iYEroDkn1w9zxLUjyuHlHdCzs
Message-ID: <CAD=FV=VtmKCGU1GKd4yQfY=fcggN8xq4p2AEMSoEtz8XydtPDg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: add support for RK3288
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        zyf <zyf@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Mon, Jul 28, 2014 at 9:52 PM, Doug Anderson <dianders@chromium.org> wrote:
> Addy,
>
> On Wed, Jul 9, 2014 at 8:31 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> This patch focuses on clock setting for RK3288 mmc controller.
>>
>> In RK3288 mmc controller, CLKDIV register can only be set 0 or 1,
>> and if DDR 8bit mode, CLKDIV register must be set 1.
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>> changes since v1:
>> - dw_mci_rk3288_setup_clock: do not call clk_get_rate(), just use the
>>   host->bus_hz which is already called by dw_mmc.c, suggested by Jaehoon Chung
>>
>>  .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   |  4 +-
>>  drivers/mmc/host/dw_mmc-pltfm.c                    | 50 +++++++++++++++++++++-
>>  2 files changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
>> index c559f3f..e3f95cd 100644
>> --- a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
>> +++ b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
>> @@ -10,7 +10,9 @@ extensions to the Synopsys Designware Mobile Storage Host Controller.
>>  Required Properties:
>>
>>  * compatible: should be
>> -       - "rockchip,rk2928-dw-mshc": for Rockchip RK2928 and following
>> +       - "rockchip,rk2928-dw-mshc": for Rockchip RK2928 and following,
>> +                                                       before RK3288
>> +       - "rockchip,rk3288-dw-mshc": for Rockchip RK3288
>>
>>  Example:
>>
>> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
>> index d4a47a9..809c28b 100644
>> --- a/drivers/mmc/host/dw_mmc-pltfm.c
>> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
>> @@ -21,17 +21,61 @@
>>  #include <linux/mmc/mmc.h>
>>  #include <linux/mmc/dw_mmc.h>
>>  #include <linux/of.h>
>> +#include <linux/clk.h>
>>
>>  #include "dw_mmc.h"
>>  #include "dw_mmc-pltfm.h"
>>
>> +#define RK3288_CLKGEN_DIV      2
>
> Yup, this matches what I see in the TRM.  It will always divide by 2
> to allow for 4 phases (picking the phases not supported yet).  Default
> phase looks to be 180 degrees which is why we've (currently) got
> USE_HOLD_REG hardcoded.  :)
>
>> +
>>  static void dw_mci_pltfm_prepare_command(struct dw_mci *host, u32 *cmdr)
>>  {
>>         *cmdr |= SDMMC_CMD_USE_HOLD_REG;
>>  }
>>
>> -static const struct dw_mci_drv_data rockchip_drv_data = {
>> +static int dw_mci_rk3288_setup_clock(struct dw_mci *host)
>> +{
>> +       host->bus_hz /= RK3288_CLKGEN_DIV;
>> +
>> +       return 0;
>> +}
>> +
>> +static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>> +{
>> +       int ret;
>> +       unsigned int cclkin;
>> +
>> +       /*
>> +        * cclkin: source clock of mmc controller.
>> +        * bus_hz: card interface clock generated by CLKGEN.
>> +        * bus_hz = cclkin / RK3288_CLKGEN_DIV;
>> +        * ios->clock = (div == 0) ? bus_hz : (bus_hz / (2 * div))
>> +        *
>> +        * Note: div can only be 0 or 1
>> +        *       if DDR50 8bit mode, div must be set 1
>
> Makes sense.  So this function is essentially reversing the logic in
> dw_mmc and making sure that we'll get the right DIV (0 or 1) in
> dw_mci_setup_bus().
>
>
>> +        */
>> +       if ((ios->bus_width == MMC_BUS_WIDTH_8) &&
>> +           (ios->timing == MMC_TIMING_UHS_DDR50 ||
>
> Probably don't need UHS_DDR50 since (I think) you can't have an 8-bit
> SD card--only MMC, right?  ...but it doesn't hurt.
>
>
>> +            ios->timing == MMC_TIMING_MMC_DDR52))
>> +               cclkin = 2 * ios->clock * RK3288_CLKGEN_DIV;
>> +       else
>> +               cclkin = ios->clock * RK3288_CLKGEN_DIV;
>> +
>> +       ret = clk_set_rate(host->ciu_clk, cclkin);
>> +       if (ret)
>> +               dev_warn(host->dev, "failed to set rate %uHz\n", ios->clock);
>> +
>> +       host->bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
>> +}
>> +
>> +static const struct dw_mci_drv_data rk2928_drv_data = {
>> +       .prepare_command        = dw_mci_pltfm_prepare_command,
>> +};
>> +
>> +static const struct dw_mci_drv_data rk3288_drv_data = {
>>         .prepare_command        = dw_mci_pltfm_prepare_command,
>> +       .set_ios        = dw_mci_rk3288_set_ios,
>> +       .setup_clock    = dw_mci_rk3288_setup_clock,
>>  };
>>
>>  static const struct dw_mci_drv_data socfpga_drv_data = {
>> @@ -95,7 +139,9 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
>>  static const struct of_device_id dw_mci_pltfm_match[] = {
>>         { .compatible = "snps,dw-mshc", },
>>         { .compatible = "rockchip,rk2928-dw-mshc",
>> -               .data = &rockchip_drv_data },
>> +               .data = &rk2928_drv_data },
>> +       { .compatible = "rockchip,rk3288-dw-mshc",
>> +               .data = &rk3288_drv_data },
>>         { .compatible = "altr,socfpga-dw-mshc",
>>                 .data = &socfpga_drv_data },
>>         {},
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

It turns out that I spoke too soon.  I realized that in my testing I
didn't have "DDR" mode enabled for my eMMC card.  When I did that then
your patch didn't work.

The problem is that dw_mci_setup_bus() doesn't realize that you've
changed "bus_hz" so it needs to re-run.  You can fix it like this:


diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index 809c28b..bcc96d0 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -44,6 +44,7 @@ static void dw_mci_rk3288_set_ios(struct dw_mci
*host, struct mmc_ios *ios)
 {
        int ret;
        unsigned int cclkin;
+       u32 bus_hz;

        /*
         * cclkin: source clock of mmc controller.
@@ -65,7 +66,11 @@ static void dw_mci_rk3288_set_ios(struct dw_mci
*host, struct mmc_ios *ios)
        if (ret)
                dev_warn(host->dev, "failed to set rate %uHz\n", ios->clock);

-       host->bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
+       bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
+       if (bus_hz != host->bus_hz) {
+               host->bus_hz = bus_hz;
+               host->current_speed = 0;        /* force dw_mci_setup_bus() */
+       }
 }

 static const struct dw_mci_drv_data rk2928_drv_data = {


Do you want to spin the patch for this?

-Doug
