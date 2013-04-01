Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3DAB0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 21:26:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:43008 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab3DAB02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 21:26:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,384,1363158000"; 
   d="scan'208";a="221113647"
Message-ID: <5158E28D.6040403@intel.com>
Date: Mon, 01 Apr 2013 09:27:41 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] ACPI / I2C: Use parent's ACPI_HANDLE() in acpi_i2c_register_devices()
References: <2966020.zlpeyGGUDW@vostro.rjw.lan>
In-Reply-To: <2966020.zlpeyGGUDW@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 08:25 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI handle of struct i2c_adapter's dev member should not be
> set, because this causes that struct i2c_adapter to be associated
> with the ACPI device node corresponding to its parent as the
> second "physical_device", which is incorrect (this happens during
> the registration of struct i2c_adapter).  Consequently,
> acpi_i2c_register_devices() should use the ACPI handle of the
> parent of the struct i2c_adapter it is called for rather than the
> struct i2c_adapter's ACPI handle (which should be NULL).
> 
> Make that happen and modify the i2c-designware-platdrv driver,
> which currently is the only driver for ACPI-enumerated I2C
> controller chips, not to set the ACPI handle for the
> struct i2c_adapter it creates.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> ---
>  drivers/acpi/acpi_i2c.c                     |    2 +-
>  drivers/i2c/busses/i2c-designware-platdrv.c |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/acpi/acpi_i2c.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/acpi_i2c.c
> +++ linux-pm/drivers/acpi/acpi_i2c.c
> @@ -90,7 +90,7 @@ void acpi_i2c_register_devices(struct i2
>  	acpi_handle handle;
>  	acpi_status status;
>  
> -	handle = ACPI_HANDLE(&adapter->dev);
> +	handle = ACPI_HANDLE(adapter->dev.parent);
>  	if (!handle)
>  		return;
>  
> Index: linux-pm/drivers/i2c/busses/i2c-designware-platdrv.c
> ===================================================================
> --- linux-pm.orig/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ linux-pm/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -182,7 +182,6 @@ static int dw_i2c_probe(struct platform_
>  	adap->algo = &i2c_dw_algo;
>  	adap->dev.parent = &pdev->dev;
>  	adap->dev.of_node = pdev->dev.of_node;
> -	ACPI_HANDLE_SET(&adap->dev, ACPI_HANDLE(&pdev->dev));
>  
>  	r = i2c_add_numbered_adapter(adap);
>  	if (r) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

