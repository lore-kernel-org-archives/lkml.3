Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaEOUKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:10:16 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58831 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaEOUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:10:14 -0400
Date: Thu, 15 May 2014 20:10:05 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Arnd Bergmann <arnd@arndb.de>
CC: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <4706636.rTYoqSXXOR@wuerfel>
Message-ID: <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <5374F56A.3090406@codesourcery.com> <Pine.LNX.4.64.1405151748430.3155@digraph.polyomino.org.uk>
 <4706636.rTYoqSXXOR@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 15 May 2014 20:10:08.0875 (UTC) FILETIME=[AB9053B0:01CF7079]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Arnd Bergmann wrote:

> Earlier in the thread there seemed to be a rough consensus that
> _TIME_BITS=64 wouldn't be a good idea because we wouldn't get everything
> changed to use it. For _FILE_OFFSET_BITS=64 that's ok because most
> user space doesn't ever want to deal with large files.

Well, I'm coming into this in the middle since it isn't on linux-api and 
noone has tried to work out on libc-alpha what things should look like 
from the glibc side.  _TIME_BITS seemed to make sense when I thought about 
this previously, however.

> Can you elaborate on how the switch to the new default would work?

At some appropriate release (probably after _TIME_BITS=64 is widely used 
in distributions), the glibc headers would change so that _TIME_BITS=64 is 
the default and _TIME_BITS=32 can be set to get the old interfaces.  At 
some later point _TIME_BITS=32 API support might be removed, leaving the 
old symbols as compat symbols for existing binaries.

> If it's easy, why hasn't it been done for _FILE_OFFSET_BITS already
> and what's stopping us from changing the default as soon as the interfaces
> are there? If it's hard, what would need to happen before the default
> time_t can be set?

The distribution side of the change for _FILE_OFFSET_BITS (i.e., moving to 
building libraries that way so a glibc change to the default wouldn't 
cause issues for other libraries' ABIs) has gradually been done.  The 
discussion in March on libc-alpha about changing the default tailed off.  
This is something that needs someone to take the lead with a *careful and 
detailed analysis of the information from the previous discussion* in 
order to present a properly reasoned proposal for a change to the default 
- not scattergun patches, not patches with brief or no analysis of the 
environment in which glibc is used, not dismissing concerns, but a 
properly reasoned argument for why the change should be made, along with 
details of how distributions can determine whether ABI issues would arise 
from rebuilding a particular library against newer glibc.

> > Obviously 64-bit time_t syscalls would be an appropriately narrow set of 
> > syscalls like those in the generic ABI (so glibc would implement stat for 
> > _TIME_BITS=64 using fstatat64_time64 or whatever the syscall is called, 
> > just as the stat functions for generic ABI architectures are implemented 
> > with newfstatat / fstatat64 rather than lots of separate syscalls.
> 
> This assumes that we'd leave the kernel time_t/timespec/timeval using 'long'
> and introduce a new timespec64 using a signed 64-bit type, rather than
> changing the kernel headers to the new syscalls and data structures with
> new names for the existing ones, right?

Yes.  I consider it simply common sense that new kernel headers should 
continue to work with much older glibc, meaning that the API (syscall 
names etc.) presented by the headers from headers_install should not 
change incompatibly.

(64-bit type only for time_t, of course.  There's no need for a 64-bit 
type for nanoseconds and tv_nsec is explicitly "long" in POSIX, meaning 
that if the kernel uses a 64-bit type for nanoseconds on systems where 
"long" is 32-bit in userspace, either it needs to treat the high word as 
padding or glibc needs to wrap all interfaces passing a struct timespec 
into the kernel so they clear the padding field.  There's even less need 
for a 64-bit type for microseconds.)

-- 
Joseph S. Myers
joseph@codesourcery.com
