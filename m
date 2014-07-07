Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaGGXwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:52:39 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:35164 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaGGXwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140707230459.GF18735@two.firstfloor.org>
References: <20140707223001.GD18735@two.firstfloor.org>
	<53BB240C.30400@zytor.com>
	<20140707230459.GF18735@two.firstfloor.org>
Date: Mon, 7 Jul 2014 16:52:35 -0700
X-Google-Sender-Auth: bLh2MXS_1mF3WCoFm0SKhoLcP90
Message-ID: <CA+55aFxD4akfr3sc_y=F17Ak_9NqEHOu=vBz5x2kR75TkG8znA@mail.gmail.com>
Subject: Re: fallout of 16K stacks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 4:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> As in ENOMEM or does something worse happen?
>
> EAGAIN, then the workload stops. For an overnight stress
> test that's pretty catastrophic. It may have killed some stuff
> with the OOM killer too.

I don't think it's OOM.

We have long had the rule that order <= PAGE_ALLOC_COSTLY_ORDER (which
is 3) allocations imply __GFP_RETRY unless you explicitly ask it not
to.

And THREAD_SIZE_ORDER is still smaller than that.

Sure, if the system makes no progress at all, it will still oom for
allocations like that, but that's *not* going to happen for something
like a 32GB machine afaik.

And if it was the actual dup_task_struct() that failed (due to
alloc_thread_info_node() now failing), it should have returned ENOMEM
anyway.

So EAGAIN is due to something else.

The only cases for fork() returning EAGAIN I can find are the
RLIMIT_NPROC and max_threads checks.

And the thing is, the default value for RLIMIT_NPROC is actually
initialized based on THREAD_SIZE (which doubled), so maybe it's really
just that rlimit check that now triggers.

Hmm?

          Linus
