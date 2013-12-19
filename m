Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3LSPCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:02:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3LSPCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:02:23 -0500
Date: Thu, 19 Dec 2013 16:02:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Timo Teras <timo.teras@iki.fi>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
In-Reply-To: <20131219164251.3ebd124a@vostro>
Message-ID: <alpine.LNX.2.00.1312191558140.11852@pobox.suse.cz>
References: <1380698395-5784-1-git-send-email-timo.teras@iki.fi> <alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz> <20131219164251.3ebd124a@vostro>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Timo Teras wrote:

> 5756c000-57570000 rw-p 00000000 00:00 0 
> 57570000-575dd000 r-xp 00000000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
> 575dd000-575de000 r--p 0006c000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
> 575de000-575df000 rw-p 0006d000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
> 575df000-575e5000 rw-p 00000000 00:00 0 
> 575e5000-575f5000 r-xp 00000000 00:0f 2038       /lib/libm-0.9.33.2-git.so
> 575f5000-575f6000 r--p 0000f000 00:0f 2038       /lib/libm-0.9.33.2-git.so
> 575f6000-575f7000 rw-p 00010000 00:0f 2038       /lib/libm-0.9.33.2-git.so
> 575f7000-575fd000 r-xp 00000000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
> 575fd000-575fe000 r--p 00005000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
> 575fe000-57610000 rw-p 00000000 00:00 0 
> 57611000-57613000 rw-p 00000000 00:00 0 
> 57613000-57614000 r-xp 00000000 00:00 0          [vdso]
> 57614000-5761e000 r-xp 00000000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
> 5761e000-5761f000 r--p 00009000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
> 5761f000-57620000 rw-p 0000a000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
> 57620000-57708000 r-xp 00000000 00:0f 234487046  /root/busybox
> 57708000-5770a000 rw-p 000e8000 00:0f 234487046  /root/busybox
> 5770a000-5770c000 rw-p 00000000 00:00 0          [heap]
> 5ffdf000-60000000 rw-p 00000000 00:00 0          [stack]
> b7570000-b75dd000 r-xp 00000000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
> b75e5000-b75f5000 r-xp 00000000 00:0f 2038       /lib/libm-0.9.33.2-git.so
> b75f7000-b75fd000 r-xp 00000000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
> b7613000-b7614000 r-xp 00000000 00:00 0          [vdso]
> b7614000-b761e000 r-xp 00000000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
> b7620000-b7708000 r-xp 00000000 00:0f 234487046  /root/busybox
> 
> As you see, the main executable is mapped 57620000-57708000 and
> 57708000-5770a000. Heap follow immediately after that
> 5770a000-5770c000 followed by anything mmaped after it (stack or some
> other libraries). Heap can grow only up to 5ffdf000 meaning the
> application is limited to 140 megs or so in this instance. This limit
> can go much lower depending how the randomization went. And even 140
> megs is very little for big apps.

Right. And why is that a problem? 

Area marked [heap] is basically just an area reserved for brk() calls. 
There is no guarantee how big this area is going to be, there is always 
going to be some mapping getting in the way, that'll prevent it from 
growing indefinitely, and the userspace allocator will have to switch from 
using brk() to mmap() instead.

Glibc is doing this properly, and any allocator that wants to make sure to 
be able to make use of as much virtual address space as possible has 
either give up on brk() completely, or at least switch from brk() to 
mmap() when brk() reaches first mapping.

So what is the real problem again (i.e. the actual symptoms), please? Is 
it that your userspace memory allocator doesn't use mmap() for allocations 
at all?

Thanks,

-- 
Jiri Kosina
SUSE Labs
