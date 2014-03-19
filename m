Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaCSUtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:49:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49233 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbaCSUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:49:41 -0400
Date: Wed, 19 Mar 2014 21:49:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Raghu Gandham <Raghu.Gandham@imgtec.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] Input: i8042-io - Exclude mips platforms when
 allocating/deallocating IO regions.
Message-ID: <20140319204931.GI17197@linux-mips.org>
References: <1390676514-30880-1-git-send-email-raghu.gandham@imgtec.com>
 <20140126214952.GD18840@core.coreip.homeip.net>
 <E2EE47005FA75F44B80E1019FDD2EBBB6E38B06D@BADAG02.ba.imgtec.org>
 <20140127065638.GB11945@core.coreip.homeip.net>
 <20140127202435.GA589@drone.musicnaut.iki.fi>
 <E2EE47005FA75F44B80E1019FDD2EBBB6E394CB2@BADAG02.ba.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2EE47005FA75F44B80E1019FDD2EBBB6E394CB2@BADAG02.ba.imgtec.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:25:39AM +0000, Raghu Gandham wrote:
> Date:   Tue, 28 Jan 2014 06:25:39 +0000
> From: Raghu Gandham <Raghu.Gandham@imgtec.com>
> To: Aaro Koskinen <aaro.koskinen@iki.fi>, Dmitry Torokhov
>  <dmitry.torokhov@gmail.com>
> CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
>  "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Subject: RE: [PATCH] Input: i8042-io - Exclude mips platforms when
>  allocating/deallocating IO regions.
> Content-Type: text/plain; charset="us-ascii"
> 
> Hi Aaro,
> 
> > 
> > On Sun, Jan 26, 2014 at 10:56:38PM -0800, Dmitry Torokhov wrote:
> > > On Mon, Jan 27, 2014 at 12:32:36AM +0000, Raghu Gandham wrote:
> > > > > On Sat, Jan 25, 2014 at 11:01:54AM -0800, Raghu Gandham wrote:
> > > > > > The standard IO regions are already reserved by the platform
> > > > > > code on most MIPS devices(malta, cobalt, sni). The Commit
> > > > > > 197a1e96c8be5b6005145af3a4c0e45e2d651444
> > > > > > ("Input: i8042-io - fix up region handling on MIPS") introduced
> > > > > > a bug on these MIPS platforms causing i8042 driver to fail when
> > > > > > trying to reserve IO ports.
> > > > > > Prior to the above mentioned commit request_region is skipped on
> > > > > > MIPS but release_region is called.
> > > > > >
> > > > > > This patch reverts commit
> > > > > > 197a1e96c8be5b6005145af3a4c0e45e2d651444
> > > > > > and also avoids calling release_region for MIPS.
> > > > >
> > > > > The problem is that IO regions are reserved on _most_, but not
> > > > > _all_ devices.
> > > > > MIPS should figure out what they want to do with i8042 registers
> > > > > and be consistent on all devices.
> > > >
> > > > Please examine the attached patch which went upstream in April of 2004.
> > > > Since then it had been a convention not to call request_region
> > > > routine in
> > > > i8042 for MIPS. The attached patch had a glitch that it guarded
> > > > request_region in i8042-io.h but skipped guarding release_region in
> > > > i8042-io.h. I believe that the issue Aaro saw was due to this
> > > > glitch. Below is the error quoted in Aaro's commit message.
> > > >
> > > >     [    2.112000] Trying to free nonexistent resource <0000000000000060-
> > 000000000000006f>
> > > >
> > > > My patch reinstates the convention followed on MIPS devices along
> > > > with fixing Aaro's issue.
> > >
> > > I assume that Aaro did test his patch and on his box request_region()
> > > succeeds. That would indicate that various MIPS sub-arches still not
> > > settled on the topic.
> > 
> > request_region() succeeds on Loongson and OCTEON.
> 
> This would mean that before your patch in oct of 2012, Loongson and Octeon 
> were not reserving the IO space for i8042.
> 
> > 
> > On OCTEONs without PCI, request_region() will fail which is correct as there
> > is no I/O space.
> > 
> > I wasn't aware of that 2004 patch (it pre-dates GIT history of mainline Linux).
> > Why the regions are already reserved by the platform code?
> 
> The only information I have is the comment before request_region in i8042-io.h that
> touching data register on some platforms is flaky.  If your patch was primarily aimed at
> addressing the error message from release_region, the current patch I uploaded should
> also take care of it too. 

I think the patch (http://patchwork.linux-mips.org/patch/6419/) should be
applied.  The argumentation for reserving ports in the platform code are
the same as on x86 - touch the registers and bad things may happen.  This
is because a fair number of older MIPS platforms were based on x86 chipsets
or at least are using very similar designs.

The fact that on certain platforms such as Loongson, some Octeon systems
and others the request_region() call to reserve the keyboard call succeeds
is by accident not design.

I wish i8042.c was a real platform driver, not using platform_create_bundle.
That would leave a natural place in the arch/platform code to deal with
I/O port allocation and platform_device creation, as necessary for a
platform.

  Ralf
