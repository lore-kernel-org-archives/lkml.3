Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3CTEgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:36:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12495 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3CTEgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:36:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 21:36:10 -0700
Message-ID: <1363754384.8815.42.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/1] clk: Add notifier support in
 clk_prepare/clk_unprepare
From: Bill Huang <bilhuang@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Tue, 19 Mar 2013 21:39:44 -0700
In-Reply-To: <20130320033142.11073.30097@quantum>
References: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com>
	 <20130319170140.8663.93388@quantum> <1363748149.8815.16.camel@bilhuang-vm1>
	 <20130320033142.11073.30097@quantum>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 11:31 +0800, Mike Turquette wrote:
> Quoting Bill Huang (2013-03-19 19:55:49)
> > On Wed, 2013-03-20 at 01:01 +0800, Mike Turquette wrote:
> > > Quoting Bill Huang (2013-03-19 06:28:32)
> > > > Add notifier calls in clk_prepare and clk_unprepare so drivers which are
> > > > interested in knowing that clk_prepare/unprepare call can act accordingly.
> > > > 
> > > > The existing "clk_set_rate" notifier is not enough for normal DVFS
> > > > inplementation since clock might be enabled/disabled at runtime. Adding
> > > > these notifiers is useful on DVFS core which take clk_prepare as a hint
> > > > on that the notified clock might be enabled later so it can raise voltage
> > > > to a safe level before enabling the clock, and take clk_unprepare as a
> > > > hint that the clock has been disabled and is safe to lower the voltage.
> > > > 
> > > > The added notifier events are:
> > > > 
> > > > PRE_CLK_PREPARE
> > > > POST_CLK_PREPARE
> > > > ABORT_CLK_PREPARE
> > > > PRE_CLK_UNPREPARE
> > > > POST_CLK_UNPREPARE
> > > > 
> > > > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> > > 
> > > I'm still not sure about this approach.  Based on feedback I got from
> > > Linaro Connect I am not convinced that scaling voltage through clk
> > > rate-change notifiers is the right way to go.  As I understand it this
> > > patch only exists for that single purpose, so if the voltage-notifier
> > > idea gets dropped then I will not take this patch in.
> > > 
> > Thanks Mike, actually we won't use your "clk: notifier handler for
> > dynamic voltage scaling" patch instead we are trying to port our DVFS
> > into Non-CPU DVFS framework "devfreq" which will need to hook those
> > notifiers, without the clock notifiers been extended the framework is
> > useless for us since we cannot do polling due to the fact that polling
> > is not in real time. If it ended up extending the notifiers cannot
> > happen then the only choice for us I think would be giving up "devfreq"
> > and implement them in Tegra's "clk_hw".
> 
> I'm familiar with the devfreq framework.  Can you explain further how
> you plan to use devfreq with the clock notifiers?  What does the call
> graph look like?
> 
The call graph will look like this, when any DVFS interested clock rate
changes (including enable and disable) happen -> Tegra devfreq clock
notifier is called -> call into update_devfreq if needed -> in
update_devfreq it will call into .get_target_freq in Tegra
"devfreq_governor" -> and then call into .target of tegra
devfreq_dev_profile to set voltage and done. More details are as below.

We'll create devfreq driver for Tegra VDD_CORE rail, and the safe
voltage level of the rail is determined by tens of clocks (2d, 3d,
mpe,...), all the frequency ladders of those clocks are defined in DT
also the operating points for VDD_CORE is declared in DT where its
frequency will be more of a virtual clock or index.

	operating-points = <
	/* virtual-kHz 	uV */
	0 	950000
	1 	1000000
	2 	1050000
	3 	1100000
	4 	1150000
	5 	1200000
	6 	1250000
	7 	1300000
	8 	1350000

Register a Tegra governor where the callback .get_target_freq is the
function to determine the overall frequency it can go to, and
the .target callback in "devfreq_dev_profile" will be the function
really do the voltage scaling.

Tegra devfreq driver will register clock notifiers on all its interested
clock and hence when any of those clock rate changes, disabled, enabled,
we'll specifically call update_devfreq in the notifier.

