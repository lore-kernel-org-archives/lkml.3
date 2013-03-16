Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3CPB6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:58:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13120 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3CPB6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:58:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Mar 2013 18:51:04 -0700
Message-ID: <1363399103.2879.6.camel@bilhuang-vm1>
Subject: Re: [RFC v2 1/1] clk: Add notifier support in
 clk_prepare/clk_unprepare
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 15 Mar 2013 18:58:23 -0700
In-Reply-To: <51437BB6.3040607@wwwdotorg.org>
References: <1363253464-3200-1-git-send-email-bilhuang@nvidia.com>
	 <20130315174558.GS4977@n2100.arm.linux.org.uk>
	 <51437BB6.3040607@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 03:51 +0800, Stephen Warren wrote:
> On 03/15/2013 11:45 AM, Russell King - ARM Linux wrote:
> > On Thu, Mar 14, 2013 at 02:31:04AM -0700, Bill Huang wrote:
> >> Add the below two notifier events so drivers which are interested in
> >> knowing the clock status can act accordingly. This is extremely useful
> >> in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
> >>
> >> CLK_PREPARED
> >> CLK_UNPREPARED
> >>
> >> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> >> ---
> >>  drivers/clk/clk.c   |    3 +++
> >>  include/linux/clk.h |    2 ++
> >>  2 files changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> >> index ed87b24..3292cec 100644
> >> --- a/drivers/clk/clk.c
> >> +++ b/drivers/clk/clk.c
> >> @@ -550,6 +550,7 @@ void clk_unprepare(struct clk *clk)
> >>  {
> >>  	mutex_lock(&prepare_lock);
> >>  	__clk_unprepare(clk);
> >> +	__clk_notify(clk, CLK_UNPREPARED, clk->rate, clk->rate);
> >>  	mutex_unlock(&prepare_lock);
> >>  }
> >>  EXPORT_SYMBOL_GPL(clk_unprepare);
> >> @@ -598,6 +599,8 @@ int clk_prepare(struct clk *clk)
> >>  
> >>  	mutex_lock(&prepare_lock);
> >>  	ret = __clk_prepare(clk);
> >> +	if (!ret)
> >> +		__clk_notify(clk, CLK_PREPARED, clk->rate, clk->rate);
> > 
> > So, on prepare, we notify after we've prepared the clock.  On unprepare,
> > we notify after the clock has been shut down.  Are you sure that's the
> > correct ordering?  Would it not be better to view it in a stack-like
> > fashion, iow:
> 
> > get
> > 	prepare
> > 		notify-prepare
> > 			enable
> > 			disable
> > 		notify-unprepare
> > 	unprepare
> > put
> 
> Yes, these should be stacked/nested better for consistency.
> 
> But for DVFS, the voltage needs to be raised before the prepare body is
> run, so that if clk_prepare actually enables the clock, the voltage is
> already at the safe level required by that clock. Similarly, for
> unprepare, you can only lower the voltage after having turned off the
> clock, which is guaranteed after the unprepare body. So, I think you
> want to move the notifier for prepare in the code above (and rename it
> to pre/before_prepare?), rather than the notifier for unprepare.

Oh yes I should raised notify before prepare body is run.
> 
> In order to cover more cases, you might have both
> {pre,post}_{un,}prepare notifiers, although I'm not sure when you'd use
> the other two options.

Right, maybe {pre,post}_{un,}prepare will be useful.
> 
> >> diff --git a/include/linux/clk.h b/include/linux/clk.h
> 
> >> +#define CLK_PREPARED			BIT(3)
> >> +#define CLK_UNPREPARED			BIT(4)
> 


