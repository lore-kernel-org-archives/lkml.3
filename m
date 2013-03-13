Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3CMFkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:40:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10739 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3CMFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:40:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 22:33:54 -0700
Message-ID: <1363153204.3311.14.camel@bilhuang-vm1>
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
Date: Tue, 12 Mar 2013 22:40:04 -0700
In-Reply-To: <51400D9D.9060305@wwwdotorg.org>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>
	 <20130312134032.GU4977@n2100.arm.linux.org.uk>
	 <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org>
	 <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 13:24 +0800, Stephen Warren wrote:
> On 03/12/2013 11:08 PM, Bill Huang wrote:
> > On Wed, 2013-03-13 at 12:42 +0800, Stephen Warren wrote:
> >> On 03/12/2013 07:47 PM, Bill Huang wrote:
> >>> On Tue, 2013-03-12 at 21:40 +0800, Russell King - ARM Linux wrote:
> >>>> On Tue, Mar 12, 2013 at 05:37:41AM -0700, Bill Huang wrote:
> >>>>> Add the below four notifier events so drivers which are interested in
> >>>>> knowing the clock status can act accordingly. This is extremely useful
> >>>>> in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
> >>>>>
> >>>>> PRE_CLK_ENABLE
> >>>>> POST_CLK_ENABLE
> >>>>> PRE_CLK_DISABLE
> >>>>> POST_CLK_DISABLE
> >>>>>
> >>>>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> >>>>
> >>>> NAK.  *Sigh* NO, this is the wrong level to be doing stuff like this.
> >>>>
> >>>> The *ONLY* thing that clk_prepare_enable() and clk_prepare_disable() should
> >>>> *EVER* be doing is calling clk_prepare(), clk_enable(), clk_disable() and
> >>>> clk_unprepare().  Those two functions are *merely* helpers for drivers
> >>>> who don't wish to make the individual calls.
> >>>>
> >>>> Drivers are still completely free to call the individual functions, at
> >>>> which point your proposal breaks horribly - and they _do_ call the
> >>>> individual functions.
> >>>
> >>> I'm proposing to give device driver a choice when it knows that some
> >>> driver might be interested in knowing its clock's enabled/disabled state
> >>> change at runtime, this is very important for centralized DVFS core
> >>> driver. It is not meant to be covering all cases especially for drivers
> >>> which is not part of the DVFS, so we don't care if it is calling
> >>> clk_enable/disable directly or not.
> >>
> >> I believe the point Russell is making is not that the idea behind this
> >> patch is wrong, but simply that the function where you put the hooks is
> >> wrong. The hooks should at least be in clk_enable/clk_disable and not
> >> clk_prepare_enable/clk_disable_unprepare, since any driver is free to
> >> call clk_prepare separately from clk_enable. The hooks should be
> >> implemented in the lowest-level common function that all
> >> driver-accessible paths call through.
> > 
> > Thanks, I know the point, but unfortunately there is no good choice for
> > hooking this since those low level functions clk_enable/clk_disable will
> > be called in interrupt context so it is not possible to send notify. We
> > might need to come out a better approach if we can think of any.
> > Currently I still think this is acceptable (Having all the drivers which
> > are using our interested clocks call these function to enable/disable
> > clock in their runtime_pm calls) though it's not perfect. 
> 
> No, that definitely won't work. Not all drivers use those APIs, nor
> should they.
> 
That will be too bad, it looks like we deadlock in the mechanism, we
cannot change existing drivers behavior (that means some call
clk_disable/enable directly, some are not), and we cannot hook notifier
in clk_disable/enable either, that means there seems no any chance to
get what we want, any idea?


