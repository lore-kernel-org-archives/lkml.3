Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CBC4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:56:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16025 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CBC4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:56:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Mar 2013 18:55:58 -0800
Message-ID: <1362192954.2407.26.camel@bilhuang-vm1>
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
From: Bill Huang <bilhuang@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Fri, 1 Mar 2013 18:55:54 -0800
In-Reply-To: <20130301204832.6210.40653@quantum>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
	 <1362026969-11457-3-git-send-email-mturquette@linaro.org>
	 <1362130891.19498.12.camel@bilhuang-vm1>
	 <20130301182234.6210.63879@quantum> <20130301204832.6210.40653@quantum>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 04:48 +0800, Mike Turquette wrote:
> Quoting Mike Turquette (2013-03-01 10:22:34)
> > Quoting Bill Huang (2013-03-01 01:41:31)
> > > On Thu, 2013-02-28 at 12:49 +0800, Mike Turquette wrote:
> > > > Dynamic voltage and frequency scaling (dvfs) is a common power saving
> > > > technique in many of today's modern processors.  This patch introduces a
> > > > common clk rate-change notifier handler which scales voltage
> > > > appropriately whenever clk_set_rate is called on an affected clock.
> > > 
> > > I really think clk_enable and clk_disable should also be triggering
> > > notifier call and DVFS should act accordingly since there are cases
> > > drivers won't set clock rate but instead disable its clock directly, do
> > > you agree?
> > > > 
> > 
> > Hi Bill,
> > 
> > I'll think about this.  Perhaps a better solution would be to adapt
> > these drivers to runtime PM.  Then a call to runtime_pm_put() would
> > result in a call to clk_disable(...) and regulator_set_voltage(...).
> > 
> > There is no performance-based equivalent to runtime PM, which is one
> > reason why clk_set_rate is a likely entry point into dvfs.  But for
> > operations that have nice api's like runtime PM it would be better to
> > use those interfaces and not overload the clk.h api unnecessarily.
> > 
> 
> Bill,
> 
> I wasn't thinking at all when I wrote this.  Trying to rush to the
> airport I guess...
> 
> clk_enable() and clk_disable() must not sleep and all operations are
> done under a spinlock.  So this rules out most use of notifiers.  It is
> expected for some drivers to very aggressively enable/disable clocks in
> interrupt handlers so scaling voltage as a function of clk_{en|dis}able
> calls is also likely out of the question.

Yeah for those existing drivers to call enable/disable clocks in
interrupt have ruled out this, I didn't think through when I was asking.
> 
> Some platforms have chosen to implement voltage scaling in their
> .prepare callbacks.  I personally do not like this and still prefer
> drivers be adapted to runtime pm and let those callbacks handle voltage
> scaling along with clock handling.

I think different SoC have different mechanisms or constraints on doing
their DVFS, such as Tegra VDD_CORE rail, it supplies power to many
devices and as a consequence each device do not have their own power
rail to control, instead a central driver to handle/control this power
rail is needed (to set voltage at the maximum of the requested voltage
from all its sub-devices), so I'm wondering even if every drivers are
doing DVFS through runtime pm, we're still having hole on knowing
whether or not clocks of the interested devices are enabled/disabled at
runtime, I'm not familiar with runtime pm and hence do not know if there
is a mechanism to handle this, I'll study a bit. Thanks.
> 
> Regards,
> Mike
> 
> > > > There are three prerequisites to using this feature:
> > > > 
> > > > 1) the affected clocks must be using the common clk framework
> > > > 2) voltage must be scaled using the regulator framework
> > > > 3) clock frequency and regulator voltage values must be paired via the
> > > > OPP library
> > > 
> > > Just a note, Tegra Core won't meet prerequisite #3 since each regulator
> > > voltage values is associated with clocks driving those many sub-HW
> > > blocks in it.
> > 
> > This patch isn't the one and only way to perform dvfs.  It is just a
> > helper function for registering notifier handlers for systems that meet
> > the above three requirements.  Even if you do not use the OPP library
> > there is no reason why you could not register your own rate-change
> > notifier handler to implement dvfs using whatever lookup-table you use
> > today.
> > 
> > And patches are welcome to extend the usefulness of this helper.  I'd
> > like as many people to benefit from this mechanism as possible.

The extension is not so easy for us though since OPP library is assuming
each device has a 1-1 mapping on its operating frequency and voltage.
> > 
> > At some point we should think hard about DT bindings for these operating
> > points...
> > 
> > Regards,
> > Mike


