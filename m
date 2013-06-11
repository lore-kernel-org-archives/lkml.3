Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3FKTYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:24:07 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45768 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3FKTYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:24:05 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 1/7] clk: divider: add flag to limit possible dividers to even numbers
Date: Tue, 11 Jun 2013 21:23:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <201306111328.52679.heiko@sntech.de> <201306111329.32749.heiko@sntech.de> <20130611185750.8816.82691@quantum>
In-Reply-To: <20130611185750.8816.82691@quantum>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306112123.51843.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 11. Juni 2013, 20:57:50 schrieb Mike Turquette:
> Quoting Heiko Stübner (2013-06-11 04:29:32)
> 
> > SoCs like the Rockchip Cortex-A9 ones contain divider some clocks
> > that use the regular mechanisms for storage but allow only even
> > dividers and 1 to be used.
> > 
> > Therefore add a flag that lets _is_valid_div limit the valid dividers
> > to these values. _get_maxdiv is also adapted to return even values
> > for the CLK_DIVIDER_ONE_BASED case.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  drivers/clk/clk-divider.c    |   14 ++++++++++++--
> >  include/linux/clk-provider.h |    2 ++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> > index ce5cfe9..bdee7cf 100644
> > --- a/drivers/clk/clk-divider.c
> > +++ b/drivers/clk/clk-divider.c
> > @@ -45,8 +45,16 @@ static unsigned int _get_table_maxdiv(const struct
> > clk_div_table *table)
> > 
> >  static unsigned int _get_maxdiv(struct clk_divider *divider)
> >  {
> > 
> > -       if (divider->flags & CLK_DIVIDER_ONE_BASED)
> > -               return div_mask(divider);
> > +       if (divider->flags & CLK_DIVIDER_ONE_BASED) {
> > +               unsigned int div = div_mask(divider);
> > +
> > +               /* decrease to even number */
> > +               if (divider->flags & CLK_DIVIDER_EVEN)
> > +                       div--;
> > +
> > +               return div;
> > +       }
> > +
> > 
> >         if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
> >         
> >                 return 1 << div_mask(divider);
> >         
> >         if (divider->table)
> > 
> > @@ -141,6 +149,8 @@ static bool _is_valid_div(struct clk_divider
> > *divider, unsigned int div)
> > 
> >                 return is_power_of_2(div);
> >         
> >         if (divider->table)
> >         
> >                 return _is_valid_table_div(divider->table, div);
> > 
> > +       if (divider->flags & CLK_DIVIDER_EVEN && div != 1 && (div % 2) !=
> > 0)
> 
> Is it correct to check for 'div != 1' here?  Wouldn't that check only be
> valid in the presence of CLK_DIVIDER_ONE_BASED?
> 
> Maybe something like this would be more correct:
> 
> 	if (divider->flags & CLK_DIVIDER_EVEN && (div % 2) != 0) {
> 		if (divider->flags & CLK_DIVIDER_ONE_BASED && div == 1)
> 			return true;
> 		return false;
> 	}

hmm, not necessarily. As I understand the doc DIVIDER_ONE_BASED describes how 
the divider is stored in the register, i.e. if the register value is div-1 or 
div.

When div is 1, it of course means don't divide [rate/1], and CLK_DIVIDER_EVEN 
needs to just make sure that bigger dividers that really divide the rate are 
even values (so limiting the possible dividers to 1 2 4 ...), independent on 
how the divider value is stored in the register.


