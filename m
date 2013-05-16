Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3EPNow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:44:52 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:44509 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3EPNot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9bXvkjV6-O3JZH6taVX-dZ1tzbSoqaC_sN00LRszsS4QAnrg@mail.gmail.com>
References: <1367416573-5430-1-git-send-email-rlove@google.com>
	<20130513214216.GA23743@kroah.com>
	<CA+2_TiZ3dECAW8LV-Es=BjHCwgWw69zbWkr73at+0_c-EaDHmA@mail.gmail.com>
	<CAG9bXvkH0L5FjkU3-=3X3zwp3vw8U7+jJRYp28GFXjLkQKBL5g@mail.gmail.com>
	<CAG9bXvkjV6-O3JZH6taVX-dZ1tzbSoqaC_sN00LRszsS4QAnrg@mail.gmail.com>
Date: Thu, 16 May 2013 09:44:49 -0400
Message-ID: <CAG6tG3zaU=gkJZzNezOX=s5WWDrc2x7SHiDy3UxVzDvKkw2foA@mail.gmail.com>
Subject: Re: [PATCH -next] ashmem: Fix ashmem_shrink deadlock.
From: Robert Love <rlove@google.com>
To: Raul Xiong <raulxiong@gmail.com>
Cc: Neil Zhang <glacier1980@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        devel <devel@driverdev.osuosl.org>, Hugh Dickins <hughd@google.com>,
        Anjana V Kumar <anjanavk12@gmail.com>, Dad <akpm@linux-foundation.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 4:15 AM, Raul Xiong <raulxiong@gmail.com> wrote:
> The issue happens in such sequence:
> ashmem_mmap acquired ashmem_mutex --> ashmem_mutex:shmem_file_setup
> called kmem_cache_alloc --> shrink due to low memory --> ashmem_shrink
> tries to acquire the same ashmem_mutex -- it blocks here.
>
> I think this reports the bug clearly. Please have a look.

There is no debate about the nature of the bug. Only the fix.

My mutex_trylock patch fixes the problem. I prefer that solution.

Andrew's suggestion of GFP_ATOMIC won't work as we'd have to propagate
that down into shmem and elsewhere.

Using PF_MEMALLOC will work. You'd want to define something like:

static int set_memalloc(void)
{
        if (current->flags & PF_MEMALLOC)
                return 0;
        current->flags |= PF_MEMALLOC;
        return 1;
}

static void clear_memalloc(int memalloc)
{
        if (memalloc)
                current->flags &= ~PF_MEMALLOC;
}

and then set/clear PF_MEMALLOC around every memory allocation and
function that descends into a memory allocation. As said I prefer my
solution but if someone wants to put together a patch with this
approach, fine by me.

         Robert
