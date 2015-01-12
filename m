Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbbALKBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:01:11 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:55150 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbbALKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:01:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,743,1413270000"; 
   d="scan'208";a="54594534"
Message-ID: <54B39B59.8000907@broadcom.com>
Date: Mon, 12 Jan 2015 11:00:57 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: <brudley@broadcom.com>, Franky Lin <frankyl@broadcom.com>,
        <meuleman@broadcom.com>, <kvalo@codeaurora.org>,
        <linville@tuxdriver.com>, <pieterpg@broadcom.com>,
        <hdegoede@redhat.com>, <wens@csie.org>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54B36C88.3030609@linux.intel.com>
In-Reply-To: <54B36C88.3030609@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 07:41, Fu, Zhonghui wrote:
>  From 8685c3c2746b4275fc808d9db23c364b2f54b52a Mon Sep 17 00:00:00 2001
> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
> Date: Mon, 12 Jan 2015 14:25:46 +0800
> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>
> WiFi chip has 2 SDIO functions, and PM core will trigger
> twice suspend/resume operations for one WiFi chip to do
> the same things. This patch avoid this case.
>
> Acked-by: Arend van Spriel<arend@broadcom.com>
> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>

This patch needs to be rebased.

Kalle,

Please drop this one.

Regards,
Arend

> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   21 +++++++++++++++++----
>   1 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 9880dae..8f71485 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1070,7 +1070,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>   	 */
>   	if ((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_KEEP_POWER)&&
>   	((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_WAKE_SDIO_IRQ) ||
> -	     (sdiodev->pdata&&  sdiodev->pdata->oob_irq_supported)))
> +	     (sdiodev->pdata->oob_irq_supported)))
>   		bus_if->wowl_supported = true;
>   #endif
>
> @@ -1139,11 +1139,17 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
>   static int brcmf_ops_sdio_suspend(struct device *dev)
>   {
>   	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> +	struct brcmf_sdio_dev *sdiodev;
>   	mmc_pm_flag_t sdio_flags;
> +	struct sdio_func *func = dev_to_sdio_func(dev);
>
>   	brcmf_dbg(SDIO, "Enter\n");
>
> +	if (func->num == 2)
> +		return 0;
> +
> +	sdiodev = bus_if->bus_priv.sdio;
> +
>   	atomic_set(&sdiodev->suspend, true);
>
>   	if (sdiodev->wowl_enabled) {
> @@ -1164,10 +1170,17 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
>   static int brcmf_ops_sdio_resume(struct device *dev)
>   {
>   	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> +	struct brcmf_sdio_dev *sdiodev;
> +	struct sdio_func *func = dev_to_sdio_func(dev);
>
>   	brcmf_dbg(SDIO, "Enter\n");
> -	if (sdiodev->pdata&&  sdiodev->pdata->oob_irq_supported)
> +
> +	if (func->num == 2)
> +		return 0;
> +
> +	sdiodev = bus_if->bus_priv.sdio;
> +
> +	if (sdiodev->pdata->oob_irq_supported)
>   		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
>   	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
>   	atomic_set(&sdiodev->suspend, false);
> -- 1.7.1
>

