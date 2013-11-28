Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3K1H3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:29:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32855 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3K1H3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:29:03 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.103.66]
In-Reply-To: <20131126164417.9df88075f9ad394679bb60cb@linux-foundation.org>
References: <1385458169.6721.2.camel@phoenix>
	<20131126164417.9df88075f9ad394679bb60cb@linux-foundation.org>
Date: Thu, 28 Nov 2013 15:29:02 +0800
Message-ID: <CAFRkauDpmyXzs+ryCmxTiadXVs5BppH4NZJ1fG6AmHtruiuarg@mail.gmail.com>
Subject: Re: ARM: nommu: Unable to allocate RAM for process text/data, errno 12
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/27 Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 26 Nov 2013 17:29:29 +0800 Axel Lin <axel.lin@ingics.com> wrote:
>
>> Hi,
>> I got below error messages while starting mdev (busybox).
>>
>> ...
>>
>> [  108.537109] chmod: page allocation failure: order:8, mode:0xd0
>
> It wants to allocate 2^8 physically contiguous pages!
>
>> [  108.543945] CPU: 0 PID: 47 Comm: chmod Not tainted 3.13.0-rc1-00170-g1bab531-dirty #1940
>> [  108.580078] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
>> [  108.592773] [<0000ae58>] (show_stack+0x10/0x14) from [<00050010>] (warn_alloc_failed+0xf8/0x128)
>> [  108.605468] [<00050010>] (warn_alloc_failed+0xf8/0x128) from [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4)
>> [  108.620117] [<00052030>] (__alloc_pages_nodemask+0x64c/0x6c4) from [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0)
>> [  108.633789] [<0005f028>] (do_mmap_pgoff+0x5d0/0x9b0) from [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c)
>> [  108.647460] [<0005ac04>] (vm_mmap_pgoff+0x64/0x7c) from [<0009e6e8>] (load_flat_binary+0x38c/0xa0c)
>> [  108.660156] [<0009e6e8>] (load_flat_binary+0x38c/0xa0c) from [<0006bc40>] (search_binary_handler+0x4c/0xa4)
>> [  108.676757] [<0006bc40>] (search_binary_handler+0x4c/0xa4) from [<0006bfc8>] (do_execve+0x330/0x4e8)
>> [  108.689453] [<0006bfc8>] (do_execve+0x330/0x4e8) from [<0006c3c4>] (SyS_execve+0x30/0x44)
>> [  108.701171] [<0006c3c4>] (SyS_execve+0x30/0x44) from [<00008f40>] (ret_fast_syscall+0x0/0x44)
>
> So the binfmt_flat driver is allocating memory into which to load
> mdev's text (I assume it's the text).
>
>> Why it got page allocation failure?
>
> Because 256 physically contiguous free pages were not available.
>
>> Does that mean it run into OOM?
>
> Nope.
>
>> Seem the system still has enough memory available.
>
> Sure, but it is too fragmented.  Get an MMU ;)
>
>
> otoh, memory reclaim *should* have at least reclaimed non-mmapped
> pagecache.  Shooting down lots of pagecache is preferable to failing
> exec().  But I expect the PAGE_ALLOC_COSTLY_ORDER logic prevents the kernel
> from trying to do this.
>
> If it's repeatable then something like this:
>
> --- a/mm/nommu.c~a
> +++ a/mm/nommu.c
> @@ -1173,7 +1173,7 @@ static int do_mmap_private(struct vm_are
>         order = get_order(len);
>         kdebug("alloc order %d for %lx", order, len);
>
> -       pages = alloc_pages(GFP_KERNEL, order);
> +       pages = alloc_pages(GFP_KERNEL|__GFP_REPEAT, order);
>         if (!pages)
>                 goto enomem;
>
>
> *might* help.

Hi Andrew,
Thanks for your reply.

I try to boot a couple times with your patch.
Sometimes I can still see the same (above) messages with your patch applied.

I'm trying to remove unnecessary features to reduce memory usage.
(seems this does help. I got more free memory so less chance to hit
memory allocation failure)
Is it possible to know current memory consumption (slab) in a running system?

BTW, I'm wondering what is the guidline to choose the SLAB allocator?
(especially, for embedded platforms without mmu).

I google for slab/slub/slob, and found some material [1] says:
SLOB (Simple List Of Blocks) is a memory allocator optimized for
embedded systems
with very little memory—on the order of megabytes.
But it also says SLOB suffer from pathological fragmentation.
So I'm wondering if I should choose SLOB or not. ( Currently, I'm using SLUB ).

[1] http://stackoverflow.com/questions/15470560/what-to-choose-between-slab-and-slub-allocator-in-linux-kernel

Regards,
Axel
