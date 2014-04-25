Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDYDjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:39:09 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45541 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaDYDjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140424073131.GA1098@swordfish>
References: <000001cf5ecf$f4f4f850$dedee8f0$%yang@samsung.com>
	<20140424020632.GA863@bbox>
	<20140424073131.GA1098@swordfish>
Date: Fri, 25 Apr 2014 11:39:05 +0800
Message-ID: <CAL1ERfODEr_oQ7oN1fdXcWoodbXUVRAbs1P2MD4+BVGLFZTHtA@mail.gmail.com>
Subject: Re: [PATCH RESEND] zram: correct offset usage in zram_bio_discard
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        Bob Liu <bob.liu@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 3:31 PM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> Hello Minchan,
>
> On (04/24/14 11:06), Minchan Kim wrote:
>> Hello,
>>
>> On Wed, Apr 23, 2014 at 04:41:15PM +0800, Weijie Yang wrote:
>> > We want to skip the physical block(PAGE_SIZE) which is partially
>> > covered by the discard bio, so we check the remaining size and
>> > subtract it if there is a need to goto the next physical block.
>> >
>> > The current offset usage in zram_bio_discard is incorrect, it will
>> > cause its upper filesystem breakdown.
>> > Consider the following scenario:
>> > on some architecture or config, PAGE_SIZE is 64K for example,
>> > filesystem is set up on zram disk without PAGE_SIZE aligned,
>> > a discard bio leads to a offset = 4K and size=72K,
>> > normally, it should not really discard any physical block as it
>> > partially cover two physical blocks.
>> > However, with the current offset usage, it will discard the second
>> > physical block and free its memory, which will cause filesystem breakdown.
>> >
>> > This patch corrects the offset usage in zram_bio_discard.
>>
>> Nice catch.
>> Surely we need fix but I'd like to go further. Let's think.
>> How do you find that? Real problem or code review?
>> I'd like to know how much that happens in real practice because if it's
>> a lot, it means discard support is just an overhead without any benefit.
>>
>> If you just found it with code review(ie, don't have any data),
>> would you mind adding some stat like 'num_discard/failed_discard' so
>> we can keep an eye on that. Although it's for rare case, I think it's worth.
>> Because someone would do swapon zram with --discard,
>> it could make same problem due to early page freeing of zram-swap to
>> avoid duplicating VM-owned memory and ZRAM-owned memory.
>>
>> We can guide to zram-swap user not to use swapon with --discard but
>> I don't want it because swap_slot_free_notify is really mess which
>> violates layering so I hope replace it with discard finally so such
>> statistics really help us to drive that way more quickly.
>>

Actually, I found this issue by code review not real practice.
I agree with you that it is worthy of adding some stat on discard behavior,
I will send a patch about it.

As to zram-swap, I think we could drop swap_slot_free_notify by using discard,
there is no technical issue as swap_extent is aligned to PAGE_SIZE and we
discard swap_cluster at a time.

However, what I worry about is that we can not force end-user to use --discard,
if someone forget it(we can not expect every end-user understand the
kernel mechanism),
he will not get the benefit of zram-swap and be confused.
So, is there any possibility that kernel do it transparently? May be
we need modify
the swap subsystem to surpport different hierarchical swapfiles.

Thanks for your advice, I really admire your further thinking.

>
> I second this. if we could drop swap_slot_free_notify that'd be nice.
>
>         -ss
>
>> >
>> > Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>> > Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> > ---
>> >  drivers/block/zram/zram_drv.c |    4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>> > index 9849b52..48eccb3 100644
>> > --- a/drivers/block/zram/zram_drv.c
>> > +++ b/drivers/block/zram/zram_drv.c
>> > @@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram *zram, u32 index,
>> >      * skipping this logical block is appropriate here.
>> >      */
>> >     if (offset) {
>> > -           if (n < offset)
>> > +           if (n <= (PAGE_SIZE - offset))
>> >                     return;
>> >
>> > -           n -= offset;
>> > +           n -= (PAGE_SIZE - offset);
>> >             index++;
>> >     }
>> >
>> > --
>> > 1.7.10.4
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>>
>> --
>> Kind regards,
>> Minchan Kim
>>
