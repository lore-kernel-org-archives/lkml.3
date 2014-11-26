Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaKZGdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:33:04 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65030 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZGdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:33:01 -0500
Date: Tue, 25 Nov 2014 22:32:56 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rob Ward <robert.ward114@googlemail.com>
Cc: joern@lazybastard.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: phram: Allow multiple phram devices on cmd line
Message-ID: <20141126063256.GH3212@norris-Latitude-E6410>
References: <alpine.DEB.2.10.1410211859030.7838@rob-thinkpad>
 <alpine.DEB.2.10.1411091618160.7838@rob-thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411091618160.7838@rob-thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 04:24:44PM +0000, Rob Ward wrote:
> From 4e9b8ff3a6731a0ac43eac2e8bdf47101ff20ede Mon Sep 17 00:00:00 2001
> From: Rob Ward <robert.ward114@googlemail.com>
> Date: Tue, 21 Oct 2014 17:46:53 +0100
> Subject: [PATCH] mtd: phram: Allow multiple phram devices on cmd line
> 
> Allow the phram module the ability to create multiple phram mtd
> devices via the kernel command line.

Is the sysfs module parameter option not sufficient?

  /sys/module/phram/parameters/phram

It looks like it should be reusable for multiple device creations.

Notably, we use 000 permissions for module_param_call(), so the
parameter doesn't even show up by default AFAICT. I had to hack it to
0600 or similar.

> Currently the phram module only allows a single mtd device to be
> created via the kernel command line. This is due to the phram
> module having to store the values until it is initialised
> later. This storage is done using a single char[] meaning when
> the module_param_call is made the previous value is overidden.
> 
> This change modifies the phram system to use a char[][] allowing
> multiple devices to be created.
> 
> The array size if controlled using the new config option
> CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS that allows the maximum
> number of devices to be specified. Currently this option
> defaults to a value of 1 leaving the behaviour unchanged.
> 
> If the array is full a message is printed to the console and the
> module_param_call returns.
> 
> To test, in all cases an area of memory needs to be reserved via
> the command line e.g. memmap=10M$114M
> 
> To test with phram build into the kernel on the command line add
> the following:
> 
> phram.phram=alpha,114Mi,1Mi phram.phram=beta,115Mi,1Mi
> 
> If CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS is left as default i.e. 1
> then the first device, alpha will be created only. If the value of
> CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS is increased to 2 or more then
> both alpha and beta will be created.

I really don't think we want this to be a Kconfig option. We can
dynamically allocate and use a linked list instead, which would be more
flexible and avoid making a fixed compile-time choice.

> To test phram built as a module insmod with the following arguments:
> 
> phram=gamma,114Mi,1Mi phram=delta,115Mi,1Mi
> 
> In this case two devices should be created.
> 
> Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
> ---
>  drivers/mtd/devices/Kconfig | 12 ++++++++++++
>  drivers/mtd/devices/phram.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index c49d0b1..5fdc80b 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -136,6 +136,18 @@ config MTD_PHRAM
>  	  doesn't have access to, memory beyond the mem=xxx limit, nvram,
>  	  memory on the video card, etc...
>  
> +config MTD_PHRAM_MAX_CMDLINE_ARGS
> +	int "Max number of devices via Kernel command line"
> +	depends on MTD_PHRAM=y
> +	default 1
> +	help
> +	  Specify the number of phram devices that can be initialised
> +	  using the Kernel command line.
> +
> +	  This option is only applicable when phram is built into the
> +	  Kernel. When built as a module many devices can be specified
> +	  at module insmod.
> +
>  config MTD_LART
>  	tristate "28F160xx flash driver for LART"
>  	depends on SA1100_LART
> diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
> index effd9a4..223f221 100644
> --- a/drivers/mtd/devices/phram.c
> +++ b/drivers/mtd/devices/phram.c
> @@ -212,9 +212,13 @@ static int phram_init_called;
>   * - phram.phram=<device>,<address>,<size> for built-in case
>   * We leave 64 bytes for the device name, 20 for the address and 20 for the
>   * size.
> + *
> + * The maximum number of devices supported is controlled by the
> + * MTD_PHRAM_MAX_CMDLINE_ARGS config option
> + *
>   * Example: phram.phram=rootfs,0xa0000000,512Mi
>   */
> -static char phram_paramline[64 + 20 + 20];
> +static char phram_paramline[CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS][64 + 20 + 20];
>  #endif
>  
>  static int phram_setup(const char *val)
> @@ -271,6 +275,9 @@ static int phram_param_call(const char *val, struct kernel_param *kp)
>  #ifdef MODULE
>  	return phram_setup(val);
>  #else
> +	int paramline_it = 0;
> +	int arraysize = 0;

Neither of these need to be initialized here. And can you shorten the
long-ish names? We don't need an "iterator" -- it's just and index 'i'.

> +
>  	/*
>  	 * If more parameters are later passed in via
>  	 * /sys/module/phram/parameters/phram
> @@ -290,9 +297,27 @@ static int phram_param_call(const char *val, struct kernel_param *kp)
>  	 * phram_setup().
>  	 */
>  
> -	if (strlen(val) >= sizeof(phram_paramline))
> +	if (strlen(val) >= sizeof(phram_paramline[0]))
>  		return -ENOSPC;
> -	strcpy(phram_paramline, val);
> +
> +	arraysize = sizeof(phram_paramline)/sizeof(phram_paramline[0]);

Coccinelle complains:

drivers/mtd/devices/phram.c:303:35-36: WARNING: Use ARRAY_SIZE

> +
> +	/*
> +	 * Check if any space is left in the array. If no space
> +	 * is left then print warning and return 0
> +	 */
> +
> +	if (phram_paramline[arraysize - 1][0]) {
> +		pr_warn("exceeded limit via cmd_line - %s ignored", val);
> +		return 0;
> +	}
> +
> +	for (paramline_it = 0; paramline_it <= arraysize; paramline_it++) {

Use '<' not '<='. You're overflowing the array.

> +		if (!phram_paramline[paramline_it][0]) {
> +			strcpy(phram_paramline[paramline_it], val);
> +			break;
> +		}
> +	}
>  
>  	return 0;
>  #endif
> @@ -307,8 +332,18 @@ static int __init init_phram(void)
>  	int ret = 0;
>  
>  #ifndef MODULE
> -	if (phram_paramline[0])
> -		ret = phram_setup(phram_paramline);
> +	int arraysize = 0;
> +	int paramline_it = 0;

Same comments as above. Neither of these need to be initialized here,
and shorten the name.

> +
> +	arraysize = sizeof(phram_paramline)/sizeof(phram_paramline[0]);

drivers/mtd/devices/phram.c:338:35-36: WARNING: Use ARRAY_SIZE

> +
> +	for (paramline_it = 0; paramline_it <= arraysize; paramline_it++) {

You're off-by-one; use '<', not '<='. So this line could just be:

	for (i = 0; i < ARRAY_SIZE(phram_paramline); i++) {

(But then, we can avoid this by just allocating and appending to a
linked list.)

> +		if (phram_paramline[paramline_it][0]) {
> +			ret = phram_setup(phram_paramline[paramline_it]);
> +			if (ret)
> +				break;
> +		}
> +	}
>  	phram_init_called = 1;
>  #endif
>  

Brian
