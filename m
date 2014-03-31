Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaCaPgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:36:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65371 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaCaPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAA_GA1er3d+_LJp67aD8tE0SLMod--FpRFvGBdKmpzU_aQNdUg@mail.gmail.com>
References: <CALZtONDiOdYSSu02Eo78F4UL5OLTsk-9MR1hePc-XnSujRuvfw@mail.gmail.com>
 <20140327222605.GB16495@medulla.variantweb.net> <CALZtONDBNzL_S+UUxKgvNjEYu49eM5Fc2yJ37dJ8E+PEK+C7qg@mail.gmail.com>
 <533587FD.7000006@redhat.com> <CALZtONA=v+3_+6qEvyY0SruT=aGxAfV_N5fsHvLMJKFp4Stnww@mail.gmail.com>
 <CAA_GA1er3d+_LJp67aD8tE0SLMod--FpRFvGBdKmpzU_aQNdUg@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 31 Mar 2014 11:35:57 -0400
X-Google-Sender-Auth: e8umJ24UPkmNmibODk4ouZRoY90
Message-ID: <CALZtONBQZYeRTx_=Z70H7v4g=39C=caJgoZV3mVFwoPHTHVTuQ@mail.gmail.com>
Subject: Re: Adding compression before/above swapcache
To: Bob Liu <lliubbo@gmail.com>
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

On Mon, Mar 31, 2014 at 8:43 AM, Bob Liu <lliubbo@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 10:47 PM, Dan Streetman <ddstreet@ieee.org> wrote:
>> On Fri, Mar 28, 2014 at 10:32 AM, Rik van Riel <riel@redhat.com> wrote:
>>> On 03/28/2014 08:36 AM, Dan Streetman wrote:
>>>
>>>> Well my general idea was to modify shrink_page_list() so that instead
>>>> of calling add_to_swap() and then pageout(), anonymous pages would be
>>>> added to a compressed cache.  I haven't worked out all the specific
>>>> details, but I am initially thinking that the compressed cache could
>>>> simply repurpose incoming pages to use as the compressed cache storage
>>>> (using its own page mapping, similar to swap page mapping), and then
>>>> add_to_swap() the storage pages when the compressed cache gets to a
>>>> certain size.  Pages that don't compress well could just bypass the
>>>> compressed cache, and get sent the current route directly to
>>>> add_to_swap().
>>>
>>>
>>> That sounds a lot like what zswap does. How is your
>>> proposal different?
>>
>> Two main ways:
>> 1) it's above swap, so it would still work without any real swap.
>
> Zswap can also be extended without any real swap device.

Ok I'm interested - how is that possible? :-)

>> 2) compressed pages could be written to swap disk.
>>
>
> Yes, how to handle the write back of zswap is a problem. And I think
> your patch making zswap write through is a good start.

but it's still writethrough of uncompressed pages.

>> Essentially, the two existing memory compression approaches are both
>> tied to swap.  But, AFAIK there's no reason that memory compression
>> has to be tied to swap.  So my approach uncouples it.
>>
>
> Yes, it's not necessary but swap page is a good candidate and easy to
> handle. There are also clean file pages which may suitable for
> compression. See http://lwn.net/Articles/545244/.

Yep, and what is the current state of cleancache?  Was there a
definitive reason it hasn't made it in yet?

>>> And, is there an easier way to implement that difference? :)
>>
>> I'm hoping that it wouldn't actually be too complex.  But that's part
>> of why I emailed for feedback before digging into a prototype... :-)
>>
>
> I'm afraid your idea may not that easy to be implemented and need to
> add many tricky code to current mm subsystem, but the benefit is still
> uncertain. As Mel pointed out we really need better demonstration
> workloads for memory compression before changes.
> https://lwn.net/Articles/591961

Well I think it's hard to argue that memory compression provides *no*
obvious benefit - I'm pretty sure it's quite useful for minor
overcommit on systems without any disk swap, and even for systems with
swap it at least softens the steep performance cliff that we currently
have when starting to overcommit memory into swap space.

As far as its benefits for larger systems, or how realistic it is to
start routinely overcommitting systems with the expectation that
memory compression magically gives you more effective RAM, I certainly
don't know the answer, and I agree, more widespread testing and
demonstration surely will be needed.

But to ask a more pointed question - what do you think would be the
tricky part(s)?
