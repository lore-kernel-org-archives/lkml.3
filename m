Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3FQRor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:44:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51527 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3FQRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:44:45 -0400
Date: Mon, 17 Jun 2013 10:44:51 -0700
From: Olof Johansson <olof@lixom.net>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC PATCH v4 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
Message-ID: <20130617174451.GF28497@quad.lixom.net>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:51:09PM +0100, Lorenzo Pieralisi wrote:
> The TC2 versatile express core tile integrates a logic block that provides the
> interface between the dual cluster test-chip and the M3 microcontroller that
> carries out power management. The logic block, called Serial Power Controller
> (SPC), contains several memory mapped registers to control among other things
> low-power states, operating points and reset control.
> 
> This patch provides a driver that enables run-time control of features
> implemented by the SPC control logic.
> 
> The SPC control logic is required to be programmed very early in the boot
> process to reset secondary CPUs on the TC2 testchip, set-up jump addresses and
> wake-up IRQs for power management.
> Since the SPC logic is also used to control clocks and operating points,
> that have to be initialized early as well, the SPC interface consumers can not
> rely on early initcalls ordering, which is inconsistent, to wait for SPC
> initialization. Hence, in order to keep the components relying on the SPC
> coded in a sane way, the driver puts in place a synchronization scheme that
> allows kernel drivers to check if the SPC driver has been initialized and if
> not, to initialize it upon check.
> 
> A status variable is kept in memory so that loadable modules that require SPC
> interface (eg CPUfreq drivers) can still check the correct initialization and
> use the driver correctly after functions used at boot to init the driver are
> freed.
> 
> The driver also provides a bridge interface through the vexpress config
> infrastructure. Operations allowing to read/write operating points are
> made to go via the same interface as configuration transactions so that
> all requests to M3 are serialized.
> 
> Device tree bindings documentation for the SPC component is provided with
> the patchset.

Sorry, I got to think of this over the weekend and should have replied
before you had a chance to repost, but still:

Why is the operating point and frequency change code in this driver at all?
Usually, the MFD driver contains a shared method to access register space on
a multifunction device, but the actual operation of each subdevice is handled
by individual drivers in the regular locations.

So, in the case of operating points and requencies, that should be in
a cpufreq driver. And the clock setup should presumably be in a clk
framework driver if needed.

Then all that would be left here is the functionality for submitting the two
kinds of commands, and handling interrupts.

That'll trim down the driver to a point where I think you'll find it much
easier to get merged. :-)


[...]

> +struct ve_spc_drvdata {
> +	void __iomem *baseaddr;
> +	/* A15 processor MPIDR[15:8] bitfield */

A comment describing what the meaning is would be more useful, even if
less technically specific. Or maybe something like "Cluster ID of the
A15 cluster, from MPIDR[15:8]" or similar.

> +	u32 a15_clusid;


(I reserve the right to have more comments later but I think we want to discuss
the removal of frequency management code first. :-)


-Olof
