Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaEOTSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:18:40 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55272 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaEOTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:18:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Thu, 15 May 2014 21:18:29 +0200
Message-ID: <4706636.rTYoqSXXOR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1405151748430.3155@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <5374F56A.3090406@codesourcery.com> <Pine.LNX.4.64.1405151748430.3155@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SvwupAPvMUdwXJ/A0ZYDUBwiMPjxfI0EQftlPfE8yde
 L4jGvvPDwZnDdhpQ2FqN/dvp7+Oc3CV6FVN6skB+Pny6abq1rV
 UsShWSJnPa3w9L2Pf5UzF0GAJ7KS3fwUBF35t0YdyHHresna+7
 g8Xd0lyeTEIj0jCSR2yZkCa+q2RtueSgAthdwHj41Ymoxq+iSV
 goXE2nhhvXQGPaeDc9hM12P9uhyUNO08QowpUs+jz9LdAWijp0
 +D6csHc4uCankUqa8mvSIBhjeNdrxpsXkV5035xrdRWX89GvGT
 zWypAswmcbndtU6HXQSL8lqXWn0ua6HUIh7vx0go+c8sE0Z34W
 x648TlM+le3PpfsIWOSk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 18:01:37 Joseph S. Myers wrote:
> On Thu, 15 May 2014, Chung-Lin Tang wrote:
> 
> > > c) glibc may or may not provide a way for applications to use
> > >    the extended interfaces without a user space ABI break. My
> > >    impression so far is that this is going to be too hard and
> > >    it won't be done, but this is for the glibc developers to
> > >    determine.
> > 
> > glibc does version its exported symbols, so provided new/old syscalls
> > are both provided, haveing a new version of a routine (using 64-bit
> > time_t and new syscall interfaces) and the old compat routine co-exist
> > should be possible. Of course, old binaries may still not be saved when
> > 2038 arrives.

How would that work for ioctl? There are a lot of device drivers that
have data structure with time_t or struct timespec in them.

> You could do it with symbol versioning, though my guess would be that it 
> would be natural to provide _TIME_BITS like _FILE_OFFSET_BITS (with the 
> combination _TIME_BITS=64, _FILE_OFFSET_BITS=32 not being supported at 
> all) and then later transition the default.  (Discussion of the 
> possibility of moving the default to _FILE_OFFSET_BITS=64 suggested that 
> in practice most libraries in distributions where this affects the ABI are 
> already built that way, though noone has followed up on that discussion to 
> try to reach a consensus that we have enough evidence to change the 
> default now.  There are a couple of issues with the way 
> _FILE_OFFSET_BITS=64 is implemented that should be avoided in any 
> implementation of _TIME_BITS=64: (a) _FILE_OFFSET_BITS=64 maps functions 
> to corresponding *64 functions in the user's namespace, when it should use 
> reserved-namespace names; (b) it's not a no-op for 64-bit platforms - it 
> still remaps function names and types.  So _TIME_BITS=64 should only map 
> to reserved-namespace names, and not do any remapping at all on platforms 
> where time_t is already 64-bit.)

Earlier in the thread there seemed to be a rough consensus that
_TIME_BITS=64 wouldn't be a good idea because we wouldn't get everything
changed to use it. For _FILE_OFFSET_BITS=64 that's ok because most
user space doesn't ever want to deal with large files.

Can you elaborate on how the switch to the new default would work?
If it's easy, why hasn't it been done for _FILE_OFFSET_BITS already
and what's stopping us from changing the default as soon as the interfaces
are there? If it's hard, what would need to happen before the default
time_t can be set?

> Obviously 64-bit time_t syscalls would be an appropriately narrow set of 
> syscalls like those in the generic ABI (so glibc would implement stat for 
> _TIME_BITS=64 using fstatat64_time64 or whatever the syscall is called, 
> just as the stat functions for generic ABI architectures are implemented 
> with newfstatat / fstatat64 rather than lots of separate syscalls.

This assumes that we'd leave the kernel time_t/timespec/timeval using 'long'
and introduce a new timespec64 using a signed 64-bit type, rather than
changing the kernel headers to the new syscalls and data structures with
new names for the existing ones, right?

	Arnd
