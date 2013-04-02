Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3DBJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:54:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12028 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3DBJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:54:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 02 Apr 2013 02:53:10 -0700
Date: Tue, 2 Apr 2013 12:53:51 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Colin Cross <ccross@google.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Bill Huang <bilhuang@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] clk: Add notifier support in
 clk_prepare/clk_unprepare
Message-ID: <20130402095351.GA18519@tbergstrom-lnx.Nvidia.com>
References: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com>
 <20130319170140.8663.93388@quantum>
 <1363748149.8815.16.camel@bilhuang-vm1>
 <20130320033142.11073.30097@quantum>
 <1363754384.8815.42.camel@bilhuang-vm1>
 <20130320144752.11073.653@quantum>
 <CAPDyKFr+Hqi8Dge3Hn55JXbqEP358F3Eq1OHdYy=2JxucJHtJg@mail.gmail.com>
 <20130321223619.834.31998@quantum>
 <CAMbhsRSSknsEX_gwAzPtV8b8kGdZyTpLEoT2uXaDKoCbpr3cJg@mail.gmail.com>
 <20130328220109.13785.58488@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130328220109.13785.58488@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:01:09PM +0100, Mike Turquette wrote:
> Quoting Colin Cross (2013-03-21 17:06:25)
> > On Thu, Mar 21, 2013 at 3:36 PM, Mike Turquette <mturquette@linaro.org> wrote:
> > > To my knowledge, devfreq performs one task: implements an algorithm
> > > (typically one that loops/polls) and applies this heuristic towards a
> > > dvfs transition.
> > >
> > > It is a policy layer, a high level layer.  It should not be used as a
> > > lower-level mechanism.  Please correct me if my understanding is wrong.
> > >
> > > I think the very idea of the clk framework calling into devfreq is
> > > backwards.  Ideally a devfreq driver would call clk_set_rate as part of
> > > it's target callback.  This is analogous to a cpufreq .target callback
> > > which calls clk_set_rate and regulator_set_voltage.  Can you imagine the
> > > clock framework cross-calling into cpufreq when clk_set_rate is called?
> > > I think that would be strange.
> > >
> > > I think that all of this discussion highlights the fact that there is a
> > > missing piece of infrastructure.  It isn't devfreq or clock rate-change
> > > notifiers.  It is that there is not a dvfs mechanism which neatly builds
> > > on top of these lower-level frameworks (clocks & regulators).  Clearly
> > > some higher-level abstraction layer is needed.
> > 
> > I went through all of this on Tegra2.  For a while I had a
> > dvfs_set_rate api for drivers that needed to modify the voltage when
> > they updated a clock, but I ended up dropping it.  Drivers rarely care
> > about the voltage, all they want to do is set their clock rate.  The
> > voltage necessary to support that clock is an implementation detail of
> > the silicon that is irrelevant to the driver
> 
> Hi Colin,
> 
> I agree about voltage scaling being an implementation detail,  but I
> think that drivers similarly do not care about enabling clocks, clock
> domains, power domains, voltage domains, etc.  The just want to say
> "give me what I need to turn on and run", and "I'm done with that stuff
> now, lazily turn off if you want to".  Runtime pm gives drivers that
> abstraction layer today.
> 
> There is a need for a similar abstraction layer for dvfs or, more
> generically, an abstraction layer for performance.  It is true that a
> driver doesn't care about scaling it's voltage, but it also might not
> care that its functional clock is changing rate, or that memory needs to
> run faster, or that an async bridge or interface clock needs to change
> it's rate.
> 

Drivers are the ones which need to indicate their performance constraints.
A single voltage domain can contain many blocks and also the clock can be
shared (eg. all graphics on Tegra20 and Tegra30 run from the same PLL, even
though there is a per block postdivider, we still want to vary the PLL
depending on load). The only realistic way of stating this kind of constraints
is using the clockrate I think. I don't see which other 'metric' would be
useful across different IP blocks.

Cheers,

Peter.
