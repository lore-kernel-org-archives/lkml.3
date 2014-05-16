Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaEPM0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:26:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:63920 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbaEPM0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1067,1389772800"; 
   d="scan'208";a="533014637"
Message-ID: <537606A1.9080507@linux.intel.com>
Date: Fri, 16 May 2014 15:37:53 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Sundar Iyer <sundar.iyer@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Add pull type, strength and open drain
 to debugfs output
References: <1400231909-7662-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1400231909-7662-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:18 PM, Mika Westerberg wrote:
> In case of resolving power management or similar issues it might be useful
> to have these properties included in the debugfs output.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks good to me

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>

-Mathias



> ---
>  drivers/pinctrl/pinctrl-baytrail.c | 55 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index 7c65c9dab215..975572e2f260 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -43,9 +43,20 @@
>  #define BYT_INT_STAT_REG	0x800
>  
>  /* BYT_CONF0_REG register bits */
> +#define BYT_IODEN		BIT(31)
>  #define BYT_TRIG_NEG		BIT(26)
>  #define BYT_TRIG_POS		BIT(25)
>  #define BYT_TRIG_LVL		BIT(24)
> +#define BYT_PULL_STR_SHIFT	9
> +#define BYT_PULL_STR_MASK	(3 << BYT_PULL_STR_SHIFT)
> +#define BYT_PULL_STR_2K		(0 << BYT_PULL_STR_SHIFT)
> +#define BYT_PULL_STR_10K	(1 << BYT_PULL_STR_SHIFT)
> +#define BYT_PULL_STR_20K	(2 << BYT_PULL_STR_SHIFT)
> +#define BYT_PULL_STR_40K	(3 << BYT_PULL_STR_SHIFT)
> +#define BYT_PULL_ASSIGN_SHIFT	7
> +#define BYT_PULL_ASSIGN_MASK	(3 << BYT_PULL_ASSIGN_SHIFT)
> +#define BYT_PULL_ASSIGN_UP	(1 << BYT_PULL_ASSIGN_SHIFT)
> +#define BYT_PULL_ASSIGN_DOWN	(2 << BYT_PULL_ASSIGN_SHIFT)
>  #define BYT_PIN_MUX		0x07
>  
>  /* BYT_VAL_REG register bits */
> @@ -321,6 +332,8 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  	spin_lock_irqsave(&vg->lock, flags);
>  
>  	for (i = 0; i < vg->chip.ngpio; i++) {
> +		const char *pull_str = NULL;
> +		const char *pull = NULL;
>  		const char *label;
>  		offs = vg->range->pins[i] * 16;
>  		conf0 = readl(vg->reg_base + offs + BYT_CONF0_REG);
> @@ -330,8 +343,32 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  		if (!label)
>  			label = "Unrequested";
>  
> +		switch (conf0 & BYT_PULL_ASSIGN_MASK) {
> +		case BYT_PULL_ASSIGN_UP:
> +			pull = "up";
> +			break;
> +		case BYT_PULL_ASSIGN_DOWN:
> +			pull = "down";
> +			break;
> +		}
> +
> +		switch (conf0 & BYT_PULL_STR_MASK) {
> +		case BYT_PULL_STR_2K:
> +			pull_str = "2k";
> +			break;
> +		case BYT_PULL_STR_10K:
> +			pull_str = "10k";
> +			break;
> +		case BYT_PULL_STR_20K:
> +			pull_str = "20k";
> +			break;
> +		case BYT_PULL_STR_40K:
> +			pull_str = "40k";
> +			break;
> +		}
> +
>  		seq_printf(s,
> -			   " gpio-%-3d (%-20.20s) %s %s %s pad-%-3d offset:0x%03x mux:%d %s%s%s\n",
> +			   " gpio-%-3d (%-20.20s) %s %s %s pad-%-3d offset:0x%03x mux:%d %s%s%s",
>  			   i,
>  			   label,
>  			   val & BYT_INPUT_EN ? "  " : "in",
> @@ -339,9 +376,19 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  			   val & BYT_LEVEL ? "hi" : "lo",
>  			   vg->range->pins[i], offs,
>  			   conf0 & 0x7,
> -			   conf0 & BYT_TRIG_NEG ? " fall" : "",
> -			   conf0 & BYT_TRIG_POS ? " rise" : "",
> -			   conf0 & BYT_TRIG_LVL ? " level" : "");
> +			   conf0 & BYT_TRIG_NEG ? " fall" : "     ",
> +			   conf0 & BYT_TRIG_POS ? " rise" : "     ",
> +			   conf0 & BYT_TRIG_LVL ? " level" : "      ");
> +
> +		if (pull && pull_str)
> +			seq_printf(s, " %-4s %-3s", pull, pull_str);
> +		else
> +			seq_puts(s, "          ");
> +
> +		if (conf0 & BYT_IODEN)
> +			seq_puts(s, " open-drain");
> +
> +		seq_puts(s, "\n");
>  	}
>  	spin_unlock_irqrestore(&vg->lock, flags);
>  }
> 

