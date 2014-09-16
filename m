Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaIPSBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:01:20 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40531 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaIPSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
Date: Tue, 16 Sep 2014 20:01:17 +0200
Message-ID: <CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: add card power off during probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 03:39,  <micky_ching@realsil.com.cn> wrote:
> From: Roger Tseng <rogerable@realtek.com>
>
> Some platform have both UEFI driver and MFD/mmc driver, if entering
> linux while card in the slot, the card power is already on, and rtsx-mmc
> driver have no chance to make card power off. This will lead UHSI card
> failed to enter UHSI mode.
>
> It is hard to control the UEFI driver leaving state, so we power off the
> card power during probe.
>
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index dfde4a2..57b0796 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -1341,8 +1341,13 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
>         host->pcr = pcr;
>         host->mmc = mmc;
>         host->pdev = pdev;
> -       host->power_state = SDMMC_POWER_OFF;
>         INIT_WORK(&host->work, sd_request);
> +       sd_power_off(host);
> +       /*
> +        * ref: SD spec 3.01: 6.4.1.2 Power On or Power Cycle
> +        */
> +       usleep_range(1000, 2000);
> +

This won't work in cases were you power off eMMC cards, unless you can
do a full power cycle - cut both VCC and VCCQ. Can you?

There are also another option you might want to use,
MMC_CAP2_NO_PRESCAN_POWERUP. But again, it must only be used for those
hosts that you are able to do a full power cycle for.

Kind regards
Uffe

>         platform_set_drvdata(pdev, host);
>         pcr->slots[RTSX_SD_CARD].p_dev = pdev;
>         pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
> --
> 1.7.9.5
>
