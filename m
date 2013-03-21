Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3CUNGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:06:36 -0400
Received: from relay.parallels.com ([195.214.232.42]:54366 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3CUNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:06:35 -0400
Message-ID: <514B056E.7040802@parallels.com>
Date: Thu, 21 Mar 2013 17:04:46 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <bfoster@redhat.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 0/3] fuse: fix accounting background requests
References: <20121226124319.24502.41536.stgit@maximpc.sw.ru> <CAJfpegsKDYrZKJ2TLzMfpx+vgF=cNvdBFjVnTZi1zuqTPwd7YA@mail.gmail.com>
In-Reply-To: <CAJfpegsKDYrZKJ2TLzMfpx+vgF=cNvdBFjVnTZi1zuqTPwd7YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02/06/2013 09:12 PM, Miklos Szeredi пишет:
> On Wed, Dec 26, 2012 at 1:44 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> Hi,
>>
>> The feature was added long time ago (commit 08a53cdc...) with the comment:
>>
>>> A task may have at most one synchronous request allocated.  So these requests
>>> need not be otherwise limited.
>>>
>>> However the number of background requests (release, forget, asynchronous
>>> reads, interrupted requests) can grow indefinitely.  This can be used by a
>>> malicous user to cause FUSE to allocate arbitrary amounts of unswappable
>>> kernel memory, denying service.
>>>
>>> For this reason add a limit for the number of background requests, and block
>>> allocations of new requests until the number goes bellow the limit.
>> However, the implementation suffers from the following problems:
>>
>> 1. Latency of synchronous requests. As soon as fc->num_background hits the
>> limit, all allocations are blocked: both for synchronous and background
>> requests. This is unnecessary - as the comment cited above states, synchronous
>> requests need not be limited (by fuse). Moreover, sometimes it's very
>> inconvenient. For example, a dozen of tasks aggressively writing to mmap()-ed
>> area may block 'ls' for long while (>1min in my experiments).
>>
>> 2. Thundering herd problem. When fc->num_background falls below the limit,
>> request_end() calls wake_up_all(&fc->blocked_waitq). This wakes up all waiters
>> while it's not impossible that the first waiter getting new request will
>> immediately put it to background increasing fc->num_background again.
>> (experimenting with mmap()-ed writes I observed 2x slowdown as compared with
>> fuse after applying this patch-set)
>>
>> The patch-set re-works fuse_get_req (and its callers) to throttle only requests
>> intended for background processing. Having this done, it becomes possible to
>> use exclusive wakeups in chained manner: request_end() wakes up a waiter,
>> the waiter allocates new request and submits it for background processing,
>> the processing ends in request_end() where another wakeup happens an so on.
> Thanks.  These patches look okay.
>
> But they don't apply to for-next.  Can you please update them?

Sorry for long delay. I'll send updated patches soon.

Thanks,
Maxim

>
> Thanks,
> Miklos
>
>> Thanks,
>> Maxim
>>
>> ---
>>
>> Maxim Patlasov (3):
>>        fuse: make request allocations for background processing explicit
>>        fuse: skip blocking on allocations of synchronous requests
>>        fuse: implement exclusive wakeup for blocked_waitq
>>
>>
>>   fs/fuse/cuse.c   |    2 +-
>>   fs/fuse/dev.c    |   60 +++++++++++++++++++++++++++++++++++++++++-------------
>>   fs/fuse/file.c   |    5 +++--
>>   fs/fuse/fuse_i.h |    3 +++
>>   fs/fuse/inode.c  |    1 +
>>   5 files changed, 54 insertions(+), 17 deletions(-)
>>
>> --
>> Signature

