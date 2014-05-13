Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbaEMITr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:19:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53657 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbaEMITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <1398759638-13299-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759638-13299-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 10:19:44 +0200
Message-ID: <CACRpkdYyFWAYsPT1jvOLCpx9dOTL9P-J=45BNqEi5TZ4Zd3vVw@mail.gmail.com>
Subject: Re: [PATCH v1 08/11] mmc: mmci: Qcom fix MCICLK register settings.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 10:20 AM,  <srinivas.kandagatla@linaro.org> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> MCICLK register layout is bit different to the standard pl180 register layout.
> Qcom SDCC controller some setup in MCICLK register to get it going. So this
> patch adds new setup and makes it specific to Qcom hw designer.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
(...)

> -       if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
> -               clk |= MCI_4BIT_BUS;
> -       if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
> -               clk |= MCI_ST_8BIT_BUS;
> +       if (host->hw_designer == AMBA_VENDOR_QCOM) {
> +               clk |= MCI_CLK_QCOM_FLOWENA;
> +               clk |= (MCI_CLK_QCOM_SEL_FEEDBACK_CLK <<
> +                               MCI_CLK_QCOM_SEL_IN_SHIFT); /* feedback clk */
> +               if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
> +                       clk |= MCI_CLK_QCOM_WIDEBUS_8;
> +               else if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
> +                       clk |= MCI_CLK_QCOM_WIDEBUS_4;
> +               else
> +                       clk |= MCI_CLK_QCOM_WIDEBUS_1;
> +
> +               if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50) {
> +                       /* clear SELECT_IN field */
> +                       clk &= ~(MCI_CLK_QCOM_SEL_MASK <<
> +                                       MCI_CLK_QCOM_SEL_IN_SHIFT);
> +                       /* set DDR timing mode */
> +                       clk |= (MCI_CLK_QCOM_SEL_DDR_MODE <<
> +                                       MCI_CLK_QCOM_SEL_IN_SHIFT);
> +               }
> +               clk |= (MCI_CLK_SDC4_MCLK_SEL_MCLK <<
> +                               MCI_CLK_SDC4_MCLK_SEL_SHIFT);
>
> -       if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
> -               clk |= MCI_ST_UX500_NEG_EDGE;
> +       } else {
> +               if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
> +                       clk |= MCI_4BIT_BUS;
> +               if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
> +                       clk |= MCI_ST_8BIT_BUS;
> +
> +               if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
> +                       clk |= MCI_ST_UX500_NEG_EDGE;
> +       }

Again follow the pattern of storing register templates in the vendor_data
struct. I think you will quickly realize how this can be cut down with
new fields like .clk_4bitmode etc.

>  /* Modified PL180 on Versatile Express platform */
>  #define MCI_ARM_HWFCEN         (1 << 12)
>
> +/* Modified on Qualcomm Integrations */

First: follow the convention set for the ST-specific registers that
look e.g. like this:

MCI_ST_8BIT_BUS i.e. MCI_<vendor>_SPECIFIER
So the below becomes MCI_QCOM_CLK_WIDEBUS... etc.

> +#define MCI_CLK_QCOM_WIDEBUS_1 (0 << 10)
> +#define MCI_CLK_QCOM_WIDEBUS_4 (2 << 10)
> +#define MCI_CLK_QCOM_WIDEBUS_8 (3 << 10)

Compare to what we have:

#define MMCICLOCK               0x004
#define MCI_CLK_ENABLE          (1 << 8)
#define MCI_CLK_PWRSAVE         (1 << 9)
#define MCI_CLK_BYPASS          (1 << 10)
#define MCI_4BIT_BUS            (1 << 11)

MCI_CLK_QCOM_WIDEBUS_1 is clearly surplus since it is
not setting any bit.

MCI_CLK_QCOM_WIDEBUS_4 (2 << 10) ==
MCI_4BIT_BUS (1 <<11), this is the same thing just
expressed in two ways! No need to have some surplus
definition adding to the confusion. Just use MCI_4BIT_BUS

The only thing that is really different is
MCI_CLK_QCOM_WIDEBUS_8 which whould have
the name (following the sibling definitions for the ST block):

#define MCI_QCOM_8BIT_BUS (3 << 10)

> +#define MCI_CLK_QCOM_FLOWENA   (1 << 12)

Rename:
MCI_QCOM_CLK_HWFCEN (1<<13)

to match sibling definitions. It's clear that this enabled
hardware flow control and that name is more helpful to
understand what is going on.

> +#define MCI_CLK_QCOM_INVERTOUT (1 << 13)

Rename:
MCI_QCOM_CLK_INV
To match siblings.

> +/* select in latch data and command */
> +#define MCI_CLK_QCOM_SEL_IN_SHIFT      (14)
> +#define MCI_CLK_QCOM_SEL_MASK          (0x3)
> +#define MCI_CLK_QCOM_SEL_RISING_EDGE   (1)
> +#define MCI_CLK_QCOM_SEL_FEEDBACK_CLK  (2)
> +#define MCI_CLK_QCOM_SEL_DDR_MODE      (3)
> +
> +/* mclk selection */
> +#define MCI_CLK_SDC4_MCLK_SEL_SHIFT    (23)
> +#define MCI_CLK_SDC4_MCLK_SEL_MASK     (0x3)
> +#define MCI_CLK_SDC4_MCLK_SEL_FB_CLK   (1)
> +#define MCI_CLK_SDC4_MCLK_SEL_MCLK     (2)

These seem to have no related siblings but should still be
renamed MCL_QCOM_*

Yours,
Linus Walleij
