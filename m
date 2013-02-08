Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3BHDhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:37:17 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38274 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3BHDhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:37:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1AZaXHiW47MbstoVaDVEbVaSC+fqcZoSM0EXC5RpH7nHw@mail.gmail.com>
References: <CAOAMb1AZaXHiW47MbstoVaDVEbVaSC+fqcZoSM0EXC5RpH7nHw@mail.gmail.com>
Date: Fri, 8 Feb 2013 12:37:13 +0900
X-Google-Sender-Auth: zgOC1ZHLFpg91QK4uqfadys-Y6Y
Message-ID: <CAOAMb1BwVCPMLRMkMZuHhoi-meULJ-jG+O5sU4ppkR_MLDQ5dg@mail.gmail.com>
Subject: Re: [PATCH] vmalloc: Remove alloc_map from vmap_block.
From: Chanho Min <chanho.min@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cong Wang <amwang@redhat.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I started looking for workloads to profile but then lost interest.
>The current code can theoretically end up walking through a lot of
>partially used blocks if a string of allocations never fit any of
>them.  The number of these blocks depends on previous allocations that
>leave them unusable for future allocations and whether any other
>vmalloc/vmap user recently flushed them all.  So it's painful to think
>about it and hard to impossible to pin down should this ever actually
>result in a performance problem.

vm_map_ram() is allowed to be called by external kernel module.
I profiled some kernel module as bellow perf log. Its mapping behavior
was most of the workload. yes, we can improve its inefficient mapping.
But, This shows the allocation bitmap has the potential to cause significant
overhead.

# Overhead          Command        Shared Object
                  Symbol
# ........  ...............  ...................
.............................................
#
    42.74%  XXXXXXTextureSc  [kernel.kallsyms]    [k] __reg_op
            |
            --- __reg_op
               |
               |--5.39%-- 0xaf57de00
               |          |
               |           --100.00%-- malloc
               |
               |--2.35%-- 0xaf57da00
               |          |
               |           --100.00%-- malloc
               |
               |--2.10%-- 0xaf57ce00
               |          |
               |           --100.00%-- malloc
               |
               |--1.46%-- 0xaf57c800
               |          |
               |           --100.00%-- malloc
               |
               |--1.43%-- 0xaf57dc00
               |          |
               |           --100.00%-- malloc
               |
               |--1.36%-- 0xaf57c200
               |          |
               |           --100.00%-- malloc
               |
               |--1.34%-- 0xaf57c000
               |          |
               |           --100.00%-- malloc
               |
               |--1.26%-- 0xae915400
               |          |
               |           --100.00%-- malloc
               |
               |--0.80%-- 0xae914200
               |          |
               |           --100.00%-- malloc
               |
               |--0.79%-- 0xaf57ca00
               |          |
               |           --100.00%-- malloc
               |
               |--0.67%-- 0xaf57d000
               |          |
               |           --100.00%-- malloc
               |
               |--0.52%-- 0xaf57cc00
               |          |
               |           --100.00%-- malloc
                --80.54%-- [...]
    17.39%  XXXXXXTextureSc  [kernel.kallsyms]    [k]
bitmap_find_free_region
            |
            --- bitmap_find_free_region
               |
               |--99.93%-- vm_map_ram
               |          0x7f00097c
               |          0x7f00985c
               |          |
               |          |--99.79%-- 0x7f009948
               |          |          |
               |          |          |--50.24%-- 0x7f00ab90
               |          |          |          0x7f006c50
               |          |          |          0x7f00e948
               |          |          |          0x7f019630
               |          |          |          0x7f00f0ac
               |          |          |          0x7f002384
               |          |          |          vfs_ioctl
               |          |          |          do_vfs_ioctl
               |          |          |          sys_ioctl
               |          |          |          ret_fast_syscall
               |          |          |
               |          |          |--49.60%-- 0x7f00acfc
               |          |          |          0x7f006bfc
               |          |          |          0x7f018fac
               |          |          |          0x7f00f0ac
               |          |          |          0x7f002384
               |          |          |          vfs_ioctl
               |          |          |          do_vfs_ioctl
               |          |          |          sys_ioctl
               |          |          |          ret_fast_syscall
               |          |          |          malloc
               |          |           --0.16%-- [...]
...

Thanks
Chanho Min
