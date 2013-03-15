Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3COSou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:44:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61624 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3COSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:44:49 -0400
Date: Fri, 15 Mar 2013 14:44:44 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Bill Huang <bilhuang@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in
 clk_prepare_enable/clk_disable_unprepare
In-Reply-To: <20130315165744.GK4977@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.03.1303151435470.3069@syhkavp.arg>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com> <20130312134032.GU4977@n2100.arm.linux.org.uk> <1363139273.21694.11.camel@bilhuang-vm1> <20130315165744.GK4977@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Russell King - ARM Linux wrote:

> On Tue, Mar 12, 2013 at 06:47:53PM -0700, Bill Huang wrote:
> > On Tue, 2013-03-12 at 21:40 +0800, Russell King - ARM Linux wrote:
> > > On Tue, Mar 12, 2013 at 05:37:41AM -0700, Bill Huang wrote:
> > > > Add the below four notifier events so drivers which are interested in
> > > > knowing the clock status can act accordingly. This is extremely useful
> > > > in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
> > > > 
> > > > PRE_CLK_ENABLE
> > > > POST_CLK_ENABLE
> > > > PRE_CLK_DISABLE
> > > > POST_CLK_DISABLE
> > > > 
> > > > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> > > 
> > > NAK.  *Sigh* NO, this is the wrong level to be doing stuff like this.
> > > 
> > > The *ONLY* thing that clk_prepare_enable() and clk_prepare_disable() should
> > > *EVER* be doing is calling clk_prepare(), clk_enable(), clk_disable() and
> > > clk_unprepare().  Those two functions are *merely* helpers for drivers
> > > who don't wish to make the individual calls.
> > > 
> > > Drivers are still completely free to call the individual functions, at
> > > which point your proposal breaks horribly - and they _do_ call the
> > > individual functions.
> >
> > I'm proposing to give device driver a choice when it knows that some
> > driver might be interested in knowing its clock's enabled/disabled state
> > change at runtime, this is very important for centralized DVFS core
> > driver. It is not meant to be covering all cases especially for drivers
> > which is not part of the DVFS, so we don't care if it is calling
> > clk_enable/disable directly or not.
> 
> But you're not giving drivers a choice.  You're giving them an ultimatum.
> Either they use clk_prepare_enable() which must only be called from non-
> atomic contexts and have the notifiers, or if they need to use the
> individual functions (which is what they _should_ be doing but people
> are too lazy to properly convert stuff) they don't get the option of
> the notifiers at all.
> 
> This sucks totally, design wise.
> 
> The whole point of clk_prepare_enable() is that it is a helper function
> to _only_ do the clk_prepare() call followed by a clk_enable() call and
> _nothing_ _else_ _what_ _so_ _ever_.

If people are too lazy and start abusing clk_prepare_enable() then this 
helper function becomes counter-productive and should simply be removed.
Same issue as with IS_ERR_OR_NULL().


Nicolas
