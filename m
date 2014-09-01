Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaIAHt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:49:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35450 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:49:24 -0400
Date: Mon, 1 Sep 2014 08:49:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, arnd@arndb.de, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon
 devices
Message-ID: <20140901074918.GB6226@lee--X1>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Pankaj Dubey wrote:

> From: Tomasz Figa <t.figa@samsung.com>
> 
> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated driver. However in certain use
> cases it is desirable to make a device used with another driver a syscon
> interface provider. For example, certain SoCs (e.g. Exynos) contain
> system controller blocks which perform various functions such as power
> domain control, CPU power management, low power mode control, but in
> addition contain certain IP integration glue, such as various signal
> masks, coprocessor power control, etc. In such case, there is a need to
> have a dedicated driver for such system controller but also share
> registers with other drivers. The latter is where the syscon interface
> is helpful.
> 
> This patch decouples syscon object from syscon driver, so that it can be
> registered from any driver in addition to the original "syscon" platform
> driver.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
> 
> RFC patch [1] was posted by Tomasz Figa. This patch addresses some of
> comments given by Arnd to RFC patch, and further decouples syscon from
> device model. It also gives flexibility of registering with syscon at
> early stage using device_node object.

It would be helpful if Arnd gave this revision his blessing (Ack).

> [1]: https://lkml.org/lkml/2014/6/17/331
> 
>  drivers/mfd/syscon.c       |  112 ++++++++++++++++++++++++++++----------------
>  include/linux/mfd/syscon.h |   14 ++++++
>  2 files changed, 86 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..a91db30 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -14,6 +14,7 @@

[...]

>  struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
>  {
> -	struct device *dev;
> -	struct syscon *syscon;
> -
> -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> -				 syscon_match_pdevname);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> -
> -	syscon = dev_get_drvdata(dev);
> +	struct syscon *entry, *syscon = NULL;
> +	struct platform_device *pdev = NULL;
> +
> +	spin_lock(&syscon_list_slock);
> +	list_for_each_entry(entry, &syscon_list, list) {
> +		 pdev = of_find_device_by_node(entry->np);

White space error.

Did you run this through checkpatch.pl?

> +		if (pdev && !strcmp(dev_name(&pdev->dev), s)) {
> +			syscon = entry;
> +			break;
> +		}
> +	}
> +	spin_unlock(&syscon_list_slock);
>  
> -	return syscon->regmap;
> +	return syscon ? syscon->regmap : ERR_PTR(-EPROBE_DEFER);
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
