Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaKKQCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:02:07 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33983 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaKKQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:02:03 -0500
MIME-Version: 1.0
In-Reply-To: <20141111064417.GT23575@dastard>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
Date: Tue, 11 Nov 2014 11:02:00 -0500
Message-ID: <CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 1:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 10, 2014 at 11:40:23AM -0500, Milosz Tanski wrote:
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
>> new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
>> extra flag argument (RWF_NONBLOCK).
>>
>> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
>> perform buffered IO operations. They submit the work form another thread
>> that performs network IO and epoll or other threads that perform CPU work. This
>> leads to increased latency for processing, esp. in the case of data that's
>> already cached in the page cache.
>>
>> With the new interface the applications will now be able to fetch the data in
>> their network / cpu bound thread(s) and only defer to a threadpool if it's not
>> there. In our own application (VLDB) we've observed a decrease in latency for
>> "fast" request by avoiding unnecessary queuing and having to swap out current
>> tasks in IO bound work threads.
>
> Can you write a test (or set of) for fstests that exercises this new
> functionality? I'm not worried about performance, just
> correctness....

Sure thing. Can you point me at the fstests repo? A quick google
search reveals lots of projects named fstests, most of them abandoned.

>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
