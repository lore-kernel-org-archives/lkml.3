Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaCOQXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 12:23:44 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60696 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaCOQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 12:23:43 -0400
Message-ID: <53247EC9.6090505@kernel.org>
Date: Sat, 15 Mar 2014 16:24:41 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Beomho Seo <beomho.seo@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] iio: cm36651: Fix i2c client leak and possible NULL pointer
 dereference
References: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 09:33, Krzysztof Kozlowski wrote:
> During probe the driver allocates dummy I2C devices (i2c_new_dummy())
> but they aren't unregistered during driver remove or probe failure.
>
> Additionally driver does not check the return value of i2c_new_dummy().
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later
> dereferenced by i2c_smbus_{read,write}_data() functions.
>
> Fix issues by properly checking for i2c_new_dummy() return value and
> unregistering I2C devices on driver remove or probe failure.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Good catch, but the error path needs more care.
> ---
>   drivers/iio/light/cm36651.c |   12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
> index a45e07492db3..e7e9a597159f 100644
> --- a/drivers/iio/light/cm36651.c
> +++ b/drivers/iio/light/cm36651.c
> @@ -653,6 +653,11 @@ static int cm36651_probe(struct i2c_client *client,
>   	cm36651->ps_client = i2c_new_dummy(client->adapter,
>   						     CM36651_I2C_ADDR_PS);
>   	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
> +	if (!cm36651->ps_client || !cm36651->ara_client) {
> +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> +		ret = -ENODEV;
> +		goto error_i2c_unregister;
> +	}
The two failures need to be handled independently as we only want to unregister
those that succeeded.  i2c_new_dummy will not return an error and leave a device
registered.  This is particularly true given the first thing that i2c_unregister_device
does is to derefence the client pointer.  That will cause a segfault if you do it
for NULL as here.

>   	mutex_init(&cm36651->lock);
>   	indio_dev->dev.parent = &client->dev;
>   	indio_dev->channels = cm36651_channels;
> @@ -687,6 +692,11 @@ error_free_irq:
>   	free_irq(client->irq, indio_dev);
>   error_disable_reg:
>   	regulator_disable(cm36651->vled_reg);
> +error_i2c_unregister:
> +	if (cm36651->ps_client)
> +		i2c_unregister_device(cm36651->ps_client);
> +	if (cm36651->ara_client)
> +		i2c_unregister_device(cm36651->ara_client);
>   	return ret;
>   }
>
> @@ -698,6 +708,8 @@ static int cm36651_remove(struct i2c_client *client)
>   	iio_device_unregister(indio_dev);
>   	regulator_disable(cm36651->vled_reg);
>   	free_irq(client->irq, indio_dev);
> +	i2c_unregister_device(cm36651->ps_client);
> +	i2c_unregister_device(cm36651->ara_client);
Good catch.
>
>   	return 0;
>   }
>

