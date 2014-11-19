Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaKSNGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:06:45 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45736 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaKSNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141118222936.GB20945@cerebellum.variantweb.net>
References: <000001d0030d$0505aaa0$0f10ffe0$%yang@samsung.com>
	<20141118222936.GB20945@cerebellum.variantweb.net>
Date: Wed, 19 Nov 2014 21:06:41 +0800
Message-ID: <CAL1ERfO6qoqCDyfEdJx3OCjdJjrsakSRG4SQhvzA6SL4NxO6uQ@mail.gmail.com>
Subject: Re: [PATCH] mm: frontswap: invalidate expired data on a dup-store failure
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Seth Jennings <sjennings@variantweb.net>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>,
        =?UTF-8?B?5p2O5bi45Z2k?= <xfishcoder@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 6:29 AM, Seth Jennings <sjennings@variantweb.net> wrote:
> On Tue, Nov 18, 2014 at 04:51:36PM +0800, Weijie Yang wrote:
>> If a frontswap dup-store failed, it should invalidate the expired page
>> in the backend, or it could trigger some data corruption issue.
>> Such as:
>> 1. use zswap as the frontswap backend with writeback feature
>> 2. store a swap page(version_1) to entry A, success
>> 3. dup-store a newer page(version_2) to the same entry A, fail
>> 4. use __swap_writepage() write version_2 page to swapfile, success
>> 5. zswap do shrink, writeback version_1 page to swapfile
>> 6. version_2 page is overwrited by version_1, data corrupt.
>
> Good catch!
>
>>
>> This patch fixes this issue by invalidating expired data immediately
>> when meet a dup-store failure.
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>> ---
>>  mm/frontswap.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/frontswap.c b/mm/frontswap.c
>> index c30eec5..f2a3571 100644
>> --- a/mm/frontswap.c
>> +++ b/mm/frontswap.c
>> @@ -244,8 +244,10 @@ int __frontswap_store(struct page *page)
>>                 the (older) page from frontswap
>>                */
>>               inc_frontswap_failed_stores();
>> -             if (dup)
>> +             if (dup) {
>>                       __frontswap_clear(sis, offset);
>> +                     frontswap_ops->invalidate_page(type, offset);
>
> Looking at __frontswap_invalidate_page(), should we do
> inc_frontswap_invalidates() too?  If so, maybe we should just call
> __frontswap_invalidate_page().

The frontswap_invalidate_page() is for swap_entry_free, while here
is an inner ops for dup-store, so I think there is no need for
inc_frontswap_invalidates().

> Thanks,
> Seth
>
>> +             }
>>       }
>>       if (frontswap_writethrough_enabled)
>>               /* report failure so swap also writes to swap device */
>> --
>> 1.7.0.4
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
