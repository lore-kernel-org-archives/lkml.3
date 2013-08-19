Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3HSVQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:16:40 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:50760 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HSVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
References: <20130706000949.GD16853@hostway.ca>
	<CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
Date: Mon, 19 Aug 2013 14:16:36 -0700
X-Google-Sender-Auth: g0qqxw1sHl3EdcCWrrUFFXwViKg
Message-ID: <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Simon Kirby <sim@hostway.ca>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
> On Mon, 19 Aug 2013, Simon Kirby wrote:
>
>>    [... ]  The
>> alloc/free traces are always the same -- always alloc_pipe_info and
>> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
>>
>> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
>
> This looks like an increment after free in the second 32 bit value of the
> structure. First 32 bit value's poison is unchanged.

Ugh. If that is "struct pipe_inode_info" and I read it right, that's
the "wait_lock" spinlock that is part of the mutex.

Doing a "spin_lock()" could indeed cause an increment operation. But
it still sounds like a very odd case. And even for some wild pointer
I'd then expect the spin_unlock to also happen, and to then increment
the next byte (or word) too. More importantly, for a mutex, I'd expect
the *other* fields to be corrupted too (the "waiter" field etc). That
is, unless we're still spinning waiting for the mutex, but with that
value we shouldn't, as far as I can see.

But it kind of does match at least one of your oopses that you had
before using slab debugging: one of them had a pointer that should
have been NULL that was 0000000100000000. Which again is "increment
the second 32-bit word", and could be explained by the slab entry
being re-used for another allocation that just happened to have a
pointer in the first 8 bytes instead.

And I think the timing is interesting, and there is data to back up
the fact that it is that mutex field: the field was introduced by
commit 72b0d9aacb89 ("pipe: don't use ->i_mutex"), which was merged
into 3.10-rc1. So it matches the timing Simon sees. So while I think
the pipe mutex spinlock field is a bit odd,

Al Viro added to the participants list. Because that
pipe->mutex->mutex_lock corruption doesn't really make sense to me,
but there are certainly interesting coincidences wrt timing.

Simon - it *might* be interesting to do this with DEBUG_PAGEALLOC, and
make the pipe_inode_info allocations use a full page instead of a
kmalloc() in order to trigger that way. So now it uses

    pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);

and

    kfree(pipe);

in alloc_pipe_info/free_pipe_info respectively, could you make it use

    pipe = (void *)get_zeroed_page(GFP_KERNEL);

and

    free_page((unsigned long)pipe);

instead respectively, and then enable DEBUG_PAGEALLOC? That *should*
trigger an exception on the actual bad access, if it really is this
pipe_inode_info that is having problems..

                  Linus
