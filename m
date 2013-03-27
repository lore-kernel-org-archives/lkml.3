Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3C0OZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:25:33 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57179 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3C0OZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:25:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thomas Gleixner <tglx@linutronix.de>, Ulf Hansson <ulf.hansson@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <alpine.LFD.2.02.1303271141470.22263@ionos>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
 <alpine.LFD.2.02.1303270941320.22263@ionos>
 <CAKohpomWZ_9a_RceQ419QAAXOR17yrtrRP0Gf4xoS3B=yzbRXg@mail.gmail.com>
 <CAPDyKFoHQK576H+zsW9ykzJT-gjc6=qeiRVi26THa_4dhNVRVw@mail.gmail.com>
 <alpine.LFD.2.02.1303271141470.22263@ionos>
Message-ID: <20130327142519.4014.82657@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
Date: Wed, 27 Mar 2013 07:25:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thomas Gleixner (2013-03-27 04:09:17)
> On Wed, 27 Mar 2013, Ulf Hansson wrote:
> > On 27 March 2013 10:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > > On 27 March 2013 15:10, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> On Wed, 27 Mar 2013, Mike Turquette wrote:
> > >>
> > >>> Reentrancy into the clock framework from the clk.h api is necessary
> > >>> for clocks that are prepared and unprepared via i2c_transfer (which
> > >>> includes many PMICs and discrete audio chips) as well as for several
> > >>> other use cases.
> > >>
> > >> That explanation sucks.
> > >>
> > >> Why does an i2c clock need reentrancy? Just because it's i2c or what?
> > >
> > > I am noway connected to this development but was just going through
> > > your mail and i think i might know the answer why is this required.
> > >
> > > Consider an example where an external chip has clock controller and has
> > > bits which can be programmed to enable/disable clock. And this chip is
> > > connected via spi/i2c to SoC.
> > >
> > > clk_prepare(peripheral on external chip)
> > >   -> i2c_xfer(to write to external chips register)
> > >       -> clk_enable(i2c controller)
> > >           ->controller-xfer-routine.. and finally we enable clk here...
> 
> Which does not explain the whole issue:
> 
>     clk_prepare() takes the mutex
>     clk_enable() takes the spinlock
> 
> That works today.
> 
> The issue arises, if you need to call clk_prepare(i2c) in the xfer
> routine.
> 

The issue arises any time a clk_ops callback calls a function that
unwittingly re-enters the clock framework.  I think the easiest example
to understand and perhaps the most common in practice is a clock which
is controlled via an i2c transfer.

Viresh's example makes the mistake of calling
clk_enable(i2c_controller), but it must also call
clk_prepare(i2c_controller) which is missing in the call graph above.
That nested call to clk_prepare is where the reentrancy comes from.

This has nothing to do with the prepare/enable locking split and leaves
that relationship intact.

> > >
> > > Sorry if i am on the wrong side :)
> 
> Only slightly :)
> 
> > I agree with you Viresh. I guess Mike should update the commit message.
> > 
> > I would also like add another reason to why this is needed. For some
> > clks you would like to do pinctrl operations from a clk hw. But since
> > a pinctrl driver likely requires a clk to be prepared|enabled, we run
> > into a clk reentrant issue.
> 
> Fair enough. This all wants to go into the changelog, so we can
> understand why we have this business.
> 

I'll submit a v5 which I hope will end the pain and suffering this patch
has caused you.

Regards,
Mike

> Thanks,
> 
>         tglx
