Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbaGXIYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:24:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934120AbaGXIYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:24:31 -0400
Date: Thu, 24 Jul 2014 10:24:27 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2] EEPROM: Introduce the use of devm_kzalloc
Message-ID: <20140724102427.34c9e670@endymion.delvare>
In-Reply-To: <20140723211311.GA4165@himangi-Dell>
References: <20140723211311.GA4165@himangi-Dell>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Thu, 24 Jul 2014 02:43:11 +0530, Himangi Saraogi wrote:
> This patch introduces the use of devm_kzalloc and does away with the
> kfrees in the probe and remove functions. Also, a label and the err
> variable are removed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: add missing semi-colon
>  drivers/misc/eeprom/eeprom.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> index 33f8673..f4aff20 100644
> --- a/drivers/misc/eeprom/eeprom.c
> +++ b/drivers/misc/eeprom/eeprom.c
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

devm_kzalloc is declared in <linux/device.h> which is not included.
OTOH you still include <linux/slab.h> which is no longer needed.

Other than that (and the fact that you ignored my request to switch to
my new e-mail address), this looks good, thanks for the cleanup.

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

-- 
Jean Delvare
SUSE L3 Support
