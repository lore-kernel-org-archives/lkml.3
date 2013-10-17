Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3JQOP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:15:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60431 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3JQOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:15:26 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-1f-525ff0fce156
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tj@kernel.org, sergei.shtylyov@cogentembedded.com, kishon@ti.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v2 2/2] ata: ahci_platform: runtime resume the device
 before use
Date: Thu, 17 Oct 2013 16:15:21 +0200
Message-id: <1662147.qHgNzWWiSr@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1381923773-10596-3-git-send-email-rogerq@ti.com>
References: <1381923773-10596-1-git-send-email-rogerq@ti.com>
 <1381923773-10596-3-git-send-email-rogerq@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jAd0/H+KDDI5M17eYOnk7m8WFpz1s
	Fsd2PGKyuLxrDptFzyMtizOrbrFb/Fp+lNGB3ePB1P9MHptWdbJ5HL+xncnj8ya5AJYoLpuU
	1JzMstQifbsErox/H06wFHwTqDi94i9jA+NF3i5GTg4JAROJb4/msULYYhIX7q1n62Lk4hAS
	WMQoMaNnPhtIQkighUni0blIEJtNwEpiYvsqRhBbREBR4t5KiAZmgfmMEpvW7WIBSQgLhEk0
	31vPDmKzCKhKLP11HSzOK6ApcerRQ7BmUQFPiR3bVwI1c3BwCthJXNupCbGrUKJh1VN2iHJB
	iR+T74G1MgvIS+zbP5UVwtaR2N86jW0Co8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwYD+T2sG4ssHiEKMAB6MSD+/M5XFBQqyJZcWVuYcYJTiYlUR4Xe7HBwnx
	piRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgrNvNVFZx8sly
	AzP2xEBh18iPr/dNXaer9Ur+7rw3fY2JkariJ+1nGBtesHoZ/uHVobPhLM+LHCN+rTrmGZFi
	dGdfgru0cvq3tj2HvnssaZhb/a8vL3fKop+reQ5YZPxf85FB7LlWosgSe7WDF7RLylWWbbU+
	Iegs/8Yiz4qFJ/dlaN8T4/48JZbijERDLeai4kQANLZoT2gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, October 16, 2013 02:42:53 PM Roger Quadros wrote:
> On OMAP platforms the device needs to be runtime resumed before
> it can be accessed. The OMAP HWMOD framework takes care of
> enabling the module and its resources based on the
> device's runtime PM state.
> 
> In this patch we runtime resume during .probe() and runtime suspend
> during .remove() (i.e. ahci_host_stop()).
> 
> We also update the runtime PM state during .resume().
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: Balaji T K <balajitk@ti.com>
> ---
>  drivers/ata/ahci_platform.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 5a0f1418..0da3b95 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -23,6 +23,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/libata.h>
>  #include <linux/ahci_platform.h>
> +#include <linux/pm_runtime.h>
>  #include "ahci.h"
>  
>  static void ahci_host_stop(struct ata_host *host);
> @@ -141,6 +142,9 @@ static int ahci_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	pm_runtime_enable(dev);
> +	pm_runtime_get_sync(dev);
> +
>  	hpriv->phy = devm_phy_get(dev, "sata-phy");
>  	if (IS_ERR(hpriv->phy)) {
>  		dev_dbg(dev, "can't get sata-phy\n");
> @@ -268,6 +272,9 @@ static void ahci_host_stop(struct ata_host *host)
>  		clk_disable_unprepare(hpriv->clk);
>  		clk_put(hpriv->clk);
>  	}
> +
> +	pm_runtime_put_sync(dev);
> +	pm_runtime_disable(dev);

It would be better to add proper .remove callback (i.e. named
ahci_remove_one) and put this code there so it matches .probe
callback.

>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -339,6 +346,11 @@ static int ahci_resume(struct device *dev)
>  
>  	ata_host_resume(host);
>  
> +	/* We resumed so update PM runtime state */
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +
>  	return 0;
>  
>  disable_unprepare_clk:

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

