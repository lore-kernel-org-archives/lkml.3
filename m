Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaJBPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:25:28 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57533 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaJBPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:25:27 -0400
Message-ID: <542D6E5A.1060601@gmail.com>
Date: Thu, 02 Oct 2014 18:25:14 +0300
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@linuxfoundation.org, micky_ching@realsil.com.cn,
        fabio.falzoi84@gmail.com, mahati.chamarthy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rts5208: Clean up coding style in rtsx_chip.c
 to get rid of checkpatch.pl warnings and combine two ifs into one
References: <542D336A.1050401@gmail.com> <1412250349.3247.44.camel@joe-AO725>
In-Reply-To: <1412250349.3247.44.camel@joe-AO725>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.10.02 14:45, Joe Perches wrote:
> On Thu, 2014-10-02 at 14:13 +0300, Giedrius Statkevicius wrote:
>> Fix 10 occurences of coding style errors where the line exceeds 80 characters by breaking them into more lines.
>> Checkpatch.pl reports these errors as: 'WARNING: line over 80 characters'
>> Also, removes unnecessary returns in two void functions by removing the return statements.
>> Checkpatch.pl reports these errors as: 'WARNING: void function return statements are not generally useful'
>> Lastly it combines two if statements into one in rtsx_reset_chip()
> 
> Another way to reduce indentation is to write another
> utility function like the suggested patch at the end
> of this email.
> 
> Also, changing:
> 
> 	if (foo) {
> 		[short code block...]
> 	} else
> 		[long code block...]
> 	}
> 
> 	return bar;
> to:
> 	if (foo) {
> 		[short code block...]
> 		return bar;
> 	}
> 
> 	[long code block...]
> 	return bar;
> 
> reduces indentation.
> 
> Al Viro once gave good advice about indentation here:
> https://lkml.org/lkml/2013/3/20/345
> 
> Using ternaries can also reduce line count and
> indentation:
> 	if (something)
> 		foo(bar, 1, ...);
> 	else
> 		foo(bar, 2, ...);
> can be written
> 	foo(bar, something ? 1 : 2, ...)
First of all, the purpose of this trivial patch is to clean the simple, obvious coding style mistakes reported by checkpatch.pl to get my feet wet as I am a kernel newbie.
Obviously, if we take a look at the code more closely there are many problems including the ones you've mentioned.
For example, in rts5208_init() in atleast in 6 places we can use ternaries. This is one of them:

	if (val & 0x01)
		chip->hw_bypass_sd = 1;
	else
		chip->hw_bypass_sd = 0; 

A lot of places where we can combine if's. In rtsx_disable_aspm():

	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
		if (chip->aspm_enabled) {

So I guess I should make a way bigger patch that cleans more of the coding style mistakes if no one wants to take this patch?
To be honest, I would like these to be two seperate patches as they do different things and not just a big one that does both things as I may not be able to do that sucessfully.

thanks,
Giedrius 
> 
> Here's a suggestion:
> ---
>  drivers/staging/rts5208/rtsx_chip.c | 71 ++++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
> index 1411471..85d670d 100644
> --- a/drivers/staging/rts5208/rtsx_chip.c
> +++ b/drivers/staging/rts5208/rtsx_chip.c
> @@ -226,6 +226,43 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
>  }
>  #endif
>  
> +static int rtsx_reset_aspm(struct rtsx_chip *chip)
> +{
> +	int rtn = STATUS_SUCCESS;
> +
> +	if (chip->dynamic_aspm) {
> +		if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
> +			rtn = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
> +						chip->aspm_l0s_l1_en);
> +			if (rtn != STATUS_SUCCESS)
> +				TRACE_RET(chip, STATUS_FAIL);
> +		}
> +		return rtn;
> +	}
> +
> +	if (CHECK_PID(chip, 0x5208))
> +		RTSX_WRITE_REG(chip, ASPM_FORCE_CTL, 0xFF, 0x3F);
> +
> +	rtn = rtsx_write_config_byte(chip, LCTLR, chip->aspm_l0s_l1_en);
> +	if (rtn != STATUS_SUCCESS)
> +		TRACE_RET(chip, STATUS_FAIL);
> +
> +	chip->aspm_level[0] = chip->aspm_l0s_l1_en;
> +
> +	if (CHK_SDIO_EXIST(chip)) {
> +		chip->aspm_level[1] = chip->aspm_l0s_l1_en;
> +		rtn = rtsx_write_cfg_dw(chip,
> +					CHECK_PID(chip, 0x5288) ? 2 : 1,
> +					0xC0, 0xFF, chip->aspm_l0s_l1_en);
> +		if (rtn != STATUS_SUCCESS)
> +			TRACE_RET(chip, STATUS_FAIL);
> +	}
> +
> +	chip->aspm_enabled = 1;
> +
> +	return rtn;
> +}
> +
>  int rtsx_reset_chip(struct rtsx_chip *chip)
>  {
>  	int retval;
> @@ -288,39 +325,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
>  
>  	/* Enable ASPM */
>  	if (chip->aspm_l0s_l1_en) {
> -		if (chip->dynamic_aspm) {
> -			if (CHK_SDIO_EXIST(chip)) {
> -				if (CHECK_PID(chip, 0x5288)) {
> -					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
> -					if (retval != STATUS_SUCCESS)
> -						TRACE_RET(chip, STATUS_FAIL);
> -				}
> -			}
> -		} else {
> -			if (CHECK_PID(chip, 0x5208))
> -				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
> -					0xFF, 0x3F);
> -
> -			retval = rtsx_write_config_byte(chip, LCTLR,
> -							chip->aspm_l0s_l1_en);
> -			if (retval != STATUS_SUCCESS)
> -				TRACE_RET(chip, STATUS_FAIL);
> -
> -			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
> -			if (CHK_SDIO_EXIST(chip)) {
> -				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
> -				if (CHECK_PID(chip, 0x5288))
> -					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
> -				else
> -					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
> -
> -				if (retval != STATUS_SUCCESS)
> -					TRACE_RET(chip, STATUS_FAIL);
> -
> -			}
> -
> -			chip->aspm_enabled = 1;
> -		}
> +		retval = rtsx_reset_aspm(chip);
>  	} else {
>  		if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
>  			retval = rtsx_write_phy_register(chip, 0x07, 0x0129);
> 
> 
