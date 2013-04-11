Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3DKLS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:18:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:53440 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3DKLS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:18:57 -0400
Message-ID: <51669C31.2080705@parallels.com>
Date: Thu, 11 Apr 2013 15:19:13 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: <fuse-devel@lists.sourceforge.net>, <dev@parallels.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <xemul@parallels.com>
Subject: Re: [fuse-devel] [PATCH 0/4] fuse: fix accounting background requests
 (v2)
References: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
In-Reply-To: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Any feedback would be highly appreciated.

Thanks,
Maxim

03/21/2013 06:01 PM, Maxim V. Patlasov пишет:
> Hi,
>
> The feature was added long time ago (commit 08a53cdc...) with the comment:
>
>> A task may have at most one synchronous request allocated.  So these requests
>> need not be otherwise limited.
>>
>> However the number of background requests (release, forget, asynchronous
>> reads, interrupted requests) can grow indefinitely.  This can be used by a
>> malicous user to cause FUSE to allocate arbitrary amounts of unswappable
>> kernel memory, denying service.
>>
>> For this reason add a limit for the number of background requests, and block
>> allocations of new requests until the number goes bellow the limit.
> However, the implementation suffers from the following problems:
>
> 1. Latency of synchronous requests. As soon as fc->num_background hits the
> limit, all allocations are blocked: both for synchronous and background
> requests. This is unnecessary - as the comment cited above states, synchronous
> requests need not be limited (by fuse). Moreover, sometimes it's very
> inconvenient. For example, a dozen of tasks aggressively writing to mmap()-ed
> area may block 'ls' for long while (>1min in my experiments).
>
> 2. Thundering herd problem. When fc->num_background falls below the limit,
> request_end() calls wake_up_all(&fc->blocked_waitq). This wakes up all waiters
> while it's not impossible that the first waiter getting new request will
> immediately put it to background increasing fc->num_background again.
> (experimenting with mmap()-ed writes I observed 2x slowdown as compared with
> fuse after applying this patch-set)
>
> The patch-set re-works fuse_get_req (and its callers) to throttle only requests
> intended for background processing. Having this done, it becomes possible to
> use exclusive wakeups in chained manner: request_end() wakes up a waiter,
> the waiter allocates new request and submits it for background processing,
> the processing ends in request_end() where another wakeup happens an so on.
>
> Changed in v2:
>   - rebased on for-next branch of the fuse tree
>   - fixed race when processing request begins before init-reply came
>
> Thanks,
> Maxim
>
> ---
>
> Maxim V. Patlasov (4):
>        fuse: make request allocations for background processing explicit
>        fuse: add flag fc->uninitialized
>        fuse: skip blocking on allocations of synchronous requests
>        fuse: implement exclusive wakeup for blocked_waitq
>
>
>   fs/fuse/cuse.c   |    3 ++
>   fs/fuse/dev.c    |   69 +++++++++++++++++++++++++++++++++++++++++++-----------
>   fs/fuse/file.c   |    6 +++--
>   fs/fuse/fuse_i.h |    8 ++++++
>   fs/fuse/inode.c  |    4 +++
>   5 files changed, 73 insertions(+), 17 deletions(-)
>

