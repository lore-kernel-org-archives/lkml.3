Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3FUHY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:24:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50917 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FUHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:24:25 -0400
Date: Fri, 21 Jun 2013 00:24:32 -0700
From: Olof Johansson <olof@lixom.net>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC PATCH v4 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
Message-ID: <20130621072432.GB30076@quad.lixom.net>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20130617174451.GF28497@quad.lixom.net>
 <20130618102213.GA1564@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618102213.GA1564@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 18, 2013 at 11:22:13AM +0100, Lorenzo Pieralisi wrote:
> Hi Olof,
> 
> thanks a lot.
> 
> On Mon, Jun 17, 2013 at 06:44:51PM +0100, Olof Johansson wrote:
> > 
> > Sorry, I got to think of this over the weekend and should have replied
> > before you had a chance to repost, but still:
> > 
> > Why is the operating point and frequency change code in this driver at all?
> > Usually, the MFD driver contains a shared method to access register space on
> > a multifunction device, but the actual operation of each subdevice is handled
> > by individual drivers in the regular locations.
> > 
> > So, in the case of operating points and requencies, that should be in
> > a cpufreq driver. And the clock setup should presumably be in a clk
> > framework driver if needed.
> 
> Well, yes this can be done. I will probably move this code out of mfd
> since this choice caused more issues than the current driver solves.
> 
> By moving the frequency changes into subsystems, we are certainly
> trimming down the code, not sure we improve the maintainability though,
> keep in mind that we already had to change the vexpress-config interface
> to cope with SPC oddities, at least now these intricacies are self-contained.

Yes, I think it makes sense to split up the "mess", and not expose
everybody to all of the quirks and complexities of the system design
unless it makes sense to need to know about it at a particular layer of
the driver stack.

> What you are suggesting makes sense though, I will do it.

Ok, cool. I think Sam will be happy to see a smaller driver (and hopefully be
quick at merging it) once that's done too. But it looks like it'd be 3.12
material given the current phase of 3.10 and the fact that it'll take a while
to do the refactoring.

> > Then all that would be left here is the functionality for submitting the two
> > kinds of commands, and handling interrupts.
> 
> Not really. There are still a bunch of registers to set-up wake-up IRQs,
> power down flags and warm-boot jump addresses that do not go through the
> vexpress interface, they are ad-hoc. I could also split that stuff, but I
> really do not think it is worth the effort.

It _sounds_ like you could be fine with moving direct access to those pieces of
hardware out to the drivers that need to touch them. MFD is mostly about
allowing a arbitration point for when multiple drivers need to syncronize
and/or share an interface such as a mapped register bank or i2c device.

> > That'll trim down the driver to a point where I think you'll find it much
> > easier to get merged. :-)
> 
> To start with I have to understand in which directory this code should
> live. Moving the frequency settings in clk/CPUfreq drivers should be
> feasible with extra DT complexity for their bindings.

Yes, clock and cpufreq would go in their corresponding driver trees. I'll need
to revisit the code a bit tomorrow to see what else would be left and where
good homes for them would be.



-Olof
