Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbaCSCRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:17:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38183 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbaCSCRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140318154724.GA5669@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
 <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com>
 <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 19 Mar 2014 10:17:09 +0800
Message-ID: <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:47 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/18, Peter Zijlstra wrote:
>>
>> I think we can avoid the entire function if we add
>> WQ_FLAG_LIFO and make prepare_to_wait_event() DTRT.
>
> Agreed, this looks very natural.
>
> prepare_to_wait_event(WQ_FLAG_LIFO) should probably skip all "flags == 0"
> entries before list_add(). Given that it is supposed that the users won't
> mix exclusive and !exclusive, perhaps the additional list_for_each() won't
> hurt?
>
So please allow me to summary and define the semantics of wait/wake_up
w.r.t. this.

prepare_to_wait_event(0): task is added at the head of the queue.

prepare_to_wait_event(WQ_FLAG_LIFO): task is added at the head of
exclusive queue head

prepare_to_wait_event(WQ_FLAG_EXCLUSIVE): task is added at the tail of the queue

Maybe we should rename the flags to WQ_FLAG_EXCLUSIVE_FIFO and
WQ_FLAG_EXCLUSIVE_LIFO?

>> Then we only need to teach ___wait() about this; and I suppose we could
>> make .exclusive=-1 be the LIFO flag.
>
> Or we can change ___wait_event()
>
>         -       if (exclusive)                                                  \
>         -               __wait.flags = WQ_FLAG_EXCLUSIVE;                       \
>         -       else                                                            \
>         -               __wait.flags = 0;                                       \
>         +       __wait.flags = exclusive;                                       \
>
> and obviously change the callers. Perhaps this argument should be renamed
> then.
>
Current __wait.flags allows possible extension to the existing
interface. If we change it to __wait.flags = exclusive, we drop the
future extensibility. Is it acceptable?

Thanks,
Tao

> But I am fine either way, just I like the idea to extend the current
> interface.
>
> Oleg.
>
