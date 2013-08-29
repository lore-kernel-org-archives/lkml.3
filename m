Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3H2Hp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:45:56 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44787 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3H2Hpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
References: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
Date: Thu, 29 Aug 2013 09:45:54 +0200
Message-ID: <CACRpkdbHtjvY_VypnCQZNU2N1YqWtUv_grTK30A+tgEP3a0uwQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sherman Yin <syin@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 9:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I made a bit different fix, I just lock the spinlock around the entire
loop, as this is not doing any delays or anything like that and
just hammer a few registers with the settings, it makes sense to
have that inside a single lock:

--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@@ -282,48 -282,57 +283,51 @@@ static int sunxi_pconf_group_set(struc
        u32 val, mask;
        u16 strength;
        u8 dlevel;
 +      int i;

 -      switch (pinconf_to_config_param(config)) {
 -      case PIN_CONFIG_DRIVE_STRENGTH:
 -              strength = pinconf_to_config_argument(config);
 -              if (strength > 40)
 -                      return -EINVAL;
 -              /*
 -               * We convert from mA to what the register expects:
 -               *   0: 10mA
 -               *   1: 20mA
 -               *   2: 30mA
 -               *   3: 40mA
 -               */
 -              dlevel = strength / 10 - 1;
 -
 -              spin_lock_irqsave(&pctl->lock, flags);
 -
 -              val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
 -              mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
 -              writel((val & ~mask) | dlevel << sunxi_dlevel_offset(g->pin),
 -                      pctl->membase + sunxi_dlevel_reg(g->pin));
 -
 -              spin_unlock_irqrestore(&pctl->lock, flags);
 -              break;
 -      case PIN_CONFIG_BIAS_PULL_UP:
 -              spin_lock_irqsave(&pctl->lock, flags);
 -
 -              val = readl(pctl->membase + sunxi_pull_reg(g->pin));
 -              mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
 -              writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
 -                      pctl->membase + sunxi_pull_reg(g->pin));
 -
 -              spin_unlock_irqrestore(&pctl->lock, flags);
 -              break;
 -      case PIN_CONFIG_BIAS_PULL_DOWN:
 -              spin_lock_irqsave(&pctl->lock, flags);
 -
 -              val = readl(pctl->membase + sunxi_pull_reg(g->pin));
 -              mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
 -              writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
 -                      pctl->membase + sunxi_pull_reg(g->pin));
++      spin_lock_irqsave(&pctl->lock, flags);
+
 -              spin_unlock_irqrestore(&pctl->lock, flags);
 -              break;
 -      default:
 -              break;
 -      }
 +      for (i = 0; i < num_configs; i++) {
 +              switch (pinconf_to_config_param(configs[i])) {
 +              case PIN_CONFIG_DRIVE_STRENGTH:
 +                      strength = pinconf_to_config_argument(configs[i]);
 +                      if (strength > 40)
 +                              return -EINVAL;
 +                      /*
 +                       * We convert from mA to what the register expects:
 +                       *   0: 10mA
 +                       *   1: 20mA
 +                       *   2: 30mA
 +                       *   3: 40mA
 +                       */
 +                      dlevel = strength / 10 - 1;
 +                      val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
 +                      mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
 +                      writel((val & ~mask)
 +                              | dlevel << sunxi_dlevel_offset(g->pin),
 +                              pctl->membase + sunxi_dlevel_reg(g->pin));
 +                      break;
 +              case PIN_CONFIG_BIAS_PULL_UP:
 +                      val = readl(pctl->membase + sunxi_pull_reg(g->pin));
 +                      mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
 +                      writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
 +                              pctl->membase + sunxi_pull_reg(g->pin));
 +                      break;
+              case PIN_CONFIG_BIAS_PULL_DOWN:
 +                      val = readl(pctl->membase + sunxi_pull_reg(g->pin));
 +                      mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
 +                      writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
 +                              pctl->membase + sunxi_pull_reg(g->pin));
 +                      break;
 +              default:
 +                      break;
 +              }
-
 +              /* cache the config value */
 +              g->config = configs[i];
 +      } /* for each config */

 -      /* cache the config value */
 -      g->config = config;
++      spin_unlock_irqrestore(&pctl->lock, flags);
+
        return 0;
  }


Yours,
Linus Walleij
