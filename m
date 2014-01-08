Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaAHJ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:59:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60074 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbaAHJ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:59:30 -0500
Message-ID: <52CD2176.6050102@ti.com>
Date: Wed, 8 Jan 2014 15:29:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <b.zolnierkie@samsung.com>,
        <hdegoede@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v3 2/3] ata: ahci_platform: Manage SATA PHY
References: <1389174428-31414-1-git-send-email-rogerq@ti.com> <1389174428-31414-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1389174428-31414-3-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wednesday 08 January 2014 03:17 PM, Roger Quadros wrote:
> From: Balaji T K <balajitk@ti.com>
> 
> Some platforms have a PHY hooked up to the
> SATA controller. The PHY needs to be initialized
> and powered up for SATA to work. We do that
> using the PHY framework.
> 
> [Roger Q] Cleaned up.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Balaji T K <balajitk@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/ata/ahci.h          |  2 ++
>  drivers/ata/ahci_platform.c | 28 +++++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 2289efd..f9bbada 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -37,6 +37,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/libata.h>
> +#include <linux/phy/phy.h>
>  
>  /* Enclosure Management Control */
>  #define EM_CTRL_MSG_TYPE              0x000f0000
> @@ -322,6 +323,7 @@ struct ahci_host_priv {
>  	u32			em_buf_sz;	/* EM buffer size in byte */
>  	u32			em_msg_type;	/* EM message type */
>  	struct clk		*clk;		/* Only for platforms supporting clk */
> +	struct phy		*phy;		/* If platform uses phy */
>  	void			*plat_data;	/* Other platform data */
>  };
>  
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index d5ced13..f61093b 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -142,6 +142,21 @@ static int ahci_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	hpriv->phy = devm_phy_get(dev, "sata-phy");
> +	if (IS_ERR(hpriv->phy)) {
> +		dev_dbg(dev, "can't get sata-phy\n");
> +		/* return only if -EPROBE_DEFER */
> +		if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
> +			rc = -EPROBE_DEFER;
> +			goto disable_unprepare_clk;
> +		}
> +	}
> +
> +	if (!IS_ERR(hpriv->phy)) {
> +		phy_init(hpriv->phy);

Don't we have to check the return values of phy_init and phy_power_on? Is it
not needed because it is an optional phy?

Thanks
Kishon
