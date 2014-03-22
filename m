Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaCVMWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:22:54 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53295 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaCVMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:22:52 -0400
Message-ID: <532D80DC.3080903@kernel.org>
Date: Sat, 22 Mar 2014 12:23:56 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Beomho Seo <beomho.seo@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: cm36651: Fix i2c client leak and possible NULL
 pointer dereference
References: <1395130410-15865-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1395130410-15865-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/14 08:13, Krzysztof Kozlowski wrote:
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
> Acked-by: Beomho Seo <beomho.seo@samsung.com>
Applied to the fixes-togreg branch of iio.git and marked for
stable.

This will probably go in shortly after the 3.15-rc1
> ---
>   drivers/iio/light/cm36651.c |   22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
> index a45e07492db3..39fc67e82138 100644
> --- a/drivers/iio/light/cm36651.c
> +++ b/drivers/iio/light/cm36651.c
> @@ -652,7 +652,19 @@ static int cm36651_probe(struct i2c_client *client,
>   	cm36651->client = client;
>   	cm36651->ps_client = i2c_new_dummy(client->adapter,
>   						     CM36651_I2C_ADDR_PS);
> +	if (!cm36651->ps_client) {
> +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> +		ret = -ENODEV;
> +		goto error_disable_reg;
> +	}
> +
>   	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
> +	if (!cm36651->ara_client) {
> +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> +		ret = -ENODEV;
> +		goto error_i2c_unregister_ps;
> +	}
> +
>   	mutex_init(&cm36651->lock);
>   	indio_dev->dev.parent = &client->dev;
>   	indio_dev->channels = cm36651_channels;
> @@ -664,7 +676,7 @@ static int cm36651_probe(struct i2c_client *client,
>   	ret = cm36651_setup_reg(cm36651);
>   	if (ret) {
>   		dev_err(&client->dev, "%s: register setup failed\n", __func__);
> -		goto error_disable_reg;
> +		goto error_i2c_unregister_ara;
>   	}
>
>   	ret = request_threaded_irq(client->irq, NULL, cm36651_irq_handler,
> @@ -672,7 +684,7 @@ static int cm36651_probe(struct i2c_client *client,
>   							"cm36651", indio_dev);
>   	if (ret) {
>   		dev_err(&client->dev, "%s: request irq failed\n", __func__);
> -		goto error_disable_reg;
> +		goto error_i2c_unregister_ara;
>   	}
>
>   	ret = iio_device_register(indio_dev);
> @@ -685,6 +697,10 @@ static int cm36651_probe(struct i2c_client *client,
>
>   error_free_irq:
>   	free_irq(client->irq, indio_dev);
> +error_i2c_unregister_ara:
> +	i2c_unregister_device(cm36651->ara_client);
> +error_i2c_unregister_ps:
> +	i2c_unregister_device(cm36651->ps_client);
>   error_disable_reg:
>   	regulator_disable(cm36651->vled_reg);
>   	return ret;
> @@ -698,6 +714,8 @@ static int cm36651_remove(struct i2c_client *client)
>   	iio_device_unregister(indio_dev);
>   	regulator_disable(cm36651->vled_reg);
>   	free_irq(client->irq, indio_dev);
> +	i2c_unregister_device(cm36651->ps_client);
> +	i2c_unregister_device(cm36651->ara_client);
>
>   	return 0;
>   }
>

