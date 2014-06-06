Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaFGHbF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 03:31:05 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:33338 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaFGHaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 03:30:18 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/9] i2c: Add pointer dereference protection to
 i2c_match_id()
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, linus.walleij@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1402069952-28022-2-git-send-email-lee.jones@linaro.org>
References: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
	<1402069952-28022-2-git-send-email-lee.jones@linaro.org>
Date: Fri, 06 Jun 2014 23:59:35 +0100
Message-Id: <20140606225935.7491DC4206E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Jun 2014 16:52:24 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> Here we're providing dereference protection for i2c_match_id(), which
> saves us having to do it each time it's called.  We're also stripping
> out the (now) needless checks in i2c_device_match().  This patch paves
> the way for other, similar code trimming.
> 
> Acked-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/i2c/i2c-core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 7c7f4b8..d3802dc 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -82,6 +82,9 @@ void i2c_transfer_trace_unreg(void)
>  static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
>  						const struct i2c_client *client)
>  {
> +	if (!(id && client))
> +		return NULL;
> +
>  	while (id->name[0]) {
>  		if (strcmp(client->name, id->name) == 0)
>  			return id;
> @@ -95,8 +98,6 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  	struct i2c_client	*client = i2c_verify_client(dev);
>  	struct i2c_driver	*driver;
>  
> -	if (!client)
> -		return 0;
>  
>  	/* Attempt an OF style match */
>  	if (of_driver_match_device(dev, drv))
> @@ -107,9 +108,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  		return 1;
>  
>  	driver = to_i2c_driver(drv);
> -	/* match on an id table if there is one */
> -	if (driver->id_table)
> -		return i2c_match_id(driver->id_table, client) != NULL;
> +
> +	/* Finally an I2C match */
> +	if (i2c_match_id(driver->id_table, client))
> +		return 1;
>  
>  	return 0;

Nit: the above 4 lines can now simply be:

	return (i2c_match_id(driver->id_table, client) != NULL);

g.
