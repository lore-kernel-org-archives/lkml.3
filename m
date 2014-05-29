Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaE2CvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:51:14 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41219 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE2CvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140529015830.GG6677@dastard>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<20140529015830.GG6677@dastard>
Date: Wed, 28 May 2014 19:51:11 -0700
X-Google-Sender-Auth: Os5xTb5EAEXskFxJDq9tBtMNu3s
Message-ID: <CA+55aFzb8MXOhbmcjNcRQRCGK4ZPK0WU0JaHdVRyEhKOfDkF6Q@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Crossed emails ]

On Wed, May 28, 2014 at 6:58 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 29, 2014 at 11:30:07AM +1000, Dave Chinner wrote:
>>
>> And now we have too deep a stack due to unplugging from io_schedule()...
>
> So, if we make io_schedule() push the plug list off to the kblockd
> like is done for schedule()....

We might have a few different cases.

The cases where we *do* care about latency is when we are waiting for
the IO ourselves (ie in wait_on_page() and friends), and those end up
using io_schedule() too.

So in *that* case we definitely have a latency argument for doing it
directly, and we shouldn't kick it off to kblockd. That's very much a
"get this started as soon as humanly possible".

But the "wait_iff_congested()" code that also uses io_schedule()
should push it out to kblockd, methinks.

>> This stack overflow shows us that just the memory reclaim + IO
>> layers are sufficient to cause a stack overflow,
>
> .... we solve this problem directly by being able to remove the IO
> stack usage from the direct reclaim swap path.
>
> IOWs, we don't need to turn swap off at all in direct reclaim
> because all the swap IO can be captured in a plug list and
> dispatched via kblockd. This could be done either by io_schedule()
> or a new blk_flush_plug_list() wrapper that pushes the work to
> kblockd...

That would work. That said, I personally would not mind to see that
"swap is special" go away, if possible. Because it can be behind a
filesystem too. Christ, even NFS (and people used to fight that tooth
and nail!) is back as a swap target..

                Linus
