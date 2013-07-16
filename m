Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3GPXcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:32:52 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:50140 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788Ab3GPXcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:32:51 -0400
Date: Tue, 16 Jul 2013 19:32:48 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rob Herring <robherring2@gmail.com>
cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Jon Medhurst <tixy@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Achin Gupta <achin.gupta@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [RFC PATCH v5 1/1] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
In-Reply-To: <51E5A785.1040805@gmail.com>
Message-ID: <alpine.LFD.2.03.1307161917580.14924@syhkavp.arg>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com> <1373990743-23106-2-git-send-email-lorenzo.pieralisi@arm.com> <51E5A785.1040805@gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Rob Herring wrote:

> On 07/16/2013 11:05 AM, Lorenzo Pieralisi wrote:
> > The TC2 versatile express core tile integrates a logic block that provides the
> > interface between the dual cluster test-chip and the M3 microcontroller that
> > carries out power management. The logic block, called Serial Power Controller
> > (SPC), contains several memory mapped registers to control among other things
> > low-power states, wake-up irqs and per-CPU jump addresses registers.
> > 
> > This patch provides a driver that enables run-time control of features
> > implemented by the SPC power management control logic.
> > 
> > The SPC control logic is required to be programmed very early in the boot
> > process to reset secondary CPUs on the TC2 testchip, set-up jump addresses and
> > wake-up IRQs for power management. Hence, waiting for core changes to be
> > made in the device core code to enable early registration of platform
> > devices, the driver puts in place an early init scheme that allows kernel
> > drivers to initialize the SPC driver directly from the components requiring
> > it, if their initialization routine is called before the driver init
> > function by the boot process.
> > 
> > Device tree bindings documentation for the SPC component is provided with
> > the patchset.
> 
> Just curious, wouldn't a TC2 PSCI implementation eliminate the need for
> most/all of this code?

There is a PSCI equivalent for the above already, in the sense that 
there is a simple MCPM backend that bypass most of the MCPM race 
avoidance code paths and simply calls into PSCI instead.  But not all 
the world is going to be PSCI, and therefore we need to ensure good 
support for non-PSCI platforms as well.

This is why TC2 supports both, and this also ensure that the PSCI 
implementation, which won't be part of the kernel and therefore unlikely 
to get the same level of scrutiny, is properly implemented and doesn't 
introduce any regression when compared to the non PSCI case.

Remember that TC2 is multi-cluster which means that the PSCI 
implementation has to carry the same amount of complexity as the whole 
in-kernel MCPM layer and that doesn't make me overly confident it is 
going to always be right.

All this to say that we do need this code despite PSCI availability.


Nicolas
