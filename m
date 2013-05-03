Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742Ab3ECI0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:26:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56414 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3ECI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:26:45 -0400
X-Nat-Received: from [202.181.97.72]:55797 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367569594.28529
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
In-Reply-To: <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
Message-Id: <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 3 May 2013 17:26:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03052013 #9871762, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> I have booted such a configuration just fine. Please have a look at the
> kernel config that I send or send me yours.

OK. Here are complete steps to reproduce using QEMU on CentOS 6.4.

(1) Compile the kernel for x86_32 and run it on QEMU.

  $ cd /tmp/
  $ wget -O - https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/snapshot/next-20130426.tar.bz2 | tar -jxf -
  $ cd next-20130426/
  $ wget -O .config http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc8-next-20130422
  $ make -sj2 CONFIG_FRAME_POINTER=y CONFIG_DEBUG_INFO=y
  $ /usr/libexec/qemu-kvm -no-kvm -cpu pentium3 -m 512 -nographic -kernel arch/x86/boot/bzImage -S -gdb tcp::1234

(2) Attach gdb to the QEMU process from another terminal and continue.

  $ gdb /tmp/next-20130426/vmlinux
  (gdb) target remote :1234
  (gdb) c

    Press Ctrl-C after waiting for ten seconds.
    You will find that the kernel has panic()ed.

If one of CONFIG_DEBUG_SLAB/CONFIG_DEBUG_SPINLOCK/CONFIG_DEBUG_PAGEALLOC is
changed to n from the config above, the kernel boots fine. But the kernel
triggers oops for very large kmalloc allocations.

> 
> Here is a patch that restores the old behavior for SLAB
> 
> 
> 
> Subject: slab: Return NULL for oversized allocations
> 
> The inline path seems to have changed the SLAB behavior for very large
> kmalloc allocations. This patch restores the old behavior.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

I don't think this patch is sufficient. There are functions (e.g. kstrdup())
which call variant functions (e.g. kmalloc_track_caller()). I think we need to
check size at functions which determine index from size (e.g. kmalloc_slab()).

> 
> Index: linux/include/linux/slab_def.h
> ===================================================================
> --- linux.orig/include/linux/slab_def.h	2013-05-02 15:02:45.864728115 -0500
> +++ linux/include/linux/slab_def.h	2013-05-02 15:06:14.940474110 -0500
> @@ -126,6 +126,9 @@ static __always_inline void *kmalloc(siz
>  		if (!size)
>  			return ZERO_SIZE_PTR;
> 
> +		if (size >= KMALLOC_MAX_SIZE)
> +			return NULL;
> +

Why not (size > KMALLOC_MAX_SIZE) ?

>  		i = kmalloc_index(size);
> 
>  #ifdef CONFIG_ZONE_DMA
