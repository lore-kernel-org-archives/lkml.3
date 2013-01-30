Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3A3N6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:58:19 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42517 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3A3N6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:58:16 -0500
Date: Wed, 30 Jan 2013 07:58:09 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Kernel failing to boot when compressed with bzip2
To: Thomas Capricelli <orzel@freehackers.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <50FC67B9.7080600@freehackers.org> (from orzel@freehackers.org
	on Sun Jan 20 15:55:05 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1359554289.32505.58@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has there been any follow-up on this? I've had this flagged to follow  
replies to the thread for a while, but didn't see any.

On 01/20/2013 03:55:05 PM, Thomas Capricelli wrote:
> 1st problem
> Since around September 2012, i have tried to compile my kernel 3.6.x
> with gcc-4.7.

I can't do anything about the gcc guys going insane, switching the  
license to CDDL 2, rewriting their code in C++, and losing all the  
pragmatists to other compiler projects.

Sorry the FSF is nuts, EGCS 2 is apparently called "LLVM". (Or PCC.  Or  
possibly Open64. Yeah, we might be better off with just one, but the  
leading alternative is also in C++, so unification behind it isn't  
quite happening yet.)

> So my guess is that there's something badly broken in the bzip2 kernel
> decompressing code.. ? There's both a regression between kernel 3.6  
> and
> 3.7, and a problem with gcc-4.7.

This is the bit I'm interested in: I wrote the original bunzip2 code  
the kernel wound up sucking in (lib/decompress_bunzip2.c "it Came From  
BusyBox!" *dramatic*chord*), and it Worked For Me (tm).

According to git log it hasn't been touched in-kernel since 2011, so  
something subtle's going on. I just built an i686 kernel with it...

(Wait for slow netbook to catch up...)

   BZIP2   arch/x86/boot/compressed/vmlinux.bin.bz2

Wheee. Plug that kernel into my Aboriginal Linux project and use  
run-emulator.sh to boot it under qemu-system-i386, and:

   VFS: Mounted root (squashfs filesystem) readonly on device 3:0.
   Freeing unused kernel memory: 216k freed
   mount: mounting /dev/hdc on /mnt failed: No medium found
   Not using distcc.
   Type exit when done.
   (i686:1) /home # e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex,  
Flow Control: RX

That's a shell prompt. (Well, it's a shell prompt with the ethernet  
driver barfing on it, but that's just delayed driver loading.  
Parallelism! It's what's for dinner.)

Worked For Me. I note that I built with gcc 4.2.1 and binutils 2.17  
(the last GPLv2 releases), and it's for i686, and it was with current  
-git (as of yesterday), and I'm probably facing a different direction  
than you are relative to magnetic north...

Need more info to reproduce this, sorry.

> Here are some more information, just ask if you need some more. I can
> even do some testing, but you'll need to cc: me as i'm not anymore on  
> lkml.

I really, really, really miss kernel-traffic. And Jon Masters isn't  
doing the kernel podcast anymore since he eloped with an Arm board. (As  
soon as he the debug results back they had a quiet, tasteful ceremony  
in front of a compiler and a linker.)

> * the cpu is "AMD Athlon(tm) II X4 620 Processor" as reported by
> /proc/cpuinfo
> * CONFIG_DECOMPRESS_BZIP2=y was set on all my tests (not sure it's  
> relevant)
> * the last 3.6 kernel tested was 3.6.11
> * 4.7 kernels tested were 4.7.1, 4.7.2, and 4.7.3
> * the computer will reboot really fast just after the kernel kprinted
> "Decompressing Linux", nothing is kprinted after this.

95% chance it's a bad memory access. If the kernel does a bad memory  
access before the page fault handler is set up the interrupt turns into  
a reboot, and during initial kernel decompression we haven't so much  
got page tables set up as a couple TLB entries held in place with twist  
ties. (The code to do a better job is in the compressed payload, the  
setup code gets thrown away so it's as simple as possible. Occasionally  
simpler, but I don't think that's the case here.)

It's also got a tiny, fixed size stack. My first wild-ass-guess is your  
compiler's decided your C code really needs exception handling because  
it can't tell the difference between C and C++ (reasoning: a mud pie  
contains a glass of water, therefore mud pies are an excellent  
beverage), and is crapping stuff on the stack.

That probably isn't it.

Rob