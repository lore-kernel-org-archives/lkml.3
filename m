Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3JZQ3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 12:29:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52639 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3JZQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 12:29:10 -0400
Date: Sat, 26 Oct 2013 09:29:07 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] extcon: arizona: Fix reset of HPDET after race with
 removal
Message-ID: <20131026162907.GC7698@lee--X1>
References: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1382796618-19921-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382796618-19921-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013, Charles Keepax wrote:

> We need to make sure we reset back to our starting state, especially
> making sure that we have disabled poll in the register cache.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index 92eb486..3ce7b49 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -572,6 +572,14 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
>  		goto out;
>  	} else if (!ret) {
>  		dev_dbg(arizona->dev, "Ignoring HPDET for removed cable\n");
> +
> +		/* Reset back to starting range */
> +		regmap_update_bits(arizona->regmap,
> +				   ARIZONA_HEADPHONE_DETECT_1,
> +				   ARIZONA_HP_IMPEDANCE_RANGE_MASK |
> +				   ARIZONA_HP_POLL,
> +				   0);
> +
>  		goto done;
>  	}
>  
> @@ -607,9 +615,9 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
>  		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
>  			ret);
>  
> +done:
>  	arizona_extcon_do_magic(info, 0);
>  
> -done:
>  	if (id_gpio)
>  		gpio_set_value_cansleep(id_gpio, 0);
>  

What happens if we don't update the bits and we still do magic in the
new error path? Does that adversely affect any later 'goto done's?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
