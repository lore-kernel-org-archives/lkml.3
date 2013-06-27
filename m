Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3F0Qor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:44:47 -0400
Received: from void.printf.net ([89.145.121.20]:43659 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3F0Qoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:44:46 -0400
From: Chris Ball <cjb@laptop.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mmc: dw_mmc: Handle late vmmc regulators with EPROBE_DEFER
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
	<1370626110-1731-1-git-send-email-dianders@chromium.org>
Date: Thu, 27 Jun 2013 12:44:38 -0400
In-Reply-To: <1370626110-1731-1-git-send-email-dianders@chromium.org> (Doug
	Anderson's message of "Fri, 7 Jun 2013 10:28:29 -0700")
Message-ID: <87vc4zlczt.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Fri, Jun 07 2013, Doug Anderson wrote:
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index bc3a1bc..ab5642d 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1895,7 +1895,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	struct mmc_host *mmc;
>  	struct dw_mci_slot *slot;
>  	const struct dw_mci_drv_data *drv_data = host->drv_data;
> -	int ctrl_id, ret;
> +	int ctrl_id;
>  	u8 bus_width;
>  
>  	mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), host->dev);
> @@ -1985,19 +1985,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  #endif /* CONFIG_MMC_DW_IDMAC */
>  	}
>  
> -	host->vmmc = devm_regulator_get(mmc_dev(mmc), "vmmc");
> -	if (IS_ERR(host->vmmc)) {
> -		pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> -		host->vmmc = NULL;
> -	} else {
> -		ret = regulator_enable(host->vmmc);
> -		if (ret) {
> -			dev_err(host->dev,
> -				"failed to enable regulator: %d\n", ret);
> -			goto err_setup_bus;
> -		}
> -	}
> -
>  	if (dw_mci_get_cd(mmc))
>  		set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>  	else
> @@ -2023,10 +2010,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	queue_work(host->card_workqueue, &host->card_work);
>  
>  	return 0;
> -
> -err_setup_bus:
> -	mmc_free_host(mmc);
> -	return -EINVAL;
>  }
>  
>  static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)

This hunk breaks the build for me, because err_setup_bus and ret are
used in the error path of the call to mmc_add_host() in this function.

I'll push a version that leaves those in.  Let me know if you think
something strange is happening that made this work okay for you, like
a mismerge.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
