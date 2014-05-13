Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbaEMI2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:28:21 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49935 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEMI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <1398759651-13341-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759651-13341-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Tue, 13 May 2014 10:28:18 +0200
Message-ID: <CACRpkdYtiTrnVSOz055KNs=DWM3ai5NhPBKXPm8bxFPxYov81Q@mail.gmail.com>
Subject: Re: [PATCH v1 09/11] mmc: mmci: Add clock support for Qualcomm.
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
> MCICLK going to card bus is directly driven by the clock controller, so the
> driver has to set the required rates depending on the state of the card. This
> bit of support is very much similar to bypass mode but there is no such thing
> called bypass mode in MCICLK register of Qcom SD card controller. By default
> the clock is directly driven by the clk controller.
>
> This patch adds clock support for Qualcomm SDCC in the driver. This bit of
> code is conditioned on hw designer.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
(...)
> +               if (host->hw_designer == AMBA_VENDOR_QCOM) {
> +                       host->cclk = host->mclk;
> +               } else if (desired >= host->mclk) {

Again refrain from hard-checking the vendor everywhere.

struct variant_data {
        bool            qcom_cclk_is_mclk;
(...)

As per example from st_clkdiv...

Then

if (host->vendor->qcom_cclk_is_mclk) {
  (...)
}

> +       if (ios->clock != host->mclk &&
> +               host->hw_designer == AMBA_VENDOR_QCOM) {
> +               /* Qcom MCLKCLK register does not define bypass bits */
> +               int rc = clk_set_rate(host->clk, ios->clock);
> +               if (rc < 0) {
> +                       dev_err(mmc_dev(host->mmc),
> +                               "Error setting clock rate (%d)\n", rc);
> +               } else {
> +                       host->mclk = clk_get_rate(host->clk);
> +                       host->cclk = host->mclk;
> +               }
> +       }

For this I would define a vendor data like:

struct variant_data {
        bool            explicit_mclk_control;
(...)

Or something. It explains what is actually going on.

>         if (plat->f_max)
> -               mmc->f_max = min(host->mclk, plat->f_max);
> +               mmc->f_max = (host->hw_designer == AMBA_VENDOR_QCOM) ?
> +                               plat->f_max : min(host->mclk, plat->f_max);

So rewrite like that:

if (host->vendor->explicit_mclk_control)
       mmc->f_max = plat->f_max;
else
      mmc->f_max = min(host->mclk, plat->f_max);

Yours,
Linus Walleij
