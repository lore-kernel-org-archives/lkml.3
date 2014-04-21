Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaDUWUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:20:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49529 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaDUWUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:20:47 -0400
Message-ID: <535599BD.1020605@codeaurora.org>
Date: Mon, 21 Apr 2014 15:20:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: srinivas.kandagatla@linaro.org
CC: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 10/12] mmc: mmci: Add clock support for Qualcomm.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org> <1398116945-31640-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1398116945-31640-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 14:49, srinivas.kandagatla@linaro.org wrote:
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
> ---
>  drivers/mmc/host/mmci.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index f465eb5..2cd3a8f 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -291,7 +291,18 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
>  	host->cclk = 0;
>  
>  	if (desired) {
> -		if (desired >= host->mclk) {
> +		if (desired != host->mclk &&
> +		    host->hw_designer == AMBA_VENDOR_QCOM) {
> +			/* Qcom MCLKCLK register does not define bypass bits */
> +			int rc = clk_set_rate(host->clk, desired);

Please turn on lockdep (PROVE_LOCKING) and sleeping while atomic checks
(DEBUG_ATOMIC_SLEEP). You cannot call clk_set_rate() in atomic context.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

