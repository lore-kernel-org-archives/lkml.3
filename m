Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbbA0RyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:54:16 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:57835 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbbA0RyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:54:14 -0500
Date: Tue, 27 Jan 2015 17:53:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150127175359.GE11502@n2100.arm.linux.org.uk>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
 <20150126161454.GE28663@atomide.com>
 <201501261723.10505@pali>
 <20150126170323.GF28663@atomide.com>
 <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
 <20150127133739.GB25306@amd>
 <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501271014160.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:16:24AM -0500, Nicolas Pitre wrote:
> On Tue, 27 Jan 2015, Pavel Machek wrote:
> > (Note, that in 3.19 dts for n900 got too big, so we are actually
> > triggering old bugs. That means that this is a regression fix, and
> > should go in ASAP).
> 
> It is queued here:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8294/1

Irrespective of that patch, I commented on another thread (about adding
the serial number to DT):

| How about something a little more radical.
| 
| Rather than trying to squeeze various ATAGs into DT, why don't we add a
| standard ATAG to contain the DT and pass that through into the kernel.
| This is IMHO how we _should_ have done the ATAG compatibility from the
| start.
| 
| That means we could get rid of most of the libfdt in the decompressor,
| and instead resolve the differences in the kernel.

That would allow us to get rid of all the FDT compatibility code in the
decompressor, and when we encounter these special ATAGs, we can deal with
them in the kernel instead of having to mess around with the DT.  I'd
also assume (although I haven't checked) that it would be much easier to
add additional DT properties in the kernel environment, rather than in
the rather restrictive decompressor environment.

We'd need to be careful about how we deal with the atags vs DT.  I'd
suggest (as above) that we have a tag which points at the DT in
physical memory, and its size, and pre-scan the atag list for that.
When we find it, we kick off the DT based stuff as we would normally
do, and follow it with a parse of the atags.  This would cause the
atags to override whatever is in the DT, which afaics is the behaviour
that we actually want.

We could augment that with code to update DT too so that we can export
just the DT based information to kexec'd kernels.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
