Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255Ab3BGULQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:11:16 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:46756 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab3BGULP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:11:15 -0500
Message-ID: <51140A60.4070705@250bpm.com>
Date: Thu, 07 Feb 2013 21:11:12 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <5113FCA7.4020207@mit.edu>
In-Reply-To: <5113FCA7.4020207@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/13 20:12, Andy Lutomirski wrote:
> On 02/06/2013 10:41 PM, Martin Sustrik wrote:
>> When implementing network protocols in user space, one has to implement
>> fake user-space file descriptors to represent the sockets for the protocol.
>>
>> While all the BSD socket API functionality for such descriptors may be faked as
>> well (myproto_send(), myproto_recv() etc.) this approach doesn't work for
>> polling  (select, poll, epoll). For polling, real system-level file descriptor
>> is needed.
>>
>> In theory, eventfd may be used for this purpose, except that it is well suited
>> only for signaling POLLIN. With some hacking it can be also used to signal
>> POLLOUT and POLLERR, however:
>>
>> I.  There's no way to signal POLLPRI, POLLHUP etc.
>> II. There's no way to signal arbitraty combination of POLL* flags. Most notably,
>>      !POLLIN&  !POLLOUT, which is a perfectly valid combination for a network
>>      protocol (rx buffer is empty and tx buffer is full), cannot be signaled
>>      using current implementation of eventfd.
>>
>> This patch implements new EFD_MASK flag which attempts to solve this problem.
>>
>> Additionally, when implementing network protocols in user space, there's a
>> need to associate user-space state with the each "socket". If eventfd object is
>> used as a reference to the socket, it should be possible to associate an opaque
>> pointer to user-space data with it.
>>
>> The semantics of EFD_MASK are as follows:
>>
>> eventfd(2):
>>
>> If eventfd is created with EFD_MASK flag set, it is initialised in such a way
>> as to signal no events on the file descriptor when it is polled on. 'initval'
>> argument is ignored.
>>
>> write(2):
>>
>> User is allowed to write only buffers containing the following structure:
>>
>> struct efd_mask {
>>    short events;
>>    void *ptr;
>> };
>
> IMO that should be u64 ptr to avoid compat problems.

I was following the user space declaration of epoll_data:

            typedef union epoll_data {
                void        *ptr;  <-----
                int          fd;
                uint32_t     u32;
                uint64_t     u64;
            } epoll_data_t;

However, now I'm looking at the kernel side definition of the whole 
union which looks like this (obviously it assumes that pointer is never 
longer than 64 bits):

          __u64 data;

Hm, not very helpful. Anyway, I am not a kernel developer, so any 
concrete suggestion about what type to use to map cleanly to user-space 
void* is welcome.

>> The value of 'events' should be any combination of event flags as defined by
>> poll(2) function (POLLIN, POLLOUT, POLLERR, POLLHUP etc.) Specified events will
>> be signaled when polling (select, poll, epoll) on the eventfd is done later on.
>> 'ptr' is an opaque pointer that is not interpreted by eventfd object.
>
> How does this interact with EPOLLET?

That's an interesting question. The original eventfd code doesn't do 
anything specific to either edge or level mode. Neither does my patch.

Inspection of the code seems to suggest that edge vs. level distinction 
is handled elsewhere (ep_send_events_proc) where there is a separate 
list of ready events and the function, after returning the event, 
decides whether to leave the event in the list (level) or delete it from 
the list (edge).

In any case, review from someone with experience with epoll 
implementation would help.

Martin
