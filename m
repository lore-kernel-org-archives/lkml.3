Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaHGBOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:14:40 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64421 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaHGBOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:14:38 -0400
Message-ID: <53E2D2F8.7010606@gmail.com>
Date: Thu, 07 Aug 2014 03:14:32 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: atmel_mxt_ts - Get IRQ edge/level flags on
 DT booting
References: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1407372486-25881-1-git-send-email-javier.martinez@collabora.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 07.08.2014 02:48, Javier Martinez Canillas wrote:
> The Atmel maXTouch driver assumed that the IRQ type flags will
> always be passed using platform data but this is not true when
> booting using Device Trees. In these setups the interrupt type
> was ignored by the driver when requesting an IRQ.
> 
> This means that it will fail if a machine specified other type
> than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
> that was parsed by OF from the "interrupt" Device Tree propery.

Have you observed an actual failure due to this? I believe that
irq_of_parse_and_map() already sets up IRQ trigger type based on DT
data, by calling irq_create_of_mapping() which in turn calls
irq_set_irq_type().

> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 03b8571..0fb56c9 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -22,6 +22,7 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c/atmel_mxt_ts.h>
>  #include <linux/input/mt.h>
> +#include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/of.h>
>  #include <linux/slab.h>
> @@ -2130,6 +2131,7 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	struct mxt_data *data;
>  	const struct mxt_platform_data *pdata;
>  	int error;
> +	unsigned long irqflags;
>  
>  	pdata = dev_get_platdata(&client->dev);
>  	if (!pdata) {
> @@ -2156,8 +2158,13 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	init_completion(&data->reset_completion);
>  	init_completion(&data->crc_completion);
>  
> +	if (client->dev.of_node)
> +		irqflags = irq_get_trigger_type(client->irq);

It might be a bit cleaner to just assign the flags to pdata->irqflags in
mxt_parse_dt() instead. That would also account for the fact that pdata,
if provided, should have priority over DT.

Best regards,
Tomasz
