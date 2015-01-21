Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbbAUK0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:26:55 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64219 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbbAUK0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <1421767964-8798-3-git-send-email-peter.griffin@linaro.org>
References: <1421767964-8798-1-git-send-email-peter.griffin@linaro.org>
	<1421767964-8798-3-git-send-email-peter.griffin@linaro.org>
Date: Wed, 21 Jan 2015 11:26:44 +0100
Message-ID: <CAPDyKFqVtCrn8DcKCk4jmeXGLKCqiXy1pgprA+Ku33Qiooe8nA@mail.gmail.com>
Subject: Re: [PATCH 2/4] sdhci-st: Add support for stih407 family silicon.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Chris Ball <chris@printf.net>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, olivier.bideau@st.com,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2015 at 16:32, Peter Griffin <peter.griffin@linaro.org> wrote:
> This patch adds support for the extra registers found on
> stih407 family silicon which has the flashSS subsystem.
>
> This mainly consists of some extra glue registers which are
> used to correctly configure the controller hardware.
>
> This patch also adds support for UHS modes for eMMC. To allow
> UHS HS200/SD104 modes to function correctly, due to the
> tight timing constriants, and data tuning requirement support
> for PVT independent delay management is also added. Two types
> of delay management are supported, static delay management and
> dynamic delay management (dynamic delay loop), this delay
> management is only available on eMMC pads on stih410 and later
> silicon.
>
> Testing on stih410-b2120 board achieves the following speeds
> with HS200 eMMC card.
>
> max-frequency = 200Mhz
> /dev/mmcblk0p1:
>  Timing buffered disk reads: 270 MB in  3.02 seconds =  89.54 MB/sec
>
> max-frequency = 100Mhz
> root@debian-armhf:~# hdparm -t /dev/mmcblk0p1
> /dev/mmcblk0p1:
>  Timing buffered disk reads: 210 MB in  3.00 seconds =  70.00 MB/sec
>
> max-frequency = 50Mhz
> root@debian-armhf:~# hdparm -t /dev/mmcblk0p1
> /dev/mmcblk0p1:
>  Timing buffered disk reads: 118 MB in  3.00 seconds =  39.28 MB/sec
>
> This is better than the 3.10 kernel which achieves 77.59 MB/sec
> at 200Mhz clock (same board/soc/eMMC).
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  drivers/mmc/host/sdhci-st.c | 351 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 343 insertions(+), 8 deletions(-)

Would it be possible to split this patch, I think it's easier to
review it in smaller pieces.

>
> diff --git a/drivers/mmc/host/sdhci-st.c b/drivers/mmc/host/sdhci-st.c
> index 328f348..6a4f46c 100644
> --- a/drivers/mmc/host/sdhci-st.c
> +++ b/drivers/mmc/host/sdhci-st.c
> @@ -1,7 +1,7 @@
>  /*
>   * Support for SDHCI on STMicroelectronics SoCs
>   *
> - * Copyright (C) 2014 STMicroelectronics Ltd
> + * Copyright (C) 2015 STMicroelectronics Ltd
>   * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>   * Contributors: Peter Griffin <peter.griffin@linaro.org>
>   *
> @@ -23,9 +23,293 @@
>  #include <linux/module.h>
>  #include <linux/err.h>
>  #include <linux/mmc/host.h>
> -
> +#include <linux/reset.h>
>  #include "sdhci-pltfm.h"
>
> +struct st_mmc_platform_data {

Please rename this to st_mmc_data. We don't want this driver to
support "platform data", since it use DT right. :-)

> +       struct  reset_control *rstc;
> +       void __iomem *top_ioaddr;
> +};
> +
> +/* MMCSS glue logic to setup the HC on some ST SoCs (e.g. STiH407 family) */
> +
> +#define        ST_MMC_CCONFIG_REG_1            0x400
> +#define ST_MMC_CCONFIG_TIMEOUT_CLK_UNIT        BIT(24)
> +#define ST_MMC_CCONFIG_TIMEOUT_CLK_FREQ        BIT(12)
> +#define ST_MMC_CCONFIG_TUNING_COUNT_DEFAULT    BIT(8)
> +#define ST_MMC_CCONFIG_ASYNC_WAKEUP    BIT(0)
> +#define ST_MMC_CCONFIG_1_DEFAULT       \
> +                               ((ST_MMC_CCONFIG_TIMEOUT_CLK_UNIT) | \
> +                                (ST_MMC_CCONFIG_TIMEOUT_CLK_FREQ) | \
> +                                (ST_MMC_CCONFIG_TUNING_COUNT_DEFAULT))
> +
> +#define ST_MMC_CCONFIG_REG_2           0x404
> +#define ST_MMC_CCONFIG_HIGH_SPEED      BIT(28)
> +#define ST_MMC_CCONFIG_ADMA2           BIT(24)
> +#define ST_MMC_CCONFIG_8BIT            BIT(20)
> +#define ST_MMC_CCONFIG_MAX_BLK_LEN     16
> +#define  MAX_BLK_LEN_1024              1
> +#define  MAX_BLK_LEN_2048              2
> +#define BASE_CLK_FREQ_200              0xc8
> +#define BASE_CLK_FREQ_100              0x64
> +#define BASE_CLK_FREQ_50               0x32
> +#define ST_MMC_CCONFIG_2_DEFAULT \
> +       (ST_MMC_CCONFIG_HIGH_SPEED | ST_MMC_CCONFIG_ADMA2 | \
> +        ST_MMC_CCONFIG_8BIT | \
> +        (MAX_BLK_LEN_1024 << ST_MMC_CCONFIG_MAX_BLK_LEN))
> +
> +#define ST_MMC_CCONFIG_REG_3                   0x408
> +#define ST_MMC_CCONFIG_EMMC_SLOT_TYPE          BIT(28)
> +#define ST_MMC_CCONFIG_64BIT                   BIT(24)
> +#define ST_MMC_CCONFIG_ASYNCH_INTR_SUPPORT     BIT(20)
> +#define ST_MMC_CCONFIG_1P8_VOLT                        BIT(16)
> +#define ST_MMC_CCONFIG_3P0_VOLT                        BIT(12)
> +#define ST_MMC_CCONFIG_3P3_VOLT                        BIT(8)
> +#define ST_MMC_CCONFIG_SUSP_RES_SUPPORT                BIT(4)
> +#define ST_MMC_CCONFIG_SDMA                    BIT(0)
> +#define ST_MMC_CCONFIG_3_DEFAULT       \
> +                        (ST_MMC_CCONFIG_ASYNCH_INTR_SUPPORT    | \
> +                         ST_MMC_CCONFIG_3P3_VOLT               | \
> +                         ST_MMC_CCONFIG_SUSP_RES_SUPPORT       | \
> +                         ST_MMC_CCONFIG_SDMA)
> +
> +#define ST_MMC_CCONFIG_REG_4   0x40c
> +#define ST_MMC_CCONFIG_D_DRIVER        BIT(20)
> +#define ST_MMC_CCONFIG_C_DRIVER        BIT(16)
> +#define ST_MMC_CCONFIG_A_DRIVER        BIT(12)
> +#define ST_MMC_CCONFIG_DDR50   BIT(8)
> +#define ST_MMC_CCONFIG_SDR104  BIT(4)
> +#define ST_MMC_CCONFIG_SDR50   BIT(0)
> +#define ST_MMC_CCONFIG_4_DEFAULT       0
> +
> +#define ST_MMC_CCONFIG_REG_5           0x410
> +#define ST_MMC_CCONFIG_TUNING_FOR_SDR50        BIT(8)
> +#define RETUNING_TIMER_CNT_MAX         0xf
> +#define ST_MMC_CCONFIG_5_DEFAULT       0
> +
> +/* I/O configuration for Arasan IP */
> +#define        ST_MMC_GP_OUTPUT        0x450
> +#define ST_MMC_GP_OUTPUT_CD    BIT(12)
> +
> +#define ST_MMC_STATUS_R                0x460
> +
> +#define ST_TOP_MMC_DLY_FIX_OFF(x)      (x - 0x8)
> +
> +/* TOP config registers to manage static and dynamic delay */
> +#define        ST_TOP_MMC_TX_CLK_DLY                   ST_TOP_MMC_DLY_FIX_OFF(0x8)
> +#define        ST_TOP_MMC_RX_CLK_DLY                   ST_TOP_MMC_DLY_FIX_OFF(0xc)
> +/* MMC delay control register */
> +#define        ST_TOP_MMC_DLY_CTRL                     ST_TOP_MMC_DLY_FIX_OFF(0x18)
> +#define        ST_TOP_MMC_DLY_CTRL_DLL_BYPASS_CMD      BIT(0)
> +#define        ST_TOP_MMC_DLY_CTRL_DLL_BYPASS_PH_SEL   BIT(1)
> +#define        ST_TOP_MMC_DLY_CTRL_TX_DLL_ENABLE       BIT(8)
> +#define        ST_TOP_MMC_DLY_CTRL_RX_DLL_ENABLE       BIT(9)
> +#define        ST_TOP_MMC_DLY_CTRL_ATUNE_NOT_CFG_DLY   BIT(10)
> +#define        ST_TOP_MMC_START_DLL_LOCK               BIT(11)
> +
> +/* register to provide the phase-shift value for DLL */
> +#define        ST_TOP_MMC_TX_DLL_STEP_DLY              ST_TOP_MMC_DLY_FIX_OFF(0x1c)
> +#define        ST_TOP_MMC_RX_DLL_STEP_DLY              ST_TOP_MMC_DLY_FIX_OFF(0x20)
> +#define        ST_TOP_MMC_RX_CMD_STEP_DLY              ST_TOP_MMC_DLY_FIX_OFF(0x24)
> +
> +/* phase shift delay on the tx clk 2.188ns */
> +#define        ST_TOP_MMC_TX_DLL_STEP_DLY_VALID        0x6
> +
> +#define        ST_TOP_MMC_DLY_MAX                      0xf
> +
> +#define ST_TOP_MMC_DYN_DLY_CONF        \
> +               (ST_TOP_MMC_DLY_CTRL_TX_DLL_ENABLE | \
> +                ST_TOP_MMC_DLY_CTRL_ATUNE_NOT_CFG_DLY | \
> +                ST_TOP_MMC_START_DLL_LOCK)
> +
> +/*
> + * For clock speeds greater than 90MHz, we need to check that the
> + * DLL procedure has finished before switching to ultra-speed modes.
> + */
> +#define        CLK_TO_CHECK_DLL_LOCK   90000000
> +
> +static inline void st_mmcss_set_static_delay(void __iomem *ioaddr)
> +{
> +       if (ioaddr) {
> +               writel_relaxed(0x0, ioaddr + ST_TOP_MMC_DLY_CTRL);
> +               writel_relaxed(ST_TOP_MMC_DLY_MAX,
> +                               ioaddr + ST_TOP_MMC_TX_CLK_DLY);
> +       }
> +}
> +
> +/**
> + * st_mmcss_cconfig: configure the Arasan HC inside the flashSS.
> + * @np: dt device node.
> + * @host: sdhci host
> + * Description: this function is to configure the Arasan host controller.
> + * On some ST SoCs, i.e. STiH407 family, the MMC devices inside a dedicated
> + * flashSS sub-system which needs to be configured to be compliant to eMMC 4.5
> + * or eMMC4.3.  This has to be done before registering the sdhci host.
> + */
> +static void st_mmcss_cconfig(struct device_node *np, struct sdhci_host *host)
> +{
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct mmc_host *mhost = host->mmc;
> +       u32 cconf2, cconf3, cconf4, cconf5;
> +
> +       if (!of_device_is_compatible(np, "st,sdhci-stih407"))
> +               return;

I think I would prefer to have this check done only once, during ->probe().

Such a check, would then need to handle assigning corresponding
function pointers/callbacks in the struct st_mmc_data, which is what
enables support for this feature.

Those functions pointers then needs to be validated before they are
invoked, of course.

> +
> +       cconf2 = ST_MMC_CCONFIG_2_DEFAULT;
> +       cconf3 = ST_MMC_CCONFIG_3_DEFAULT;
> +       cconf4 = ST_MMC_CCONFIG_4_DEFAULT;
> +       cconf5 = ST_MMC_CCONFIG_5_DEFAULT;
> +
> +       writel_relaxed(ST_MMC_CCONFIG_1_DEFAULT,
> +                       host->ioaddr + ST_MMC_CCONFIG_REG_1);
> +
> +       /* Set clock frequency, default to 50MHz if max-frequency is not
> +        * provided */
> +
> +       switch (mhost->f_max) {
> +       case 200000000:
> +               clk_set_rate(pltfm_host->clk, mhost->f_max);
> +               cconf2 |= BASE_CLK_FREQ_200;
> +               break;
> +       case 100000000:
> +               clk_set_rate(pltfm_host->clk, mhost->f_max);
> +               cconf2 |= BASE_CLK_FREQ_100;
> +               break;
> +       default:
> +               clk_set_rate(pltfm_host->clk, 50000000);
> +               cconf2 |= BASE_CLK_FREQ_50;
> +       }
> +
> +       writel_relaxed(cconf2, host->ioaddr + ST_MMC_CCONFIG_REG_2);
> +
> +       if (mhost->caps & MMC_CAP_NONREMOVABLE)
> +               cconf3 |= ST_MMC_CCONFIG_EMMC_SLOT_TYPE;
> +       else
> +               /* CARD _D ET_CTRL */
> +               writel_relaxed(ST_MMC_GP_OUTPUT_CD,
> +                               host->ioaddr + ST_MMC_GP_OUTPUT);
> +
> +       if (mhost->caps & MMC_CAP_UHS_SDR50) {
> +               /* use 1.8V */
> +               cconf3 |= ST_MMC_CCONFIG_1P8_VOLT;
> +               cconf4 |= ST_MMC_CCONFIG_SDR50;
> +               /* Use tuning */
> +               cconf5 |= ST_MMC_CCONFIG_TUNING_FOR_SDR50;
> +               /* Max timeout for retuning */
> +               cconf5 |= RETUNING_TIMER_CNT_MAX;
> +       }
> +
> +       if (mhost->caps & MMC_CAP_UHS_SDR104) {
> +               /*
> +                * SDR104 implies the HC can support HS200 mode, so
> +                * it's mandatory to use 1.8V
> +                */
> +               cconf3 |= ST_MMC_CCONFIG_1P8_VOLT;
> +               cconf4 |= ST_MMC_CCONFIG_SDR104;
> +               /* Max timeout for retuning */
> +               cconf5 |= RETUNING_TIMER_CNT_MAX;
> +       }
> +
> +       if (mhost->caps & MMC_CAP_UHS_DDR50)
> +               cconf4 |= ST_MMC_CCONFIG_DDR50;
> +
> +       writel_relaxed(cconf3, host->ioaddr + ST_MMC_CCONFIG_REG_3);
> +       writel_relaxed(cconf4, host->ioaddr + ST_MMC_CCONFIG_REG_4);
> +       writel_relaxed(cconf5, host->ioaddr + ST_MMC_CCONFIG_REG_5);
> +}
> +
> +static inline void st_mmcss_set_dll(void __iomem *ioaddr)
> +{
> +       if (ioaddr) {
> +               writel_relaxed(ST_TOP_MMC_DYN_DLY_CONF,
> +                       ioaddr + ST_TOP_MMC_DLY_CTRL);
> +               writel_relaxed(ST_TOP_MMC_TX_DLL_STEP_DLY_VALID,
> +                       ioaddr + ST_TOP_MMC_TX_DLL_STEP_DLY);
> +       }
> +}
> +
> +static int st_mmcss_lock_dll(void __iomem *ioaddr)
> +{
> +       unsigned long curr, value;
> +       unsigned long finish = jiffies + HZ;
> +
> +       /* Checks if the DLL procedure is finished */
> +       do {
> +               curr = jiffies;
> +               value = readl(ioaddr + ST_MMC_STATUS_R);
> +               if (value & 0x1)
> +                       return 0;
> +
> +               cpu_relax();
> +       } while (!time_after_eq(curr, finish));
> +
> +       return -EBUSY;
> +}
> +
> +static int sdhci_st_set_dll_for_clock(struct sdhci_host *host)
> +{
> +       int ret = 0;
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +
> +       if (host->clock > CLK_TO_CHECK_DLL_LOCK) {
> +               st_mmcss_set_dll(pdata->top_ioaddr);
> +               ret = st_mmcss_lock_dll(host->ioaddr);
> +       }
> +
> +       return ret;
> +}
> +
> +static void sdhci_st_set_uhs_signaling(struct sdhci_host *host,
> +                                       unsigned int uhs)
> +{
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +       u16 ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
> +       int ret = 0;
> +
> +       /* Select Bus Speed Mode for host */
> +       ctrl_2 &= ~SDHCI_CTRL_UHS_MASK;
> +       switch (uhs) {
> +       /*
> +        * Set V18_EN -- UHS modes do not work without this.
> +        * does not change signaling voltage
> +        */
> +
> +       case MMC_TIMING_UHS_SDR12:
> +               st_mmcss_set_static_delay(pdata->top_ioaddr);
> +               ctrl_2 |= SDHCI_CTRL_UHS_SDR12 | SDHCI_CTRL_VDD_180;
> +               break;
> +       case MMC_TIMING_UHS_SDR25:
> +               st_mmcss_set_static_delay(pdata->top_ioaddr);
> +               ctrl_2 |= SDHCI_CTRL_UHS_SDR25 | SDHCI_CTRL_VDD_180;
> +               break;
> +       case MMC_TIMING_UHS_SDR50:
> +               st_mmcss_set_static_delay(pdata->top_ioaddr);
> +               ctrl_2 |= SDHCI_CTRL_UHS_SDR50 | SDHCI_CTRL_VDD_180;
> +               ret = sdhci_st_set_dll_for_clock(host);
> +               break;
> +       case MMC_TIMING_UHS_SDR104:
> +       case MMC_TIMING_MMC_HS200:
> +               st_mmcss_set_static_delay(pdata->top_ioaddr);
> +               ctrl_2 |= SDHCI_CTRL_UHS_SDR104 | SDHCI_CTRL_VDD_180;
> +               ret =  sdhci_st_set_dll_for_clock(host);
> +               break;
> +       case MMC_TIMING_UHS_DDR50:
> +       case MMC_TIMING_MMC_DDR52:
> +               st_mmcss_set_static_delay(pdata->top_ioaddr);
> +               ctrl_2 |= SDHCI_CTRL_UHS_DDR50 | SDHCI_CTRL_VDD_180;
> +               break;
> +       }
> +
> +       if (ret)
> +               dev_warn(mmc_dev(host->mmc), "Error setting dll for clock\n");
> +
> +       dev_dbg(mmc_dev(host->mmc), "uhs %d, ctrl_2 %04X\n", uhs, ctrl_2);
> +
> +       sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
> +}
> +
>  static u32 sdhci_st_readl(struct sdhci_host *host, int reg)
>  {
>         u32 ret;
> @@ -48,22 +332,32 @@ static const struct sdhci_ops sdhci_st_ops = {
>         .set_bus_width = sdhci_set_bus_width,
>         .read_l = sdhci_st_readl,
>         .reset = sdhci_reset,
> +       .set_uhs_signaling = sdhci_st_set_uhs_signaling,
>  };
>
>  static const struct sdhci_pltfm_data sdhci_st_pdata = {
>         .ops = &sdhci_st_ops,
>         .quirks = SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
> -           SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
> +               SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> +               SDHCI_QUIRK_NO_HISPD_BIT,
> +       .quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
> +               SDHCI_QUIRK2_STOP_WITH_TC,
>  };
>
> -
>  static int sdhci_st_probe(struct platform_device *pdev)
>  {
> +       struct device_node *np = pdev->dev.of_node;
>         struct sdhci_host *host;
> +       struct st_mmc_platform_data *pdata;
>         struct sdhci_pltfm_host *pltfm_host;
>         struct clk *clk;
>         int ret = 0;
>         u16 host_version;
> +       struct resource *res;
> +
> +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               return -ENOMEM;
>
>         clk =  devm_clk_get(&pdev->dev, "mmc");
>         if (IS_ERR(clk)) {
> @@ -71,6 +365,12 @@ static int sdhci_st_probe(struct platform_device *pdev)
>                 return PTR_ERR(clk);
>         }
>
> +       pdata->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +       if (IS_ERR(pdata->rstc))
> +               pdata->rstc = NULL;
> +       else
> +               reset_control_deassert(pdata->rstc);
> +
>         host = sdhci_pltfm_init(pdev, &sdhci_st_pdata, 0);
>         if (IS_ERR(host)) {
>                 dev_err(&pdev->dev, "Failed sdhci_pltfm_init\n");
> @@ -78,7 +378,6 @@ static int sdhci_st_probe(struct platform_device *pdev)
>         }
>
>         ret = mmc_of_parse(host->mmc);
> -
>         if (ret) {
>                 dev_err(&pdev->dev, "Failed mmc_of_parse\n");
>                 return ret;
> @@ -86,9 +385,22 @@ static int sdhci_st_probe(struct platform_device *pdev)
>
>         clk_prepare_enable(clk);
>
> +       /* Configure the FlashSS Top registers for setting eMMC TX/RX delay */
> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                                          "top-mmc-delay");
> +       pdata->top_ioaddr = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(pdata->top_ioaddr)) {
> +               dev_warn(&pdev->dev, "FlashSS Top Dly registers not available");
> +               pdata->top_ioaddr = NULL;
> +       }
> +
>         pltfm_host = sdhci_priv(host);
> +       pltfm_host->priv = pdata;
>         pltfm_host->clk = clk;
>
> +       /* Configure the Arasan HC inside the flashSS */
> +       st_mmcss_cconfig(np, host);
> +
>         ret = sdhci_add_host(host);
>         if (ret) {
>                 dev_err(&pdev->dev, "Failed sdhci_add_host\n");
> @@ -117,10 +429,17 @@ static int sdhci_st_remove(struct platform_device *pdev)
>  {
>         struct sdhci_host *host = platform_get_drvdata(pdev);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +       int ret;
>
>         clk_disable_unprepare(pltfm_host->clk);
>
> -       return sdhci_pltfm_unregister(pdev);
> +       ret = sdhci_pltfm_unregister(pdev);
> +
> +       if (pdata->rstc)
> +               reset_control_assert(pdata->rstc);
> +
> +       return ret;
>  }
>
>  #ifdef CONFIG_PM_SLEEP
> @@ -128,12 +447,18 @@ static int sdhci_st_suspend(struct device *dev)
>  {
>         struct sdhci_host *host = dev_get_drvdata(dev);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> -       int ret = sdhci_suspend_host(host);
> +       struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +       int ret;
>
> +       ret = sdhci_suspend_host(host);
>         if (ret)
>                 goto out;
>
> +       if (pdata->rstc)
> +               reset_control_assert(pdata->rstc);
> +
>         clk_disable_unprepare(pltfm_host->clk);
> +
>  out:
>         return ret;
>  }
> @@ -142,10 +467,20 @@ static int sdhci_st_resume(struct device *dev)
>  {
>         struct sdhci_host *host = dev_get_drvdata(dev);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct st_mmc_platform_data *pdata = pltfm_host->priv;
> +       struct device_node *np = dev->of_node;
> +       int ret;
>
>         clk_prepare_enable(pltfm_host->clk);
>
> -       return sdhci_resume_host(host);
> +       if (pdata->rstc)
> +               reset_control_deassert(pdata->rstc);
> +
> +       st_mmcss_cconfig(np, host);
> +
> +       ret = sdhci_resume_host(host);
> +
> +       return ret;
>  }
>  #endif
>
> --
> 1.9.1
>

Kind regards
Uffe
