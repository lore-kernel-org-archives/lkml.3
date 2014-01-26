Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaAZMqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:46:00 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:38825 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaAZMp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:45:58 -0500
Message-ID: <52E50371.2080104@compulab.co.il>
Date: Sun, 26 Jan 2014 14:45:37 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Curt Brune <curt@cumulusnetworks.com>, Wolfram Sang <wsa@the-dreams.de>,
        Laszlo Papp <lpapp@kde.org>
CC: Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Add at24 based EEPROMs to the eeprom_dev hardware
 class
References: <1390504562-20333-2-git-send-email-curt@cumulusnetworks.com>
In-Reply-To: <1390504562-20333-2-git-send-email-curt@cumulusnetworks.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Curt,

On 01/23/14 21:16, Curt Brune wrote:
> During device instantiation have the at24 driver add the new device to
> the eeprom_dev hardware class.  The functionality is enabled by
> CONFIG_EEPROM_CLASS.
> 
> Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
> ---
>  drivers/misc/eeprom/at24.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index d87f77f..07782ea 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -22,10 +22,14 @@
>  #include <linux/jiffies.h>
>  #include <linux/of.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_data/at24.h>
>  
> +#ifdef CONFIG_EEPROM_CLASS
> +#include <linux/eeprom_class.h>
> +#endif

I would recommend moving the "ifdeffery" into the eeprom_class.h
and leave the users (in this case the at24.c) clean.

> +
>  /*
>   * I2C EEPROMs from most vendors are inexpensive and mostly interchangeable.
>   * Differences between different vendor product lines (like Atmel AT24C or
>   * MicroChip 24LC, etc) won't much matter for typical read/write access.
>   * There are also I2C RAM chips, likewise interchangeable. One example
> @@ -66,10 +70,13 @@ struct at24_data {
>  
>  	u8 *writebuf;
>  	unsigned write_max;
>  	unsigned num_addresses;
>  
> +#ifdef CONFIG_EEPROM_CLASS
> +	struct device *eeprom_dev;
> +#endif

Same here, this is just a pointer, so I don't think anyone has
a problem having it even if eeprom class is not selected.

>  	/*
>  	 * Some chips tie up multiple I2C addresses; dummy devices reserve
>  	 * them for us, and we'll use them with SMBus calls.
>  	 */
>  	struct i2c_client *client[];
> @@ -619,10 +626,19 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  
>  	err = sysfs_create_bin_file(&client->dev.kobj, &at24->bin);
>  	if (err)
>  		goto err_clients;
>  
> +#ifdef CONFIG_EEPROM_CLASS
> +	at24->eeprom_dev = eeprom_device_register(&client->dev);
> +	if (IS_ERR(at24->eeprom_dev)) {
> +		dev_err(&client->dev, "error registering eeprom device.\n");
> +		err = PTR_ERR(at24->eeprom_dev);
> +		goto err_clients;
> +	}
> +#endif

stub the eeprom_device_register() out in eeprom_class.h
for !CONFIG_EEPROM_CLASS case

> +
>  	i2c_set_clientdata(client, at24);
>  
>  	dev_info(&client->dev, "%zu byte %s EEPROM, %s, %u bytes/write\n",
>  		at24->bin.size, client->name,
>  		writable ? "writable" : "read-only", at24->write_max);
> @@ -656,10 +672,14 @@ static int at24_remove(struct i2c_client *client)
>  	sysfs_remove_bin_file(&client->dev.kobj, &at24->bin);
>  
>  	for (i = 1; i < at24->num_addresses; i++)
>  		i2c_unregister_device(at24->client[i]);
>  
> +#ifdef CONFIG_EEPROM_CLASS
> +	eeprom_device_unregister(at24->eeprom_dev);
> +#endif

same here.

> +
>  	return 0;
>  }
>  
>  /*-------------------------------------------------------------------------*/
>  
> 

-- 
Regards,
Igor.
