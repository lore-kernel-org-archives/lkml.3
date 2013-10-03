Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3JCNkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:40:03 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51177 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3JCNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:39:59 -0400
Date: Thu, 3 Oct 2013 14:39:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: arizona: Correct handling of device tree gpio
 defaults
Message-ID: <20131003133954.GR9048@lee--X1>
References: <1380803404-2764-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380803404-2764-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct 2013, Charles Keepax wrote:

> When settings the gpio defaults from data contained in device tree
> all values that fit in 16-bits should be treated literally, any
> value greater than 16-bits should cause the chips default to be used
> for that gpio pin. A zero value in the gpio default array in pdata
> represents that we should leave the default set.
> 
> The current code will write zero to the gpio config for all values
> greater than 16-bits. Note that this is setting the gpio default to
> 0x10000, as only the bottom 16-bits will be written to the device, and
> zero is treated as don't write anything use chip defaults.
> 
> This patch ensure that we handle the gpio default as either an out of
> range value or a zero value rather than both one after the other.

This still doesn't clarify things for me. How about:

  When setting GPIO defaults we are required to make a distinction
  between writing 0x0000 to the registers and leaving them untouched.

  When we receive between 0x0000 and 0xFFFF (inclusive) from either
  Platform Data or Device Tree, we should write the provided
  configuration to the device. Conversely, when we receive >0xFFFF we
  should leave the device configuration at its default setting.

  This patch fixes a bug and ensures that configuration 0x0000 isn't
  mistakenly written when the intention was to keep the default one.

> Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> Hi,
> 
> Added a bit more explanation I hope this is a little clearer.
> 
> Thanks,
> Charles
> 
>  drivers/mfd/arizona-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 5ac3aa4..e13355b 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -540,7 +540,7 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
>  			if (arizona->pdata.gpio_defaults[i] > 0xffff)
>  				arizona->pdata.gpio_defaults[i] = 0;
> -			if (arizona->pdata.gpio_defaults[i] == 0)
> +			else if (arizona->pdata.gpio_defaults[i] == 0)
>  				arizona->pdata.gpio_defaults[i] = 0x10000;
>  		}
>  	} else {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
