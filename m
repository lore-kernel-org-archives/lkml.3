Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3BDWxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:53:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3BDWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:53:53 -0500
Date: Mon, 4 Feb 2013 22:53:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H?vard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130204225343.GD4503@ZenIV.linux.org.uk>
References: <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
 <20130204013111.GX4503@ZenIV.linux.org.uk>
 <20130204030221.GY4503@ZenIV.linux.org.uk>
 <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
 <20130204050550.GA4503@ZenIV.linux.org.uk>
 <CACiLriSguKWSfFfFGK99q1h+GLrfCSyh55xW8o67kOao3g5sWg@mail.gmail.com>
 <20130204153902.GC4503@ZenIV.linux.org.uk>
 <CACiLriQeYGGj5WZrf8H8z5N-AG1z_tDH7cXsd1J7ptpqYenPpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACiLriQeYGGj5WZrf8H8z5N-AG1z_tDH7cXsd1J7ptpqYenPpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:34:47AM -0800, H?vard Skinnemoen wrote:

> > So it will use the gap in case of 32/32/64/32; the first two calls will
> > take index 0 and 64bit (r12 and r11 resp.), the third will take 3 and 4
> > (r9:r8) and the fourth will take 2 (r10).
> 
> Oh, cool. I guess I am wrong then. Thanks a lot for taking the time to
> figure this out, and sorry I misled you.
> 
> If someone's got the toolchain installed (which I don't, sorry), it
> should be relatively straightforward to verify this by looking at the
> disassembly of a call to a function with a similar prototype.

Ho-hum...
	* no regular syscalls for 32bit host have more than 192 (6*32) bits
worth of arguments (sys_syscall() takes up to 7*32, but that weirdness is
neither common nor desirable - it's compatibility-only stuff).
	* for C ABI on avr32 we have the following (sorted by the total size)
32bit  -> r12
32bit 32bit  -> r12 r11
64bit  -> r10:r11
32bit 32bit 32bit  -> r12 r11 r10
32bit 64bit  -> r12 r10:r11
64bit 32bit  -> r10:r11 r12  
32bit 32bit 32bit 32bit  -> r12 r11 r10 r9
32bit 32bit 64bit  -> r12 r11 r9:r8
32bit 64bit 32bit  -> r12 r10:r11 r9
64bit 32bit 32bit  -> r10:r11 r12 r9   
64bit 64bit  -> r10:r11 r9:r8   
32bit 32bit 32bit 32bit 32bit  -> r12 r11 r10 r9 r8
32bit 32bit 32bit 64bit  -> r12 r11 r10 r9:r8
32bit 32bit 64bit 32bit  -> r12 r11 r9:r8 r10
32bit 64bit 32bit 32bit  -> r12 r10:r11 r9 r8
32bit 64bit 64bit  -> r12 r10:r11 r9:r8
64bit 32bit 32bit 32bit  -> r10:r11 r12 r9 r8
64bit 32bit 64bit  -> r10:r11 r12 r9:r8  
64bit 64bit 32bit  -> r10:r11 r9:r8 r12  
32bit 32bit 32bit 32bit 32bit 32bit  -> r12 r11 r10 r9 r8 s
32bit 32bit 32bit 32bit 64bit  -> r12 r11 r10 r9 s:s
32bit 32bit 32bit 64bit 32bit  -> r12 r11 r10 r9:r8 s
32bit 32bit 64bit 32bit 32bit  -> r12 r11 r9:r8 r10 s
32bit 32bit 64bit 64bit  -> r12 r11 r9:r8 s:s
32bit 64bit 32bit 32bit 32bit  -> r12 r10:r11 r9 r8 s
32bit 64bit 32bit 64bit  -> r12 r10:r11 r9 s:s 
32bit 64bit 64bit 32bit  -> r12 r10:r11 r9:r8 s
64bit 32bit 32bit 32bit 32bit  -> r10:r11 r12 r9 r8 s
64bit 32bit 32bit 64bit  -> r10:r11 r12 r9 s:s
64bit 32bit 64bit 32bit  -> r10:r11 r12 r9:r8 s
64bit 64bit 32bit 32bit  -> r10:r11 r9:r8 r12 s
64bit 64bit 64bit  -> r10:r11 r9:r8 s:s
	* syscall ABI coincides with C one if neither r8 nor stack is used.
	* if C ABI would use r8 but not stack, syscall one uses r5 instead
of r8.
	* plain SYSCALL_DEFINE6 syscalls have
32bit 32bit 32bit 32bit 32bit 32bit  -> r12 r11 r10 r9 r5 r3
At least in one case the wrapper is missing for a wired syscall - sys_futex
is used as-is.
	* sync_file_range(2) is wired as
32bit 64bit 64bit 32bit  -> r12 r10:r11 r9:r5 r3
	* fadvise64_64(2) is missing a wrapper; same arguments as for
sync_file_range(), presumably with the same calling conventions
	* fanotify_mark(2) is not wired; presumably should be
32bit 32bit 64bit 32bit 32bit  -> r12 r11 r9:r5 r10 r3
	* sync_file_range2(2) (which is not going to be wired) and fallocate(2)
(which probably will) have the same argument types; calling conventions should
probably be something like
32bit 32bit 64bit 64bit  -> r12 r11 r9:r5 ?:?
libc function is going to have arguments in r12, r11, r9:r8 and in two
32bit words on stack, so libc-side glue should be
	r5 = r8
	r8 = __NR_fallocate
	r<something> = lower 32 bits of 'len' (sits on stack)
	r<something else> = upper 32 bits of 'len' (sits on stack)
Looks like it ought to be r10 and r3, if we want to keep the same set
of registers?

There are several argument type combinations that are not used at the moment,
but migth appear in the future; ones that have only one word passed on stack
should probably go the same way we deal with the SYSCALL_DEFINE6 ones, but
ones that spill *two* words on stack are really interesting.  In addition to
fallocate(2) [gap in r10, two words on stack], we have
32bit 32bit 32bit 32bit 64bit
32bit 64bit 32bit 64bit
64bit 32bit 32bit 64bit [gap in r8, two words on stack] and
64bit 64bit 64bit [gap in r12, two words on stack]

What calling conventions would we want for those?
