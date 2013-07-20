Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3GTNFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:05:16 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37248 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723Ab3GTNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:05:13 -0400
Message-ID: <51EA8B06.3080005@metafoo.de>
Date: Sat, 20 Jul 2013 15:05:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jic23@cam.ac.uk,
        pmeerw@pmeerw.net, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org, grygorii.strashko@ti.com,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH 1/3] iio: core: implement devm_iio_device_alloc/devm_iio_device_free
References: <1374142766-29736-1-git-send-email-x0199363@ti.com>
In-Reply-To: <1374142766-29736-1-git-send-email-x0199363@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 12:19 PM, Oleksandr Kravchenko wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
>
> Add a resource managed devm_iio_device_alloc()/devm_iio_device_free()
> to automatically clean up any allocations made by IIO drivers,
> thus leading to simplified IIO drivers code.
>
> In addition, this will allow IIO drivers to use other devm_*() API
> (like devm_request_irq) and don't care about the race between
> iio_device_free() and the release of resources by Device core
> during driver removing.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> [o.v.kravchenko@globallogic.com: fix return value ib devm_iio_device_alloc
> in case if devres_alloc failed, remove unused variable "rc"]
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> Tested-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

Very nice, thanks for taking care of this.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>


> ---
>   drivers/iio/industrialio-core.c |   47 +++++++++++++++++++++++++++++++++++++++
>   include/linux/iio/iio.h         |   25 +++++++++++++++++++++
>   2 files changed, 72 insertions(+)
>
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index e145931..d56d122 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -912,6 +912,53 @@ void iio_device_free(struct iio_dev *dev)
>   }
>   EXPORT_SYMBOL(iio_device_free);
>
> +static void devm_iio_device_release(struct device *dev, void *res)
> +{
> +	iio_device_free(*(struct iio_dev **)res);
> +}
> +
> +static int devm_iio_device_match(struct device *dev, void *res, void *data)
> +{
> +	struct iio_dev **r = res;
> +	if (!r || !*r) {
> +		WARN_ON(!r || !*r);
> +		return 0;
> +	}
> +	return *r == data;
> +}
> +
> +struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv)
> +{
> +	struct iio_dev **ptr, *iio_dev;
> +
> +	ptr = devres_alloc(devm_iio_device_release, sizeof(*ptr),
> +			   GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	/* use raw alloc_dr for kmalloc caller tracing */
> +	iio_dev = iio_device_alloc(sizeof_priv);
> +	if (iio_dev) {
> +		*ptr = iio_dev;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return iio_dev;
> +}
> +EXPORT_SYMBOL_GPL(devm_iio_device_alloc);
> +
> +void devm_iio_device_free(struct device *dev, struct iio_dev *iio_dev)
> +{
> +	int rc;
> +
> +	rc = devres_release(dev, devm_iio_device_release,
> +			    devm_iio_device_match, iio_dev);
> +	WARN_ON(rc);
> +}
> +EXPORT_SYMBOL_GPL(devm_iio_device_free);
> +
>   /**
>    * iio_chrdev_open() - chrdev file open for buffer access and ioctls
>    **/
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 8d171f4..f1d99f6 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -532,6 +532,31 @@ static inline struct iio_dev *iio_priv_to_dev(void *priv)
>   void iio_device_free(struct iio_dev *indio_dev);
>
>   /**
> + * devm_iio_device_alloc - Resource-managed iio_device_alloc()
> + * @dev: 		Device to allocate iio_dev for
> + * @sizeof_priv: 	Space to allocate for private structure.
> + *
> + * Managed iio_device_alloc.  iio_dev allocated with this function is
> + * automatically freed on driver detach.
> + *
> + * If an iio_dev allocated with this function needs to be freed separately,
> + * devm_iio_device_free() must be used.
> + *
> + * RETURNS:
> + * Pointer to allocated iio_dev on success, NULL on failure.
> + */
> +struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv);
> +
> +/**
> + * devm_iio_device_free - Resource-managed iio_device_free()
> + * @dev:		Device this iio_dev belongs to
> + * @indio_dev: 		the iio_dev associated with the device
> + *
> + * Free indio_dev allocated with devm_iio_device_alloc().
> + */
> +void devm_iio_device_free(struct device *dev, struct iio_dev *iio_dev);
> +
> +/**
>    * iio_buffer_enabled() - helper function to test if the buffer is enabled
>    * @indio_dev:		IIO device structure for device
>    **/
>

