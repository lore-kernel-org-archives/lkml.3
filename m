Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3HFWBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:01:47 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:54917 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3HFWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:01:46 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] mmc: dw_mmc: Always setup the bus after suspend/resume
Date: Wed, 07 Aug 2013 00:01:40 +0200
Message-ID: <2191284.pFoOZbBSml@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375825071-20922-4-git-send-email-dianders@chromium.org>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org> <1375825071-20922-1-git-send-email-dianders@chromium.org> <1375825071-20922-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 of August 2013 14:37:50 Doug Anderson wrote:
> After suspend/resume all of the dw_mmc registers are reset to
> defaults.  We restore most of them, but specifically don't setup the
> clock registers after resume unless we've got a powered card.  Things
> still work because the core will eventually call set_ios() and we'll
> set things up.
> 
> There doesn't seem to be any reason that I can see _not_ to set things
> up after resume.  Restoring this state makes the code easier to reason
> about and should help prevent bugs.  It also allows us to do a
> register dump before and after suspend/resume to confirm that we've
> set things up OK.
> 
> I examined the state of the dw_mmc instance before and after suspend
> after this patch.  I had no card inserted in an SD card slot.
> 
> Before this patch, differences were:
> * CLKDIV (0x08)
> * CLKENA (0x10)
> * TMOUT (0x14)
> * CMD (0x2C) - difference is not important
> * CLKSEL (0x9C - exynos specific)
> 
> After this patch, only TMOUT was different.  I have a separate patch
> for that.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mmc/host/dw_mmc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 13a363c..0fa3135 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2522,9 +2522,7 @@ int dw_mci_resume(struct dw_mci *host)
>  		struct dw_mci_slot *slot = host->slot[i];
>  		if (!slot)
>  			continue;
> -		if (slot->mmc->pm_flags & MMC_PM_KEEP_POWER) {
> -			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> -		}
> +		dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> 
>  		ret = mmc_resume_host(host->slot[i]->mmc);
>  		if (ret < 0)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

