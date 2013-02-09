Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab3BIFux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 00:50:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55941 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3BIFuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 00:50:52 -0500
Message-ID: <5115E3B9.6090100@ti.com>
Date: Sat, 9 Feb 2013 06:50:49 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v2 09/11] mfd: twl-core: Collect global variables behind
 one private structure (global)
References: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com> <1358344439-23017-10-git-send-email-peter.ujfalusi@ti.com> <51154A7A.2010709@ti.com>
In-Reply-To: <51154A7A.2010709@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 07:56 PM, Jon Hunter wrote:
>>  /**
>>   * twl_i2c_write - Writes a n bit register in TWL4030/TWL5030/TWL60X0
>>   * @mod_no: module number
>> @@ -322,16 +323,17 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>>  		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>>  		return -EPERM;
>>  	}
>> -	if (unlikely(!inuse)) {
>> +	if (unlikely(!twl_priv->ready)) {
> 
> This is causing the kernel to panic on all my omap2 boards when booting linux-next
> because twl_priv is not initialised yet.

Good catch.
I just wonder from where the twl_* call is coming on OMAP2. AFAIK the twl code
is for OMAP3/4, for OMAP2 Menelaus is the one which is used.
I'm currently working on to remove all those twl_* calls from random places in
the kernel so we will only access twl via the MFD stack.

> 
>>  		pr_err("%s: not initialized\n", DRIVER_NAME);
>>  		return -EPERM;
>>  	}
>>  
>> -	sid = twl_map[mod_no].sid;
>> -	twl = &twl_modules[sid];
>> +	sid = twl_priv->twl_map[mod_no].sid;
>> +	twl = &twl_priv->twl_modules[sid];
>>  
>> -	ret = regmap_bulk_write(twl->regmap, twl_map[mod_no].base + reg,
>> -				value, num_bytes);
>> +	ret = regmap_bulk_write(twl->regmap,
>> +				twl_priv->twl_map[mod_no].base + reg, value,
>> +				num_bytes);
>>  
>>  	if (ret)
>>  		pr_err("%s: Write failed (mod %d, reg 0x%02x count %d)\n",
>> @@ -360,16 +362,17 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>>  		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>>  		return -EPERM;
>>  	}
>> -	if (unlikely(!inuse)) {
>> +	if (unlikely(!twl_priv->ready)) {
> 
> Same problem here. 
> 
> Here is a fix ...
> 
> From 141fcbbdee6bdc14d5a444ff20fad6b3440215dc Mon Sep 17 00:00:00 2001
> From: Jon Hunter <jon-hunter@ti.com>
> Date: Fri, 8 Feb 2013 12:42:20 -0600
> Subject: [PATCH] ARM: OMAP2+: Fix kernel panic on boot
> 
> Commit 8a6aaa3 (mfd: twl-core: Collect global variables behind one
> private structure (global)) removed the variable "inuse" that is used
> to determine if the device has been initialised and now use the
> twl_priv structure instead. This is causing the kernel to panic on all
> OMAP2+ devices, because we try to access the twl_priv->ready member
> before checking if twl_priv is initialised. Fix this and move this test
> to the beginning of the twl_i2c_read/write function because
> twl_get_last_module() also uses the twl_priv structure.
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/mfd/twl-core.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 557f9ee..89ab4d9 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -316,12 +316,12 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  	int sid;
>  	struct twl_client *twl;
>  
> -	if (unlikely(mod_no >= twl_get_last_module())) {
> -		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
> +	if (unlikely(!twl_priv || !twl_priv->ready)) {
> +		pr_err("%s: not initialized\n", DRIVER_NAME);
>  		return -EPERM;
>  	}
> -	if (unlikely(!twl_priv->ready)) {
> -		pr_err("%s: not initialized\n", DRIVER_NAME);
> +	if (unlikely(mod_no >= twl_get_last_module())) {
> +		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>  		return -EPERM;
>  	}
>  
> @@ -355,12 +355,12 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  	int sid;
>  	struct twl_client *twl;
>  
> -	if (unlikely(mod_no >= twl_get_last_module())) {
> -		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
> +	if (unlikely(!twl_priv || !twl_priv->ready)) {
> +		pr_err("%s: not initialized\n", DRIVER_NAME);
>  		return -EPERM;
>  	}
> -	if (unlikely(!twl_priv->ready)) {
> -		pr_err("%s: not initialized\n", DRIVER_NAME);
> +	if (unlikely(mod_no >= twl_get_last_module())) {
> +		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>  		return -EPERM;
>  	}
>  
> 


-- 
Péter
