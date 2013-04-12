Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3DLUB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:01:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:39347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3DLUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:01:55 -0400
Message-ID: <5168681A.20405@infradead.org>
Date: Fri, 12 Apr 2013 13:01:30 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Andrew Jones <drjones@redhat.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
References: <201304121318.r3CDILZS013210@latitude>
In-Reply-To: <201304121318.r3CDILZS013210@latitude>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/13 06:05, Anthony Olech wrote:
> This is the ONKEY component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE component driver of the DA9058 MFD.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---
>  drivers/input/misc/Kconfig        |   10 +++
>  drivers/input/misc/Makefile       |    1 +
>  drivers/input/misc/da9058_onkey.c |  177 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 188 insertions(+)
>  create mode 100644 drivers/input/misc/da9058_onkey.c
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 259ef31..bd07b38 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -93,6 +93,16 @@ config INPUT_BMA150
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bma150.
>  
> +config INPUT_DA9058_ONKEY
> +	tristate "DA9058 ONKEY support"
> +	depends on MFD_DA9058
> +	help
> +	  Support the ONKEY of DA9058 PMICs as an input device
> +	  reporting power button status.

What possible values can a power button status have?
Must be more than my KISS guess:
	this software is running => ON
	software not running     => OFF
eh?

> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called da9058_onkey.
> +
>  config INPUT_PCSPKR
>  	tristate "PC Speaker support"
>  	depends on PCSPKR_PLATFORM
> diff --git a/drivers/input/misc/da9058_onkey.c b/drivers/input/misc/da9058_onkey.c
> new file mode 100644
> index 0000000..969ad70
> --- /dev/null
> +++ b/drivers/input/misc/da9058_onkey.c
> @@ -0,0 +1,177 @@
> +/*
> + *  Copyright (C) 2012 Dialog Semiconductor Ltd.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +
> +static int da9058_onkey_probe(struct platform_device *pdev)
> +{
> +	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct da9058_onkey_pdata *onkey_pdata;
> +	struct da9058_onkey *onkey;
> +	int ret;
> +
> +	if (cell == NULL) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	onkey_pdata = cell->platform_data;
> +
> +	if (onkey_pdata == NULL) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	dev_info(&pdev->dev, "Starting ONKEY\n");
> +
> +	onkey = devm_kzalloc(&pdev->dev, sizeof(struct da9058_onkey),
> +				GFP_KERNEL);
> +	if (!onkey) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	platform_set_drvdata(pdev, onkey);
> +
> +	onkey->da9058 = da9058;
> +	onkey->pdev = pdev;
> +
> +	onkey->irq = platform_get_irq(pdev, 0);
> +	if (onkey->irq < 0) {
> +		dev_err(&pdev->dev, "can not get ONKEY IRQ error=%d\n",

		                     cannot

> +				onkey->irq);


-- 
~Randy
