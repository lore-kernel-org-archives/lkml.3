Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaCaMnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:43:16 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:55826 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaCaMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <CALZtONA=v+3_+6qEvyY0SruT=aGxAfV_N5fsHvLMJKFp4Stnww@mail.gmail.com>
References: <CALZtONDiOdYSSu02Eo78F4UL5OLTsk-9MR1hePc-XnSujRuvfw@mail.gmail.com>
	<20140327222605.GB16495@medulla.variantweb.net>
	<CALZtONDBNzL_S+UUxKgvNjEYu49eM5Fc2yJ37dJ8E+PEK+C7qg@mail.gmail.com>
	<533587FD.7000006@redhat.com>
	<CALZtONA=v+3_+6qEvyY0SruT=aGxAfV_N5fsHvLMJKFp4Stnww@mail.gmail.com>
Date: Mon, 31 Mar 2014 20:43:13 +0800
Message-ID: <CAA_GA1er3d+_LJp67aD8tE0SLMod--FpRFvGBdKmpzU_aQNdUg@mail.gmail.com>
Subject: Re: Adding compression before/above swapcache
From: Bob Liu <lliubbo@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Rik van Riel <riel@redhat.com>, Seth Jennings <sjennings@variantweb.net>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Bob Liu <bob.liu@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 10:47 PM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Fri, Mar 28, 2014 at 10:32 AM, Rik van Riel <riel@redhat.com> wrote:
>> On 03/28/2014 08:36 AM, Dan Streetman wrote:
>>
>>> Well my general idea was to modify shrink_page_list() so that instead
>>> of calling add_to_swap() and then pageout(), anonymous pages would be
>>> added to a compressed cache.  I haven't worked out all the specific
>>> details, but I am initially thinking that the compressed cache could
>>> simply repurpose incoming pages to use as the compressed cache storage
>>> (using its own page mapping, similar to swap page mapping), and then
>>> add_to_swap() the storage pages when the compressed cache gets to a
>>> certain size.  Pages that don't compress well could just bypass the
>>> compressed cache, and get sent the current route directly to
>>> add_to_swap().
>>
>>
>> That sounds a lot like what zswap does. How is your
>> proposal different?
>
> Two main ways:
> 1) it's above swap, so it would still work without any real swap.

Zswap can also be extended without any real swap device.

> 2) compressed pages could be written to swap disk.
>

Yes, how to handle the write back of zswap is a problem. And I think
your patch making zswap write through is a good start.

> Essentially, the two existing memory compression approaches are both
> tied to swap.  But, AFAIK there's no reason that memory compression
> has to be tied to swap.  So my approach uncouples it.
>

Yes, it's not necessary but swap page is a good candidate and easy to
handle. There are also clean file pages which may suitable for
compression. See http://lwn.net/Articles/545244/.

>>
>> And, is there an easier way to implement that difference? :)
>
> I'm hoping that it wouldn't actually be too complex.  But that's part
> of why I emailed for feedback before digging into a prototype... :-)
>

I'm afraid your idea may not that easy to be implemented and need to
add many tricky code to current mm subsystem, but the benefit is still
uncertain. As Mel pointed out we really need better demonstration
workloads for memory compression before changes.
https://lwn.net/Articles/591961

-- 
Regards,
--Bob
