Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaHUTpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:45:52 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46667 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaHUTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:45:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 04/29] drivers: base: add notifier for failed driver bind
Date: Thu, 21 Aug 2014 21:46:30 +0200
Message-ID: <5058601.WyRAooKDLt@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

Thank you for the patch.

On Tuesday 05 August 2014 12:47:32 Marek Szyprowski wrote:
> This patch adds support for getting a notify for failed device driver
> bind, so all the items done in BUS_NOTIFY_BIND_DRIVER event can be
> cleaned if the driver fails to bind.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/dd.c      | 10 +++++++---
>  include/linux/device.h |  4 +++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index e4ffbcf..541a41f 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -237,10 +237,14 @@ static int driver_sysfs_add(struct device *dev)
>  	return ret;
>  }
> 
> -static void driver_sysfs_remove(struct device *dev)
> +static void driver_sysfs_remove(struct device *dev, int failed)
>  {
>  	struct device_driver *drv = dev->driver;
> 
> +	if (failed && dev->bus)
> +		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> +					     BUS_NOTIFY_DRVBIND_FAILED, dev);

This might be a stupid question, but as you only call driver_sysfs_remove with 
failed set to true in a single location (in the failure path of really_probe), 
how about moving the blocking_notifier_call_chain to that location ? The code 
seems to be a bit out of place here.

> +
>  	if (drv) {
>  		sysfs_remove_link(&drv->p->kobj, kobject_name(&dev->kobj));
>  		sysfs_remove_link(&dev->kobj, "driver");
> @@ -316,7 +320,7 @@ static int really_probe(struct device *dev, struct
> device_driver *drv)
> 
>  probe_failed:
>  	devres_release_all(dev);
> -	driver_sysfs_remove(dev);
> +	driver_sysfs_remove(dev, true);
>  	dev->driver = NULL;
>  	dev_set_drvdata(dev, NULL);
> 
> @@ -509,7 +513,7 @@ static void __device_release_driver(struct device *dev)
>  	if (drv) {
>  		pm_runtime_get_sync(dev);
> 
> -		driver_sysfs_remove(dev);
> +		driver_sysfs_remove(dev, false);
> 
>  		if (dev->bus)
>  			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> diff --git a/include/linux/device.h b/include/linux/device.h
> index b387710..92daded 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -176,7 +176,7 @@ extern int bus_register_notifier(struct bus_type *bus,
>  extern int bus_unregister_notifier(struct bus_type *bus,
>  				   struct notifier_block *nb);
> 
> -/* All 4 notifers below get called with the target struct device *
> +/* All 7 notifers below get called with the target struct device *
>   * as an argument. Note that those functions are likely to be called
>   * with the device lock held in the core, so be careful.
>   */
> @@ -189,6 +189,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
> unbound */
>  #define BUS_NOTIFY_UNBOUND_DRIVER	0x00000006 /* driver is unbound
>  						      from the device */
> +#define BUS_NOTIFY_DRVBIND_FAILED	0x00000007 /* driver failed to bind
> +						      to device */
> 
>  extern struct kset *bus_get_kset(struct bus_type *bus);
>  extern struct klist *bus_get_device_klist(struct bus_type *bus);

-- 
Regards,

Laurent Pinchart

