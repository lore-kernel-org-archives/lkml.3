Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3FRKWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:22:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54982 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab3FRKWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:22:21 -0400
Date: Tue, 18 Jun 2013 11:22:13 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Olof Johansson <olof@lixom.net>
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
Message-ID: <20130618102213.GA1564@e102568-lin.cambridge.arm.com>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
 <20130617174451.GF28497@quad.lixom.net>
MIME-Version: 1.0
In-Reply-To: <20130617174451.GF28497@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Jun 2013 10:22:17.0304 (UTC) FILETIME=[B5567580:01CE6C0D]
X-MC-Unique: 113061811221800901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

thanks a lot.

On Mon, Jun 17, 2013 at 06:44:51PM +0100, Olof Johansson wrote:
> On Mon, Jun 17, 2013 at 04:51:09PM +0100, Lorenzo Pieralisi wrote:
> > The TC2 versatile express core tile integrates a logic block that provides the
> > interface between the dual cluster test-chip and the M3 microcontroller that
> > carries out power management. The logic block, called Serial Power Controller
> > (SPC), contains several memory mapped registers to control among other things
> > low-power states, operating points and reset control.
> > 
> > This patch provides a driver that enables run-time control of features
> > implemented by the SPC control logic.
> > 
> > The SPC control logic is required to be programmed very early in the boot
> > process to reset secondary CPUs on the TC2 testchip, set-up jump addresses and
> > wake-up IRQs for power management.
> > Since the SPC logic is also used to control clocks and operating points,
> > that have to be initialized early as well, the SPC interface consumers can not
> > rely on early initcalls ordering, which is inconsistent, to wait for SPC
> > initialization. Hence, in order to keep the components relying on the SPC
> > coded in a sane way, the driver puts in place a synchronization scheme that
> > allows kernel drivers to check if the SPC driver has been initialized and if
> > not, to initialize it upon check.
> > 
> > A status variable is kept in memory so that loadable modules that require SPC
> > interface (eg CPUfreq drivers) can still check the correct initialization and
> > use the driver correctly after functions used at boot to init the driver are
> > freed.
> > 
> > The driver also provides a bridge interface through the vexpress config
> > infrastructure. Operations allowing to read/write operating points are
> > made to go via the same interface as configuration transactions so that
> > all requests to M3 are serialized.
> > 
> > Device tree bindings documentation for the SPC component is provided with
> > the patchset.
> 
> Sorry, I got to think of this over the weekend and should have replied
> before you had a chance to repost, but still:
> 
> Why is the operating point and frequency change code in this driver at all?
> Usually, the MFD driver contains a shared method to access register space on
> a multifunction device, but the actual operation of each subdevice is handled
> by individual drivers in the regular locations.
> 
> So, in the case of operating points and requencies, that should be in
> a cpufreq driver. And the clock setup should presumably be in a clk
> framework driver if needed.

Well, yes this can be done. I will probably move this code out of mfd
since this choice caused more issues than the current driver solves.

By moving the frequency changes into subsystems, we are certainly
trimming down the code, not sure we improve the maintainability though,
keep in mind that we already had to change the vexpress-config interface
to cope with SPC oddities, at least now these intricacies are self-contained.

What you are suggesting makes sense though, I will do it.

> Then all that would be left here is the functionality for submitting the two
> kinds of commands, and handling interrupts.

Not really. There are still a bunch of registers to set-up wake-up IRQs,
power down flags and warm-boot jump addresses that do not go through the
vexpress interface, they are ad-hoc. I could also split that stuff, but I
really do not think it is worth the effort.

> That'll trim down the driver to a point where I think you'll find it much
> easier to get merged. :-)

To start with I have to understand in which directory this code should
live. Moving the frequency settings in clk/CPUfreq drivers should be
feasible with extra DT complexity for their bindings.

> [...]
> 
> > +struct ve_spc_drvdata {
> > +	void __iomem *baseaddr;
> > +	/* A15 processor MPIDR[15:8] bitfield */
> 
> A comment describing what the meaning is would be more useful, even if
> less technically specific. Or maybe something like "Cluster ID of the
> A15 cluster, from MPIDR[15:8]" or similar.
> 
> > +	u32 a15_clusid;
> 
> 
> (I reserve the right to have more comments later but I think we want to discuss
> the removal of frequency management code first. :-)

I will do that and comments are always welcome.

Thanks,
Lorenzo

