Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3GRJ2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:28:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53893 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3GRJ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:28:17 -0400
Date: Thu, 18 Jul 2013 10:28:09 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
Message-ID: <20130718092809.GA29977@e102568-lin.cambridge.arm.com>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20130717210700.GA19864@zurbaran>
MIME-Version: 1.0
In-Reply-To: <20130717210700.GA19864@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Jul 2013 09:28:13.0224 (UTC) FILETIME=[201BA280:01CE8399]
X-MC-Unique: 113071810281400201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Jul 17, 2013 at 10:07:00PM +0100, Samuel Ortiz wrote:
> Hi Lorenzo,
> 
> On Tue, Jul 16, 2013 at 05:05:42PM +0100, Lorenzo Pieralisi wrote:
> > Hello,
> > 
> > version v5 of VExpress SPC driver, please read on the changelog for major
> > changes and explanations.
> > 
> > The probing scheme is unchanged, since after trying the early platform
> > devices approach it appeared that the end result was no better than the
> > current one. The only clean solution relies either on changing how
> > secondaries are brought up in the kernel (later than now) or enable
> > early platform device registration through DT. Please check this
> > thread for the related discussion:
> > 
> > https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036542.html
> > 
> > The interface was adapted to regmap and again reverted to old driver for
> > the following reasons:
> > 
> > - Power down registers locking is hairy and requires arch spinlocks in
> >   the MCPM back end to work properly, normal spinlocks cannot be used
> > - Regmap adds unnecessary code to manage SPC since it is just a bunch of
> >   registers used to control power management flags, the overhead is just
> >   not worth it (talking about power down registers, not the vexpress config
> >   interface)
> > - The locking scheme behind regmap requires all registers in the map
> >   to be protected with the same lock, which is not exactly what we want
> >   here
> > - Given the reasons above, adding a regmap interface buys us nothing from
> >   a driver readability and maintainability perspective (again just talking
> >   about the power interface, a few registers) because for the SPC it would
> >   simply not be used
> > 
> > /drivers/mfd is probably not the right place for this code as it stands (but
> > probably will be when the entire driver, with DVFS and config interface, is
> > complete).
> Could you please elaborate on how will the SPC driver extend into an MFD
> driver?

Reading through the thread I noticed Nico explained details properly, I
was about to mention a possible solution to the directory issue but I am
pretty sure that what he did will turn out for the best.

Usually, or better, historically, these pieces of code that program
PMICs lived in arch/arm/mach-* directories and that's something we could
have done as well (create a static mapping and write some functions to
peek and poke a few registers), but we thought that it was not the proper
way to go.

On top of that, the SPC is part of a component whose register space maps
disparate functions (config interface for voltage, clocks, energy probes,
frequency scaling and power states management) and basically that's the
reason we struggled to partition it properly (with further complexity
implied by the way requests - config and frequency scaling - have to be
serialized).

I hope the end result is reasonable, and overall I think it was a debate
that was worth having.

Thank you,
Lorenzo

