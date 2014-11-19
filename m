Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaKSQlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:41:53 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55344 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaKSQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:41:52 -0500
Date: Wed, 19 Nov 2014 16:41:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
Message-ID: <20141119164138.GI4042@n2100.arm.linux.org.uk>
References: <20141118172146.3784.81151.stgit@buzz>
 <20141118173413.GB4042@n2100.arm.linux.org.uk>
 <546B8C64.3010904@samsung.com>
 <2041617.Kxhx5O4MMr@wuerfel>
 <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
 <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
 <20141119160747.GH4042@n2100.arm.linux.org.uk>
 <CAKv+Gu-kvmkhrptmaN0miM3c0K3ZOh4maTFXL=NpYTMi9Q83kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-kvmkhrptmaN0miM3c0K3ZOh4maTFXL=NpYTMi9Q83kA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:25:41PM +0100, Ard Biesheuvel wrote:
> On 19 November 2014 17:07, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Nov 19, 2014 at 05:02:40PM +0100, Ard Biesheuvel wrote:
> > Which is not a good idea either, because the compiler needs to know how
> > far away its own manually generated literal pool is from the instructions
> > which reference it.  The .ltorg statement can end up emitting any number
> > of literals at that point, which makes it indeterminant how many words
> > are contained within the asm() statement.
> >
> 
> That applies to any inline asm statement in general: the compiler
> assumes that the expanded size will not interfere with its ability to
> emit literals after the function's return instruction.
> Sometimes it will put a literal pool in the middle of the function if
> it is very large, and I am not sure if an inline asm by itself would
> ever trigger that heuristic to kick in.

The compiler works it out by counting the number of assembler delimiters
(iow, semicolons or newlines) in the asm() statement, and using that to
track how many instructions are present.

> > Yes, it isn't desirable to waste an entire data cache line per indirect
> > call like the original quote above, but I don't see a practical
> > alternative.
> 
> We could at least add some labels instead of doing explicit pc arithmetic, i.e.,
> 
> adr lr, 1f
> ldr pc, 0f
> 0: .long symbol
> 1:

Yes, but this doesn't get away from the performance impact of having one
word used in a D-cache line scattered throughout the code.  This is the
reason why I never looked at this as a serious option for kernel modules,
and decided to put the kernel modules below the kernel itself instead.

In older kernels, when we had the linking done by userspace insmod, I was
able to be much more clever in this regard - I was able to detect which
relocations were out of range, and I generated trampolines for each such
symbol.  What this relied upon was being able to parse the relocations
before allocating module space, so we knew what the maximum size of
trampolines needed for a particular module would be.

We don't have that luxury with the current approach - the earliest we get
to see the module is after the module space has been allocated, and the
module has been copied to that module.  That leaves no room to extend the
allocation for the trampolines.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
