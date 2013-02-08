Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3BHBEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:04:31 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:54871 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3BHBEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:04:10 -0500
MIME-Version: 1.0
In-Reply-To: <51140A60.4070705@250bpm.com>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
 <5113FCA7.4020207@mit.edu> <51140A60.4070705@250bpm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 7 Feb 2013 17:03:49 -0800
Message-ID: <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 12:11 PM, Martin Sustrik <sustrik@250bpm.com> wrote:
> On 07/02/13 20:12, Andy Lutomirski wrote:
>>
>> On 02/06/2013 10:41 PM, Martin Sustrik wrote:
>>>
>>> When implementing network protocols in user space, one has to implement
>>> fake user-space file descriptors to represent the sockets for the
>>> protocol.
>>>
>>> While all the BSD socket API functionality for such descriptors may be
>>> faked as
>>> well (myproto_send(), myproto_recv() etc.) this approach doesn't work for
>>> polling  (select, poll, epoll). For polling, real system-level file
>>> descriptor
>>> is needed.
>>>
>>> In theory, eventfd may be used for this purpose, except that it is well
>>> suited
>>> only for signaling POLLIN. With some hacking it can be also used to
>>> signal
>>> POLLOUT and POLLERR, however:
>>>
>>> I.  There's no way to signal POLLPRI, POLLHUP etc.
>>> II. There's no way to signal arbitraty combination of POLL* flags. Most
>>> notably,
>>>      !POLLIN&  !POLLOUT, which is a perfectly valid combination for a
>>> network
>>>
>>>      protocol (rx buffer is empty and tx buffer is full), cannot be
>>> signaled
>>>      using current implementation of eventfd.
>>>
>>> This patch implements new EFD_MASK flag which attempts to solve this
>>> problem.
>>>
>>> Additionally, when implementing network protocols in user space, there's
>>> a
>>> need to associate user-space state with the each "socket". If eventfd
>>> object is
>>> used as a reference to the socket, it should be possible to associate an
>>> opaque
>>> pointer to user-space data with it.
>>>
>>> The semantics of EFD_MASK are as follows:
>>>
>>> eventfd(2):
>>>
>>> If eventfd is created with EFD_MASK flag set, it is initialised in such a
>>> way
>>> as to signal no events on the file descriptor when it is polled on.
>>> 'initval'
>>> argument is ignored.
>>>
>>> write(2):
>>>
>>> User is allowed to write only buffers containing the following structure:
>>>
>>> struct efd_mask {
>>>    short events;
>>>    void *ptr;
>>> };
>>
>>
>> IMO that should be u64 ptr to avoid compat problems.
>
>
> I was following the user space declaration of epoll_data:
>
>            typedef union epoll_data {
>                void        *ptr;  <-----
>                int          fd;
>                uint32_t     u32;
>                uint64_t     u64;
>            } epoll_data_t;
>
> However, now I'm looking at the kernel side definition of the whole union
> which looks like this (obviously it assumes that pointer is never longer
> than 64 bits):
>
>          __u64 data;
>
> Hm, not very helpful. Anyway, I am not a kernel developer, so any concrete
> suggestion about what type to use to map cleanly to user-space void* is
> welcome.

Reusing epoll_data_t seems reasonable.  The main consideration is that
the size of the object should not vary between 32-bit and 64-bit
userspace.

>
>
>>> The value of 'events' should be any combination of event flags as defined
>>> by
>>> poll(2) function (POLLIN, POLLOUT, POLLERR, POLLHUP etc.) Specified
>>> events will
>>> be signaled when polling (select, poll, epoll) on the eventfd is done
>>> later on.
>>> 'ptr' is an opaque pointer that is not interpreted by eventfd object.
>>
>>
>> How does this interact with EPOLLET?
>
>
> That's an interesting question. The original eventfd code doesn't do
> anything specific to either edge or level mode. Neither does my patch.
>
> Inspection of the code seems to suggest that edge vs. level distinction is
> handled elsewhere (ep_send_events_proc) where there is a separate list of
> ready events and the function, after returning the event, decides whether to
> leave the event in the list (level) or delete it from the list (edge).

Hmm.  Having looked at the eventpoll.c source again, I remain
unconvinced that EPOLLET works the way that any userspace developer
would expect it to.  But your code probably has very little to do with
this, so maybe you shouldn't worry about it.  There may be some
advantage to adding (later on, if needed) an option to change the
flags set in:

+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked_poll(&ctx->wqh,
+				(unsigned long)ctx->mask.events);

(i.e. to allow the second parameter to omit some bits that were
already signaled.)  Allowing write to write a bigger struct in the
future won't break anything.

It may be a good idea to return EINVAL if anyone tries to write() an
unknown poll bit.

--Andy

>
> In any case, review from someone with experience with epoll implementation
> would help.
>
> Martin
