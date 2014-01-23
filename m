Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaAWTS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:18:57 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:47732 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAWTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:18:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140123001806.GF31230@bbox>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
 <20140114001115.GU1992@bbox> <CALZtONCCrckuHxgHB=GQj0tHszLAYTZZLGzFTnRkj9pvxx0dyg@mail.gmail.com>
 <20140115054208.GL1992@bbox> <CALZtONCehE8Td2C2w-fOC596uD54y1-kyc3SiKABBEODMb+a7Q@mail.gmail.com>
 <CALZtONAaPCi8eUhSmdXSxWbeFFN=ChsfL9OurSZUsSPo-_gnfg@mail.gmail.com>
 <20140122123358.a65c42605513fc8466152801@linux-foundation.org> <20140123001806.GF31230@bbox>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 23 Jan 2014 14:18:33 -0500
X-Google-Sender-Auth: -bgjQGTWm85pkMGybT6p9F3YbyI
Message-ID: <CALZtONCQFwWFwc++MkTwcouTjMe4c69q2jXLrNG97qm31fk_FQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: add writethrough option
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 7:18 PM, Minchan Kim <minchan@kernel.org> wrote:
> Hello all,
>
> On Wed, Jan 22, 2014 at 12:33:58PM -0800, Andrew Morton wrote:
>> On Wed, 22 Jan 2014 09:19:58 -0500 Dan Streetman <ddstreet@ieee.org> wrote:
>>
>> > >>> > Acutally, I really don't know how much benefit we have that in-memory
>> > >>> > swap overcomming to the real storage but if you want, zRAM with dm-cache
>> > >>> > is another option rather than invent new wheel by "just having is better".
>> > >>>
>> > >>> I'm not sure if this patch is related to the zswap vs. zram discussions.  This
>> > >>> only adds the option of using writethrough to zswap.  It's a first
>> > >>> step to possibly
>> > >>> making zswap work more efficiently using writeback and/or writethrough
>> > >>> depending on
>> > >>> the system and conditions.
>> > >>
>> > >> The patch size is small. Okay I don't want to be a party-pooper
>> > >> but at least, I should say my thought for Andrew to help judging.
>> > >
>> > > Sure, I'm glad to have your suggestions.
>> >
>> > To give this a bump - Andrew do you have any concerns about this
>> > patch?  Or can you pick this up?
>>
>> I don't pay much attention to new features during the merge window,
>> preferring to shove them into a folder to look at later.  Often they
>> have bitrotted by the time -rc1 comes around.
>>
>> I'm not sure that this review discussion has played out yet - is
>> Minchan happy?
>
> From the beginning, zswap is for reducing swap I/O but if workingset
> overflows, it should write back rather than OOM with expecting a small
> number of writeback would make the system happy because the high memory
> pressure is temporal so soon most of workload would be hit in zswap
> without further writeback.
>
> If memory pressure continues and writeback steadily, it means zswap's
> benefit would be mitigated, even worse by addding comp/decomp overhead.
> In that case, it would be better to disable zswap, even.
>
> Dan said writethrough supporting is first step to make zswap smart
> but anybody didn't say further words to step into the smart and
> what's the *real* workload want it and what's the *real* number from
> that because dm-cache/zram might be a good fit.
> (I don't intend to argue zram VS zswap. If the concern is solved by
> existing solution, why should we invent new function and
> have maintenace cost?) so it's very hard for me to judge that we should
> accept and maintain it.
>
> We need blueprint for the future and make an agreement on the
> direction before merging this patch.

Well, I believe there are some cases where writeback will be better
and other cases where writethrough is better.  If we wait to add
writethrough until I or someone shows they have a specific use case
that performs better consistently with writethrough instead of
writeback, then of course I can try to find it, but I'm just one guy,
who has (relatively) very limited access to systems to test on.
Whereas if writethrough is in the kernel, anyone who wants to can test
to see if their workload performs better with writethrough.

Additionally, I think that it's possible to improve performance by
dynamically choosing wback or wthru - for example proactively wthru
swapping while there is not much IO and no immediate need for free
pages - the extra IO of wthru shouldn't really matter, but will help
if the swapped out page is eventually dropped from the zswap pool to
make room for more pages; while wback swapping makes more sense where
there's an immediate need for free pages and/or a high IO load.  Now
that zswap can significantly reduce the time to restore a swapped out
page, proactive swapping makes (IMHO) much more sense.

So I guess what I'm not clear on is, what level of blueprint do you
want to see?  I think that any more work will require a certain amount
of prototyping and testing, as well as a lot of feedback and
discussion...and to me, it makes more sense to add now this relatively
simple patch that, by default, changes nothing, so that more detailed
discussions and patches can follow without having to include this.

>
> But code size is not much and Seth already gave an his Ack so I don't
> want to hurt Dan any more(Sorry for Dan) and wasting my time so pass
> the decision to others(ex, Seth and Bob).
> If they insist on, I don't object any more.

Well I certainly don't want to insist on anything, I'd like to address
your concern about it.  If you would like to get deeper into
discussions about future possibilities before adding this patch, then
that's fine with me, as I don't think anyone is actually waiting to
use the patch by itself.  But I also don't want to waste your time, as
you said, with premature discussions before I've had a chance to do
any more investigation/prototyping work for whatever might follow onto
this.

Since you've said twice now you don't object as long as Seth, Bob, et.
al. are ok with the patch, I will assume you're still ok with adding
it also, but if you do want to discuss the future work now please do
let me know.

>
> Sorry for bothering Dan.

No bother at all.  Thanks for pushing me to clarify my thoughts!

>
> Thanks.
>
>>
>> Please update the changelog so that it reflects the questions Minchan
>> asked (any reviewer question should be regarded as an inadequacy in
>> either the code commenting or the changelog - people shouldn't need to
>> ask the programmer why he did something!) and resend for -rc1?
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> Kind regards,
> Minchan Kim
