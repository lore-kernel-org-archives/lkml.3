Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3K0AoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:44:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3K0AoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:44:18 -0500
Date: Tue, 26 Nov 2013 16:44:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: ARM: nommu: Unable to allocate RAM for process text/data, errno
 12
Message-Id: <20131126164417.9df88075f9ad394679bb60cb@linux-foundation.org>
In-Reply-To: <1385458169.6721.2.camel@phoenix>
References: <1385458169.6721.2.camel@phoenix>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 17:29:29 +0800 Axel Lin <axel.lin@ingics.com> wrote:

> Hi,
> I got below error messages while starting mdev (busybox).
> 
> ...
>
> [  108.537109] chmod: page allocation failure: order:8, mode:0xd0

It wants to allocate 2^8 physically contiguous pages!

> [  108.543945] CPU: 0 PID: 47 Comm: chmod Not tainted 3.13.0-rc1-00170-g1bab531-dirty #1940
> [  108.580078] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
> [  108.592773] [<0000ae58>] (show_stack+0x10/0x14) from [<00050010>] (warn_alloc_failed+0xf8/0x128)
> [  108.605468] [<00050010>] (warn_alloc_failed+0xf8/0x128) from [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4)
> [  108.620117] [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4) from [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0)
> [  108.633789] [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0) from [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c)
> [  108.647460] [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c) from [<0009e6e8>] (load_flat_binary+0x38c/0xa0c)
> [  108.660156] [<0009e6e8>] (load_flat_binary+0x38c/0xa0c) from [<0006bc40>] (search_binary_handler+0x4c/0xa4)
> [  108.676757] [<0006bc40>] (search_binary_handler+0x4c/0xa4) from [<0006bfc8>] (do_execve+0x330/0x4e8)
> [  108.689453] [<0006bfc8>] (do_execve+0x330/0x4e8) from [<0006c3c4>] (SyS_execve+0x30/0x44)
> [  108.701171] [<0006c3c4>] (SyS_execve+0x30/0x44) from [<00008f40>] (ret_fast_syscall+0x0/0x44)

So the binfmt_flat driver is allocating memory into which to load
mdev's text (I assume it's the text).

> Why it got page allocation failure?

Because 256 physically contiguous free pages were not available.

> Does that mean it run into OOM?

Nope.

> Seem the system still has enough memory available.

Sure, but it is too fragmented.  Get an MMU ;)


otoh, memory reclaim *should* have at least reclaimed non-mmapped
pagecache.  Shooting down lots of pagecache is preferable to failing
exec().  But I expect the PAGE_ALLOC_COSTLY_ORDER logic prevents the kernel
from trying to do this.

If it's repeatable then something like this:

--- a/mm/nommu.c~a
+++ a/mm/nommu.c
@@ -1173,7 +1173,7 @@ static int do_mmap_private(struct vm_are
 	order = get_order(len);
 	kdebug("alloc order %d for %lx", order, len);
 
-	pages = alloc_pages(GFP_KERNEL, order);
+	pages = alloc_pages(GFP_KERNEL|__GFP_REPEAT, order);
 	if (!pages)
 		goto enomem;
 

*might* help.
