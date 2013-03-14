Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab3CNCKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:10:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1832 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3CNCKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:10:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 19:10:39 -0700
Message-ID: <1363227311.3311.30.camel@bilhuang-vm1>
Subject: Re: [RFC 1/1] clk: Add notifier support in
 clk_prepare_enable/clk_disable_unprepare
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Wed, 13 Mar 2013 19:15:11 -0700
In-Reply-To: <5140C12A.4060900@wwwdotorg.org>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
	 <20130312134032.GU4977@n2100.arm.linux.org.uk>
	 <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org>
	 <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org>
	 <1363153204.3311.14.camel@bilhuang-vm1> <5140C12A.4060900@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 02:10 +0800, Stephen Warren wrote:
> On 03/12/2013 11:40 PM, Bill Huang wrote:
> > On Wed, 2013-03-13 at 13:24 +0800, Stephen Warren wrote:
> >> On 03/12/2013 11:08 PM, Bill Huang wrote:
> >>> On Wed, 2013-03-13 at 12:42 +0800, Stephen Warren wrote:
> >>>> On 03/12/2013 07:47 PM, Bill Huang wrote:
> >>>>> On Tue, 2013-03-12 at 21:40 +0800, Russell King - ARM Linux wrote:
> >>>>>> On Tue, Mar 12, 2013 at 05:37:41AM -0700, Bill Huang wrote:
> >>>>>>> Add the below four notifier events so drivers which are interested in
> >>>>>>> knowing the clock status can act accordingly. This is extremely useful
> >>>>>>> in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
> >>>>>>>
> >>>>>>> PRE_CLK_ENABLE
> >>>>>>> POST_CLK_ENABLE
> >>>>>>> PRE_CLK_DISABLE
> >>>>>>> POST_CLK_DISABLE
> ...
> >>> Thanks, I know the point, but unfortunately there is no good choice for
> >>> hooking this since those low level functions clk_enable/clk_disable will
> >>> be called in interrupt context so it is not possible to send notify. We
> >>> might need to come out a better approach if we can think of any.
> >>> Currently I still think this is acceptable (Having all the drivers which
> >>> are using our interested clocks call these function to enable/disable
> >>> clock in their runtime_pm calls) though it's not perfect. 
> >>
> >> No, that definitely won't work. Not all drivers use those APIs, nor
> >> should they.
> >>
> > That will be too bad, it looks like we deadlock in the mechanism, we
> > cannot change existing drivers behavior (that means some call
> > clk_disable/enable directly, some are not), and we cannot hook notifier
> > in clk_disable/enable either, that means there seems no any chance to
> > get what we want, any idea?
> 
> I don't know the correct answer.
> 
> But I have a question: Why can't we run notifications from the real
> clk_enable? Does the notification mechanism itself inherently block, or
> are we worried that implementations/receivers of these notifications
> might block. Perhaps we can simply define that these notification types
I think both.
> may be triggered in atomic context and hence implementations have to
> support executing in atomic context. Is possible to make that a
> requirement? Is it possible to implement the code that receives these
> notifications in atomic context?
Making it executing in atomic context won't work since for DVFS we
generally having to set voltage (while receiving the notify) through I2C
interface which can sleep.
> 
> Is it possible to defer triggering of notifications to some non-atomic
> context, even if they happen in an atomic context?
I don't think deferring will work either, considering the usage of DVFS,
device voltage is tightly coupled with frequency, when clock rate is
about to increase, we have to boost voltage first and we can lower the
voltage after the clock rate has decreased. All the above sequence have
to be guaranteed or you might crash, so deferring not only make thing
complicated in controlling the order but also hurt performance.
> 
> I also wonder if this is the right conceptual level to be hooking into
> the system. Perhaps DVFS is not something that should be triggered by
> noticing that clocks have changed rates, but rather it should be some
> form of higher layer that controls (calls into) both the regulator and
> clock APIs?
I wonder will there be a feasible API can do that since most of SoC is
characterizing DVFS on frequency vs. voltage, it makes sense that
reviewing voltage when the clock rate change happen, and the only
mechanism seem to be hooking notifier in not only clock rate change but
also clock enable/disable. 


