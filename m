Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbaLWPh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:37:26 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:21987 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbaLWPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:37:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="53821601"
Message-ID: <54998C31.9090500@broadcom.com>
Date: Tue, 23 Dec 2014 16:37:21 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>, Brett Rudley <brudley@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christophe Prigent <christophe.prigent@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: Do not crash if platform data is not populated
References: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/14 15:48, Mika Westerberg wrote:
> The driver looks for pdata->oob_irq_supported to find out if wowl can be
> supported. However, not all platforms populate pdata in which case we crash
> the kernel because of NULL pointer dereference.

Thanks, Mika

However, this was already reported by Dan Carpenter and I submitted a 
patch for that a couple of days ago: "[PATCH 02/10] brcmfmac: Fix 
possible dereference of NULL pointer." [1].

Regards,
Arend

[1] 
http://mid.gmane.org/1419162233-19492-3-git-send-email-arend@broadcom.com

> Fixes: 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
> Reported-by: Christophe Prigent<christophe.prigent@intel.com>
> Signed-off-by: Mika Westerberg<mika.westerberg@linux.intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 3c06e9365949..9880dae2a569 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1070,7 +1070,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>   	 */
>   	if ((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_KEEP_POWER)&&
>   	((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_WAKE_SDIO_IRQ) ||
> -	     (sdiodev->pdata->oob_irq_supported)))
> +	     (sdiodev->pdata&&  sdiodev->pdata->oob_irq_supported)))
>   		bus_if->wowl_supported = true;
>   #endif
>
> @@ -1167,7 +1167,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
>   	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
>
>   	brcmf_dbg(SDIO, "Enter\n");
> -	if (sdiodev->pdata->oob_irq_supported)
> +	if (sdiodev->pdata&&  sdiodev->pdata->oob_irq_supported)
>   		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
>   	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
>   	atomic_set(&sdiodev->suspend, false);

