Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab3CUODl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:03:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:38909 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab3CUODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:03:40 -0400
Subject: [PATCH 0/4] fuse: fix accounting background requests (v2)
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, dev@parallels.com
Date: Thu, 21 Mar 2013 18:01:53 +0400
Message-ID: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The feature was added long time ago (commit 08a53cdc...) with the comment:

> A task may have at most one synchronous request allocated.  So these requests
> need not be otherwise limited.
>
> However the number of background requests (release, forget, asynchronous
> reads, interrupted requests) can grow indefinitely.  This can be used by a
> malicous user to cause FUSE to allocate arbitrary amounts of unswappable
> kernel memory, denying service.
>
> For this reason add a limit for the number of background requests, and block
> allocations of new requests until the number goes bellow the limit.

However, the implementation suffers from the following problems:

1. Latency of synchronous requests. As soon as fc->num_background hits the
limit, all allocations are blocked: both for synchronous and background
requests. This is unnecessary - as the comment cited above states, synchronous
requests need not be limited (by fuse). Moreover, sometimes it's very
inconvenient. For example, a dozen of tasks aggressively writing to mmap()-ed
area may block 'ls' for long while (>1min in my experiments).

2. Thundering herd problem. When fc->num_background falls below the limit,
request_end() calls wake_up_all(&fc->blocked_waitq). This wakes up all waiters
while it's not impossible that the first waiter getting new request will
immediately put it to background increasing fc->num_background again.
(experimenting with mmap()-ed writes I observed 2x slowdown as compared with
fuse after applying this patch-set)

The patch-set re-works fuse_get_req (and its callers) to throttle only requests
intended for background processing. Having this done, it becomes possible to
use exclusive wakeups in chained manner: request_end() wakes up a waiter,
the waiter allocates new request and submits it for background processing,
the processing ends in request_end() where another wakeup happens an so on.

Changed in v2:
 - rebased on for-next branch of the fuse tree
 - fixed race when processing request begins before init-reply came

Thanks,
Maxim

---

Maxim V. Patlasov (4):
      fuse: make request allocations for background processing explicit
      fuse: add flag fc->uninitialized
      fuse: skip blocking on allocations of synchronous requests
      fuse: implement exclusive wakeup for blocked_waitq


 fs/fuse/cuse.c   |    3 ++
 fs/fuse/dev.c    |   69 +++++++++++++++++++++++++++++++++++++++++++-----------
 fs/fuse/file.c   |    6 +++--
 fs/fuse/fuse_i.h |    8 ++++++
 fs/fuse/inode.c  |    4 +++
 5 files changed, 73 insertions(+), 17 deletions(-)

-- 
Signature
