Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbaEaCHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 22:07:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53337 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaEaCG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 22:06:56 -0400
Message-ID: <5389393D.2030305@kernel.dk>
Date: Fri, 30 May 2014 20:06:53 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
CC: Minchan Kim <minchan@kernel.org>,
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
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>	<1401260039-18189-2-git-send-email-minchan@kernel.org>	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>	<20140528223142.GO8554@dastard>	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>	<20140529013007.GF6677@dastard> <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
In-Reply-To: <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-28 20:42, Linus Torvalds wrote:
>> Regardless of whether it is swap or something external queues the
>> bio on the plug, perhaps we should look at why it's done inline
>> rather than by kblockd, where it was moved because it was blowing
>> the stack from schedule():
>
> So it sounds like we need to do this for io_schedule() too.
>
> In fact, we've generally found it to be a mistake every time we
> "automatically" unblock some IO queue. And I'm not saying that because
> of stack space, but because we've _often_ had the situation that eager
> unblocking results in IO that could have been done as bigger requests.

We definitely need to auto-unplug on the schedule path, otherwise we run 
into all sorts of trouble. But making it async off the IO schedule path 
is fine. By definition, it's not latency sensitive if we are hitting 
unplug on schedule. I'm pretty sure it was run inline on CPU concerns 
here, as running inline is certainly cheaper than punting to kblockd.

> Looking at that callchain, I have to say that ext4 doesn't look
> horrible compared to the whole block layer and virtio.. Yes,
> "ext4_writepages()" is using almost 400 bytes of stack, and most of
> that seems to be due to:
>
>          struct mpage_da_data mpd;
>          struct blk_plug plug;

Plus blk_plug is pretty tiny as it is. I queued up a patch to kill the 
magic part of it, since that's never caught any bugs. Only saves 8 
bytes, but may as well take that. Especially if we end up with nested plugs.

> Well, we've definitely have had some issues with deeper callchains
> with md, but I suspect virtio might be worse, and the new blk-mq code
> is lilkely worse in this respect too.

I don't think blk-mq is worse than the older stack, in fact it should be 
better. The call chains are shorter, and a lot less cruft on the stack. 
Historically the stack issues have been nested devices, however. And for 
sync IO, we do run it inline, so if the driver chews up a lot of stack, 
well...

Looks like I'm late here and the decision has been made to go 16K 
stacks, which I think is a good one. We've been living on the edge (and 
sometimes over) for heavy dm/md setups for a while, and have been 
patching around that fact in the IO stack for years.


-- 
Jens Axboe

