Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaHCMyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:54:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaHCMyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:54:16 -0400
Date: Sun, 3 Aug 2014 14:54:11 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3] EEPROM: Introduce the use of devm_kzalloc
Message-ID: <20140803145411.03518a67@endymion.delvare>
In-Reply-To: <20140801190423.GA7281@himangi-Dell>
References: <20140801190423.GA7281@himangi-Dell>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2014 00:34:23 +0530, Himangi Saraogi wrote:
> This patch introduces the use of devm_kzalloc and does away with the
> kfrees in the probe and remove functions. Also, a label and the err
> variable are removed. The header device.h is included to make the devm_
> function explicitly available and slab.h is done away with as it is no
> longer needed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v3: change headers included.
>  drivers/misc/eeprom/eeprom.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> index 33f8673..b432873 100644
> --- a/drivers/misc/eeprom/eeprom.c
> +++ b/drivers/misc/eeprom/eeprom.c
> @@ -18,7 +18,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/slab.h>
> +#include <linux/device.h>
>  #include <linux/jiffies.h>
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
> @@ -159,12 +159,11 @@ static int eeprom_probe(struct i2c_client *client,
>  {
>  	struct i2c_adapter *adapter = client->adapter;
>  	struct eeprom_data *data;
> -	int err;
>  
> -	if (!(data = kzalloc(sizeof(struct eeprom_data), GFP_KERNEL))) {
> -		err = -ENOMEM;
> -		goto exit;
> -	}
> +	data = devm_kzalloc(&client->dev, sizeof(struct eeprom_data),
> +			    GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
>  
>  	memset(data->data, 0xff, EEPROM_SIZE);
>  	i2c_set_clientdata(client, data);
> @@ -190,22 +189,12 @@ static int eeprom_probe(struct i2c_client *client,
>  	}
>  
>  	/* create the sysfs eeprom file */
> -	err = sysfs_create_bin_file(&client->dev.kobj, &eeprom_attr);
> -	if (err)
> -		goto exit_kfree;
> -
> -	return 0;
> -
> -exit_kfree:
> -	kfree(data);
> -exit:
> -	return err;
> +	return sysfs_create_bin_file(&client->dev.kobj, &eeprom_attr);
>  }
>  
>  static int eeprom_remove(struct i2c_client *client)
>  {
>  	sysfs_remove_bin_file(&client->dev.kobj, &eeprom_attr);
> -	kfree(i2c_get_clientdata(client));
>  
>  	return 0;
>  }

Thanks Himangi.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
