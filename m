Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CGWrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:47:45 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59459 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3CGWro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:47:44 -0500
Date: Thu, 07 Mar 2013 16:47:38 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
In-Reply-To: <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
	(from akpm@linux-foundation.org on Thu Mar  7 15:35:42 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362696458.6812.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 03:35:42 PM, Andrew Morton wrote:
> On Thu, 7 Mar 2013 14:50:23 -0500 Paul Gortmaker  
> <paul.gortmaker@windriver.com> wrote:
> 
> > This brings up a recurring question.  I was tempted to just go make
> > CONFIG_EARLY_PRINTK depend on CONFIG_PRINTK, but lately I've faced
> > pushback when trying to "fix" things like seeing ARM OMAP USB  
> options
> > for an x86 build[1], and GOLDFISH virt drivers being offered even
> > when the end user already said no to GOLDFISH[2].
> >
> > Do we want to use dependencies to reflect the real world layout of
> > platforms/systems, or do we want to go the minimal dependency
> > approach, where we are building sparc specific drivers on mips just
> > because we can?
> >
> > I think the former is better from a user specific point of view, as
> > the maze of Kconfig is better as a tree topology with branches that
> > have clear dependencies that exclude them, versus it being a flat
> > monolithic space where anything can select anything.
> >
> > Arguments I've heard for the latter seem to be developer centric
> > (i.e forcing wider build coverage on the population as a whole, etc)
> 
> For me personally, I really really want good compilation coverage.  It
> drives me bats when I merge a patch but have to jump through a series
> of hoops (such as not having the appropriate cross-compiler!) to be
> able to build the thing.

This doesn't solve everything, but:

http://landley.net/aboriginal/bin

cross-compiler-*.tar.bz2 is statically linked cross compilers for a lot  
of different architectures. Add the "bin" subdirectory to your path and  
CROSS_COMPILE=prefix- where prefix is whatever the * was (and the  
trailing - is important).

system-image-*.tar.bz2 is bootable system images with native  
development tools (./run-emulator.sh and ./dev-environment.sh are  
wrapper scripts to boot qemu with all the right arguments), for the  
same set of architectures. (There are a couple I have cross compilers  
for but insufficient board support in qemu as of yet. Working on it.  
I'm also working on adding more targets, but it's multitasked with  
several other projects...)

Note that if you have distccd installed on the host and the cross  
compiler is in your $PATH, ./dev-environment.sh should hook up distcc  
to the cross compiler through qemu's emulated network.

So at least _build_ coverage and basic "it booted to a shell prompt"  
smoke test coverage are reasonably straightforward. (I have automated  
build control images that build linux from scratch under the result,  
hence wanting distcc to make it slightly less slow.)

Driver testing for strange hardware continues to require strange  
hardware, though.

(If you're curious, http://landley.net/aboriginal/about.html goes on  
about it.)

Rob