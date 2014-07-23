Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaGWQBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:01:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaGWQBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:01:35 -0400
Date: Wed, 23 Jul 2014 18:01:30 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] EEPROM: Introduce the use of devm_kzalloc
Message-ID: <20140723180130.33980275@endymion.delvare>
In-Reply-To: <20140723144318.GA3247@himangi-Dell>
References: <20140723144318.GA3247@himangi-Dell>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Wed, 23 Jul 2014 20:13:18 +0530, Himangi Saraogi wrote:
> This patch introduces the use of devm_kzalloc and does away with the
> kfrees in the probe and remove functions. Also, a label and the err
> variable are removed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/misc/eeprom/eeprom.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> index 33f8673..6d75fcf 100644
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
> +			    GFP_KERNEL)

That does not even build:

drivers/misc/eeprom/eeprom.c: In function ‘eeprom_probe’:
drivers/misc/eeprom/eeprom.c:165:2: error: expected ‘;’ before ‘if’
  if (!data)
  ^

Please test-build patches before you send them. That's a minimum,
ideally you should also do basic run-time testing if possible.

Please also note my new e-mail address and use that when you resubmit.

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


-- 
Jean Delvare
SUSE L3 Support
