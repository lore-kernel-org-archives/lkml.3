Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLaLWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:22:47 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56843 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:22:45 -0500
Message-ID: <54A3DC80.1080505@cogentembedded.com>
Date: Wed, 31 Dec 2014 14:22:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>, brudley@broadcom.com,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        kvalo@codeaurora.org, linville@tuxdriver.com, pieterpg@broadcom.com,
        hdegoede@redhat.com, wens@csie.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54A3B1B4.7090705@linux.intel.com>
In-Reply-To: <54A3B1B4.7090705@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/31/2014 11:20 AM, Fu, Zhonghui wrote:

>  From e34419970a07bfcd365f9c66bdfa552188a0cd26 Mon Sep 17 00:00:00 2001
> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> Date: Mon, 29 Dec 2014 21:25:31 +0800
> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation

> WiFi chip has 2 SDIO functions, and PM core will trigger
> twice suspend/resume operations for one WiFi chip to do
> the same things. This patch avoid this case.

> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   19 +++++++++++++++++--
>   1 files changed, 17 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 3c06e93..eee7818 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1139,11 +1139,18 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
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
> +	if (func->num == 2) {
> +		return 0;
> +	}

    {} not needed.

[...]
> @@ -1164,9 +1171,17 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
>   static int brcmf_ops_sdio_resume(struct device *dev)
>   {
>   	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
> +	struct brcmf_sdio_dev *sdiodev;
> +	struct sdio_func *func = dev_to_sdio_func(dev);
>
>   	brcmf_dbg(SDIO, "Enter\n");
> +
> +	if (func->num == 2) {
> +		return 0;
> +	}

    Same here.

[...]

WBR, Sergei

