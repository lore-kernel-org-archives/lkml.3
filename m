Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbbA0Su3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:50:29 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:62421 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625AbbA0Su0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:50:26 -0500
Date: Tue, 27 Jan 2015 13:50:22 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
In-Reply-To: <20150127175359.GE11502@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1501271309450.1322@knanqh.ubzr>
References: <201501232239.55801@pali> <201501232336.36187@pali> <20150126161454.GE28663@atomide.com> <201501261723.10505@pali> <20150126170323.GF28663@atomide.com> <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr> <20150127133739.GB25306@amd>
 <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr> <20150127175359.GE11502@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:

> On Tue, Jan 27, 2015 at 10:16:24AM -0500, Nicolas Pitre wrote:
> > On Tue, 27 Jan 2015, Pavel Machek wrote:
> > > (Note, that in 3.19 dts for n900 got too big, so we are actually
> > > triggering old bugs. That means that this is a regression fix, and
> > > should go in ASAP).
> > 
> > It is queued here:
> > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8294/1
> 
> Irrespective of that patch, I commented on another thread (about adding
> the serial number to DT):
> 
> | How about something a little more radical.
> | 
> | Rather than trying to squeeze various ATAGs into DT, why don't we add a
> | standard ATAG to contain the DT and pass that through into the kernel.
> | This is IMHO how we _should_ have done the ATAG compatibility from the
> | start.
> | 
> | That means we could get rid of most of the libfdt in the decompressor,
> | and instead resolve the differences in the kernel.
> 
> That would allow us to get rid of all the FDT compatibility code in the
> decompressor, and when we encounter these special ATAGs, we can deal with
> them in the kernel instead of having to mess around with the DT.  I'd
> also assume (although I haven't checked) that it would be much easier to
> add additional DT properties in the kernel environment, rather than in
> the rather restrictive decompressor environment.

Well...

I was initially against any ATAG-to-DT compatibility at all.  IMHO the 
"right" solution is to update the bootloader.

However people complained that updating the bootloader wasn't possible. 
I therefore suggested they go with a shim layer I termed the "impedance 
matcher" acting like an intermediate boot stage converting their (often 
unofficial and out-of-tree) ATAGs into proper DT nodes.  Some people did 
exactly that and it works wonderfully for them. It also works 
wonderfully for kernel maintenance as the platform specific tweaks are 
kept out of the kernel tree.

Still, that wasn't good enough for some cases as the move to DT 
regressed some platforms that just used to work before.  Concatenating a 
DTB to zImage was tolerable but installing an additional shim layer was 
too much.  Hence the ATAG-to-DT compat code in the decompressor.  This 
was meant to smooth things around the transition to DT, etc.  After all, 
those devices with non-replaceable bootloaders where shim layers are not 
possible should get out of commission eventually?

> We'd need to be careful about how we deal with the atags vs DT.  I'd
> suggest (as above) that we have a tag which points at the DT in
> physical memory, and its size, and pre-scan the atag list for that.
> When we find it, we kick off the DT based stuff as we would normally
> do, and follow it with a parse of the atags.  This would cause the
> atags to override whatever is in the DT, which afaics is the behaviour
> that we actually want.

Maybe.  However that would be yet another scheme for supporting legacy 
platforms with locked bootloaders.  I really think we have enough of 
them already and I'd much prefer if we started _removing_ them not 
creating additional ones.  The ATAG-to-DT code in the bootloader is 
still rather small and it works quite well, and it allows for 
configuring out ATAG support out of the kernel entirely.  It should be 
sufficient for all the official (e.g. upstream) ATAGs already.  If 
that's not good enough then people should consider the impedance matcher 
approach.

> We could augment that with code to update DT too so that we can export
> just the DT based information to kexec'd kernels.

That should already be the case, no?


Nicolas
