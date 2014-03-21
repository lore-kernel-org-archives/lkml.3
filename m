Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbaCUHzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:55:32 -0400
Received: from smtp-out-034.synserver.de ([212.40.185.34]:1046 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754089AbaCUHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:55:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2775
Message-ID: <532BF09E.4050305@metafoo.de>
Date: Fri, 21 Mar 2014 08:56:14 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] adv7180: free an interrupt on failure paths in
 init_device()
References: <1394831043-21425-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1394831043-21425-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:04 PM, Alexey Khoroshilov wrote:
> There is request_irq() in init_device(), but the interrupt is not removed
> on failure paths. The patch adds proper error handling.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Hi,

Thanks for the patch. It's actually worse than that. request_irq should not 
be called in init_device() since init_device() is also called on resume(). 
The request_irq call should be moved to probe() and be called after init 
device. I've recently made some modifications to this part of the driver 
(switched to threaded IRQs), so make sure you generate the patch against the 
media/master tree.

Thanks,
- Lars

> ---
>   drivers/media/i2c/adv7180.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index d7d99f1c69e4..e462392ba043 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -541,40 +541,44 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
>   						ADV7180_ADI_CTRL_IRQ_SPACE);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		/* config the Interrupt pin to be active low */
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_ICONF1_ADI,
>   						ADV7180_ICONF1_ACTIVE_LOW |
>   						ADV7180_ICONF1_PSYNC_ONLY);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR1_ADI, 0);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR2_ADI, 0);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		/* enable AD change interrupts interrupts */
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR3_ADI,
>   						ADV7180_IRQ3_AD_CHANGE);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_IMR4_ADI, 0);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>
>   		ret = i2c_smbus_write_byte_data(client, ADV7180_ADI_CTRL_REG,
>   						0);
>   		if (ret < 0)
> -			return ret;
> +			goto err;
>   	}
>
>   	return 0;
> +
> +err:
> +	free_irq(state->irq, state);
> +	return ret;
>   }
>
>   static int adv7180_probe(struct i2c_client *client,
>

