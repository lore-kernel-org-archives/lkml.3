Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaFKJYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:24:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:25521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaFKJYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,457,1400050800"; 
   d="scan'208";a="555625330"
Date: Wed, 11 Jun 2014 12:24:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Benson Leung <bleung@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] platform/chrome: Probe multiple i2c adapters of
 the same name
Message-ID: <20140611092309.GC1657@lahna.fi.intel.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com>
 <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com>
 <20140604083726.GN1730@lahna.fi.intel.com>
 <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
 <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
 <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com>
 <20140609124700.GJ1657@lahna.fi.intel.com>
 <alpine.DEB.2.02.1406092332410.8274@scotdoyle.com>
 <alpine.DEB.2.02.1406100610220.8274@scotdoyle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406100610220.8274@scotdoyle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 06:17:35AM +0100, Scot Doyle wrote:
> The chromeos_laptop module probes the first i2c adapter with a specific name
> for expected hardware. However, the Acer C720 Chromebook has two i2c
> adapters with the same name. This patch probes each i2c adapter with a
> specific name in turn, until locating the expected hardware.
> 
> Thanks to Mika Westerberg for identifying the need for unique bus addresses
> within each set of identically-named adapters.
> 
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> CC: Benson Leung <bleung@chromium.org>
> CC: Mika Westerberg <mika.westerberg@linux.intel.com>

Few comments about style:

> ---
> diff --git a/drivers/platform/chrome/chromeos_laptop.c
> b/drivers/platform/chrome/chromeos_laptop.c
> index 7f3aad0..8382315 100644
> --- a/drivers/platform/chrome/chromeos_laptop.c
> +++ b/drivers/platform/chrome/chromeos_laptop.c
> @@ -29,6 +29,8 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> 
> +/* Note: Bus addresses must be unique within each set of identically-named
> +	 adapters on a board, otherwise device probing may fail. */

Check Documentation/CodingStyle about format of block comments.

>  #define ATMEL_TP_I2C_ADDR	0x4b
>  #define ATMEL_TP_I2C_BL_ADDR	0x25
>  #define ATMEL_TS_I2C_ADDR	0x4a
> @@ -173,7 +175,7 @@ static struct i2c_client *__add_probed_i2c_device(
>  	/* add the i2c device */
>  	client = i2c_new_probed_device(adapter, info, addrs, NULL);
>  	if (!client)
> -		pr_err("%s failed to register device %d-%02x\n",
> +		pr_debug("%s did not add i2c device %d-%02x\n",
>  		       __func__, bus, info->addr);
>  	else
>  		pr_debug("%s added i2c device %d-%02x\n",
> @@ -194,13 +196,14 @@ static int __find_i2c_adap(struct device *dev, void *data)
>  	return (strncmp(adapter->name, name, strlen(name)) == 0);
>  }
> 
> -static int find_i2c_adapter_num(enum i2c_adapter_type type)
> +static int find_i2c_next_adapter_num(enum i2c_adapter_type type,
> +				     struct device *start)
>  {
>  	struct device *dev = NULL;
>  	struct i2c_adapter *adapter;
>  	const char *name = i2c_adapter_names[type];
> -	/* find the adapter by name */
> -	dev = bus_find_device(&i2c_bus_type, NULL, (void *)name,
> +	/* find the next adapter by name */
> +	dev = bus_find_device(&i2c_bus_type, start, (void *)name,
>  			      __find_i2c_adap);
>  	if (!dev) {
>  		/* Adapters may appear later. Deferred probing will retry */
> @@ -226,10 +229,17 @@ static struct i2c_client *add_probed_i2c_device(
>  		struct i2c_board_info *info,
>  		const unsigned short *addrs)
>  {
> -	return __add_probed_i2c_device(name,
> -				       find_i2c_adapter_num(type),
> -				       info,
> -				       addrs);
> +	struct i2c_client *client = NULL;
> +	struct device *start = NULL;
> +	int adapter_num = 0;

Please add blank line here.

> +	while (!client && adapter_num > -1) {
> +		adapter_num = find_i2c_next_adapter_num(type, start);
> +		client = __add_probed_i2c_device(name,
> +						 adapter_num,
> +						 info,
> +						 addrs);

Don't the above fit into one line, specifically if you call adapter_num
just num or something like that.

> +	}
> +	return client;
>  }
> 
>  /*
> @@ -242,10 +252,10 @@ static struct i2c_client *add_i2c_device(const char *name,
>  						struct i2c_board_info *info)
>  {
>  	const unsigned short addr_list[] = { info->addr, I2C_CLIENT_END };
> -	return __add_probed_i2c_device(name,
> -				       find_i2c_adapter_num(type),
> -				       info,
> -				       addr_list);
> +	return add_probed_i2c_device(name,
> +				     type,
> +				     info,
> +				     addr_list);

Same here.

>  }
> 
>  static int setup_cyapa_tp(enum i2c_adapter_type type)
