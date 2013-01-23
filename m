Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3AWUWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:22:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3AWUWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:22:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Afzal Mohammed <afzal@ti.com>, <linux-fbdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
References: <cover.1358937685.git.afzal@ti.com>
 <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
Message-ID: <20130123202204.9205.66575@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider handling
Date: Wed, 23 Jan 2013 12:22:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Afzal Mohammed (2013-01-23 03:48:56)
<snip>
> +static inline void da8xx_fb_clkc_enable(void)
> +{
>         if (lcd_revision == LCD_VERSION_2)
>                 lcdc_write(LCD_V2_DMA_CLK_EN | LCD_V2_LIDD_CLK_EN |
>                                 LCD_V2_CORE_CLK_EN, LCD_CLK_ENABLE_REG);
>  }
>  
> -static inline void da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
> +#ifdef CONFIG_COMMON_CLK
> +static inline int da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
> +                                                   struct fb_videomode *mode)
> +{
> +       int ret;
> +
> +       ret = clk_set_rate(par->child_clk, PICOS2KHZ(mode->pixclock) * 1000);
> +       if (IS_ERR_VALUE(ret)) {
> +               dev_err(par->dev, "unable to setup pixel clock of %u ps",
> +                       mode->pixclock);
> +               return ret;
> +       }
> +       da8xx_fb_clkc_enable();

It looks like you are using the legacy method to enable/disable the
clock and using the CCF basic divider to set the rate.  This feels a bit
hacky to me.  If you want to model your clock in CCF then you should
probably model the whole clock, not just the rate-change aspects of it.

Have you looked at the composite clock patches from Prashant?  Those
might give you the divider+gate properties that you are looking for:
http://article.gmane.org/gmane.linux.kernel/1416697

Regards,
Mike
