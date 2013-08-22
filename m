Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3HVJVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:21:37 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43967 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3HVJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:21:35 -0400
Date: Thu, 22 Aug 2013 10:21:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
Message-ID: <20130822092130.GB22023@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
 <20130821101448.GJ29850@lee--X1>
 <CACRpkdYjvFTJAUL6xKxjkVd_v=DHHRkswoB_eq0Npqj5Sw23KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYjvFTJAUL6xKxjkVd_v=DHHRkswoB_eq0Npqj5Sw23KQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Linus Walleij wrote:

> On Wed, Aug 21, 2013 at 12:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 21 Aug 2013, Linus Walleij wrote:
> 
> >> Isn't it possible to fork a function u8500_clk_init_dt() to add all the
> >> clocks in the DT probe path and keep this function
> >> u8500_clk_init() as it is?
> >
> > Yes, we probably could do that, but as we're ripping out ATAG booting
> > support from the ux500 platform, I'll just remove the
> > clk_register_clkdev()s during the process.
> 
> I really do not like the approach of uglifying something and then
> beautifying it later... I prefer each step in isolation to be good
> looking, or you will be confused when traversing the history.

So then we have a few options, some more realistic than others.

1. Duplicate each of the; clk_reg_prcmu_*(), clk_reg_prcc_pclk(),
clk_reg_prcc_kclk() calls into your proposed u8500_clk_init_dt(),
which, while keeping everything separate would be unrealistic.

2. Move both clk_register_clkdev() and the struct clock arrays into
'drivers/clk/ux500/clk-prcmu.c' and 'drivers/clk/ux500/clk-prcc.c' and
make the correct decisions in clk_reg_prcmu() and clk_reg_prcc(). This
would be more viable, but would entail splitting the defines and the
struct clock arrays (stores), probably creating a little more
disparity. It would also mean adding 3 parameters (con_id, dev_fmt and
array_index) to each of; clk_reg_prcmu_gate(),
clk_reg_prcmu_scalable(), clk_reg_prcmu_opp_gate(),
clk_reg_prcmu_scalable_rate(), clk_reg_prcmu_rate(),
clk_reg_prcmu_opp_volt_scalable, clk_reg_prcmu() and 4 parameters
(con_id, dev_fmt, array_index_x, array_index_y) to each of
clk_reg_prcc_pclk(), clk_reg_prcc_kclk() and clk_reg_prcc().

Or, the most viable option:

3. Leave it as it is. All we're doing here is populating an array of
pointers. It costs practically nothing, continues legacy ATAG support
as well as adding Device Tree support. It's far neater than the other
two options, by a long shot. And then, when we're ready to take out
ATAG booting support (which I'm working on right now), we just remove
the clk_register_clkdev() calls and we're left with the nice and neat
macros.

Unless there's a viable 4th option which hasn't popped into my head
just yet. I'm all hears. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
