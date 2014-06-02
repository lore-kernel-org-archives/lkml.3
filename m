Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaFBQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:07:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54093 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaFBQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:07:19 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/3] i2c: Add pointer dereference protection to
 i2c_match_id()
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wsa@the-dreams.de
Cc: linus.walleij@linaro.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <1401716463-23457-3-git-send-email-lee.jones@linaro.org>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
	<1401716463-23457-3-git-send-email-lee.jones@linaro.org>
Date: Mon, 02 Jun 2014 17:07:15 +0100
Message-Id: <20140602160715.5E90FC40476@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 14:41:02 +0100, Lee Jones <lee.jones@linaro.org> wrote:
> Here we're providing dereference protection for i2c_match_id(), which
> saves us having to do it each time it's called.  We're also stripping
> out the (now) needless check in i2c_device_match().  This patch paves
> the way for other, similar code trimming.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Seems reasonable.

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/i2c/i2c-core.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 2e47641..d0c7180 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -83,6 +83,9 @@ void i2c_transfer_trace_unreg(void)
>  static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
>  						const struct i2c_client *client)
>  {
> +	if (!id)
> +		return NULL;
> +
>  	while (id->name[0]) {
>  		if (strcmp(client->name, id->name) == 0)
>  			return id;
> @@ -108,9 +111,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
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
>  }
> -- 
> 1.8.3.2
> 

