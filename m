Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaEAOdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:33:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26141 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaEAOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:33:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2kbj/Ot4DdiUgJSkVMbCOAgr9Qf0pX/U=
X-DKIM: OpenDKIM Filter v2.0.1 titan B4A07568C77
Date: Thu, 1 May 2014 10:33:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>
Subject: Re: [PATCH] random: Add "initialized" variable to proc
Message-ID: <20140501143311.GR28159@titan.lakedaemon.net>
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
 <20140428214112.GC7857@thunk.org>
 <535FE68C.8060002@redhat.com>
 <20140429182610.GA19325@thunk.org>
 <53616293.3080308@mit.edu>
 <20140501020627.GA25248@thunk.org>
 <FDF79354-1CD5-4DFF-AC5A-32D8C00CFCB7@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FDF79354-1CD5-4DFF-AC5A-32D8C00CFCB7@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:37:00PM -0700, H. Peter Anvin wrote:
> 
> > On Apr 30, 2014, at 19:06, "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> >> On Wed, Apr 30, 2014 at 01:52:35PM -0700, Andy Lutomirski wrote:
> >> 
> >> 1. It simply doesn't work on my system.  In particular, it never returns
> >> entropy.  It just blocks forever.
> > 
> > Why?  Is this a bug in qemu?  The host OS?  The guest OS?  It is qemu
> > trying to use /dev/random instead of /dev/urandom?  Any thing else?
> > 
> >> 3. There should be a way to provide some entropy-free cryptographically
> >> secure data, too.  Regardless of the speed of the hosts's /dev/random,
> >> the guest should start with at least 256 bits of cryptographically
> >> secure seed material IMO.
> > 
> > Well, the simplest way to do this is to pass it in via the command
> > line, and then have the the kernel make sure it gets obscured so it's
> > not exposed via /proc/cmdline.
> > 
> > Otherwise we would have to define an extension where we pass 32 bytes
> > or so after the boot command line.  But the downside of doing that is
> > we would have to modify every single architecture to define where
> > those 32 bytes could be found.
> > 
> > Aside from passing it on the command line as being a bit grotty, the
> > other big problem this is that some architectures only have 256 bytes
> > of command line, and if we use a base 64 encoding, 256 bits will take
> > 43 characters.  Not a problem on x86, and it seems rather unlikely
> > that people would want to virtualize a m68k or avr32 CPU.  It just
> > feels really unclean.
> > 
> > I've cc'ed Peter Anvin for his opinion about extending Linux boot
> > parameter protocol.  I agree it would be a lot simpler and easier to
> > enable things like Kernel ASLR with real randomness on guest OS's if
> > we didn't have to erect the whole virtio-pci infrastructure during
> > early boot.  :-)
> 
> To do something cross-arch putting it in memory and having something
> point to it is probably easiest, but again, with an in-VM boot loader
> the command line rather sucks.  This then becomes a matter for device
> tree/ACPI with all that entails.

I drafted an idea for how to improve early-boot randomness on ARM [1] a
ways back.  Requoting:

"""
On Wednesday 12 February 2014 13:45:21 Jason Cooper wrote:
> On Wed, Feb 12, 2014 at 07:17:41PM +0100, Arnd Bergmann wrote:
> > On Wednesday 12 February 2014 12:45:54 Jason Cooper wrote:
> > > I brought this up at last weeks devicetree irc meeting.  My goal
> > > is to provide early randomness for kaslr on ARM.  Currently, my
> > > idea is modify the init script to save an additional random seed
> > > from /dev/urandom to /boot/random-seed.
> > > 
> > > The bootloader would then load this file into ram, and pass the
> > > address/size to the kernel either via dt, or commandline.  kaslr
> > > (run in the decompressor) would consume some of this randomness,
> > > and then random.c would consume the rest in a non-crediting
> > > initialization.
> > 
> > I like the idea, but wouldn't it be easier to pass actual random
> > data using DT, rather than the address/size?
> 
> I thought about that at first, but that requires either that the
> bootloader be upgraded to insert the data, or that userspace is
> modifying the dtb at least twice per boot.
> 
> I chose address/size to facilitate modifying existing/fielded devices.
> The user could modify the dtb once, and modify the bootloader
> environment to load X amount to Y address.  As a fallback, it could be
> expressed on the commandline for non-DT bootloaders.

Ah, so you are interested in boot loaders that can be scripted to do
what you had in mind but cannot be scripted to add or modify a DT
property. I hadn't considered that, but you are probably right that
this is at least 90% of the systems you'd find in the wild today.
[...]
	Arnd
"""

I'm not sure how it would play out on other arch's, or with ACPI.  But
if there's interest, I could try to spend some cycles in the next few
weeks to create an RFC.

thx,

Jason.

[1] http://marc.info/?l=linux-kernel&m=139223237824952&w=2
