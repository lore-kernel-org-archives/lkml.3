Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKQGxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:53:40 -0500
Received: from ozlabs.org ([103.22.144.67]:44066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaKQGxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:53:39 -0500
Message-ID: <1416207214.2826.3.camel@concordia>
Subject: Re: [PATCH] [powerpc] Fix Text randomization
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vineeth Vijayan <vvijayan@mvista.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Date: Mon, 17 Nov 2014 17:53:34 +1100
In-Reply-To: <1415956325-10124-1-git-send-email-vvijayan@mvista.com>
References: <1415956325-10124-1-git-send-email-vvijayan@mvista.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 14:42 +0530, Vineeth Vijayan wrote:
> Now there is no way to disable TEXT randomization on a PPC32/PPC64
> machine. Text randomization happens even in the case of "echo 0 >
> /proc/sys/kernel/randomize_va_space"
> 
> This happens due to the incorrect definition of ELF_ET_DYN_BASE
> at arch/powerpc/include/asm/elf.h
> 
> The function randomize_et_dyn is redundant and is removed.

The patch looks OK, but for the change log I was thinking something more like
this:


powerpc: Use generic PIE randomization

Back in 2009 we merged 501cb16d3cfd "Randomise PIEs", which added support for
randomizing PIE (Position Independent Executable) binaries.

That commit added randomize_et_dyn(), which correctly randomized the addresses,
but failed to honor PF_RANDOMIZE. That means it was not possible to disable PIE
randomization via the personality flag, or /proc/sys/kernel/randomize_va_space.

Since then there has been generic support for PIE randomization added to
binfmt_elf.c, selectable via ARCH_BINFMT_ELF_RANDOMIZE_PIE.

Enabling that allows us to drop randomize_et_dyn(), which means we start
honoring PF_RANDOMIZE correctly.

It also causes a fairly major change to how we layout PIE binaries.

Currently we will place the binary at 512MB-520MB for 32 bit binaries, or
512MB-1.5GB for 64 bit binaries, eg:

    $ cat /proc/$$/maps
    4e550000-4e580000 r-xp 00000000 08:02 129813       /bin/dash
    4e580000-4e590000 rw-p 00020000 08:02 129813       /bin/dash
    10014110000-10014140000 rw-p 00000000 00:00 0      [heap]
    3fffaa3f0000-3fffaa5a0000 r-xp 00000000 08:02 921  /lib/powerpc64le-linux-gnu/libc-2.19.so
    3fffaa5a0000-3fffaa5b0000 rw-p 001a0000 08:02 921  /lib/powerpc64le-linux-gnu/libc-2.19.so
    3fffaa5c0000-3fffaa5d0000 rw-p 00000000 00:00 0 
    3fffaa5d0000-3fffaa5f0000 r-xp 00000000 00:00 0    [vdso]
    3fffaa5f0000-3fffaa620000 r-xp 00000000 08:02 1246 /lib/powerpc64le-linux-gnu/ld-2.19.so
    3fffaa620000-3fffaa630000 rw-p 00020000 08:02 1246 /lib/powerpc64le-linux-gnu/ld-2.19.so
    3ffffc340000-3ffffc370000 rw-p 00000000 00:00 0    [stack]

With this commit applied we don't do any special randomisation for the binary,
and instead rely on mmap randomisation. This means the binary ends up at high
addresses, eg:

    $ cat /proc/$$/maps
    3fff99820000-3fff999d0000 r-xp 00000000 08:02 921    /lib/powerpc64le-linux-gnu/libc-2.19.so
    3fff999d0000-3fff999e0000 rw-p 001a0000 08:02 921    /lib/powerpc64le-linux-gnu/libc-2.19.so
    3fff999f0000-3fff99a00000 rw-p 00000000 00:00 0 
    3fff99a00000-3fff99a20000 r-xp 00000000 00:00 0      [vdso]
    3fff99a20000-3fff99a50000 r-xp 00000000 08:02 1246   /lib/powerpc64le-linux-gnu/ld-2.19.so
    3fff99a50000-3fff99a60000 rw-p 00020000 08:02 1246   /lib/powerpc64le-linux-gnu/ld-2.19.so
    3fff99a60000-3fff99a90000 r-xp 00000000 08:02 129813 /bin/dash
    3fff99a90000-3fff99aa0000 rw-p 00020000 08:02 129813 /bin/dash
    3fffc3de0000-3fffc3e10000 rw-p 00000000 00:00 0      [stack]
    3fffc55e0000-3fffc5610000 rw-p 00000000 00:00 0      [heap]

Although this should be OK, it's possible it might break badly written
binaries that make assumptions about the address space layout.


cheers


