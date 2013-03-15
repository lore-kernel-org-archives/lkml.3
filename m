Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3CORKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:10:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36317 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3CORKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:10:01 -0400
Date: Fri, 15 Mar 2013 17:09:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bill Huang <bilhuang@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in
	clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130315170945.GM4977@n2100.arm.linux.org.uk>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com> <20130312134032.GU4977@n2100.arm.linux.org.uk> <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org> <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org> <1363153204.3311.14.camel@bilhuang-vm1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363153204.3311.14.camel@bilhuang-vm1>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:40:04PM -0700, Bill Huang wrote:
> That will be too bad, it looks like we deadlock in the mechanism, we
> cannot change existing drivers behavior (that means some call
> clk_disable/enable directly, some are not), and we cannot hook notifier
> in clk_disable/enable either, that means there seems no any chance to
> get what we want, any idea?

Look, the whole point is:

- Drivers can call clk_enable/clk_disable from their atomic regions to
  control the clock.  Drivers which do this also call clk_prepare/
  clk_unprepare from a schedulable context to perform any operations
  necessary to allow the clock to be used.

- Drivers which only ever control the clock from a schedulable context
  *can* use clk_prepare_enable()/clk_disable_unprepare() to control
  their clock, which simplifies the coding in the driver.

The whole point here is to cater for what is found on different SoCs and
not need to keep rewriting the drivers between different SoCs.

So, the idea is that:

- clk_prepare() does whatever is needed to prepare a clock for use which
  may require waiting for the clock to be in a state which it can be
  enabled.  In other words, if there is a PLL, the PLL is setup and
  we wait for it to report that it has locked.

- clk_enable() is about turning the clock output on so that the device
  receives the clock.

Now, in the case of a PLL directly feeding a device, it's entirely possible
that clk_prepare() ends up providing the clock signal to the device, and
clk_enable() does absolutely nothing.

Or, if the clock has a gate on it, it's entirely possible that clk_prepare()
does nothing, and clk_enable() unmasks the gate to allow the clock to be
provided to the device - which can happen from atomic contexts.

The whole point about the separation of these two functions is that device
driver writers _can_ code their drivers for both situations and not care
about how the SoC implements the clocking at all.

Why did we end up with this split in the first place?  Because we ran into
the problem that some SoCs required a sleeping clk_enable() and others
didn't, and the whole thing was turning into an incompatible mess.

So, please.  Realise that clk_prepare() and clk_enable() are the _official_
APIs, and that clk_prepare_enable() is merely a helper function for drivers
to allow them to automate the calling of those two functions in succession
with _no_ _further_ _processing_ at all.

So, if your hooks need to be callable from schedulable contexts, then you
need to put them inside clk_prepare().  If your hooks are callable from
atomic contexts, then they can go into clk_enable().  But what you can
not do is put them into clk_prepare_enable().
