Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3HYMAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 08:00:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38601 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3HYMAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 08:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130823152859.GB5439@variantweb.net>
References: <CAL1ERfPzB=CvKJ6kAq2YYTkkg-EgSOWRyfSFWkvKp8ZdQkCDxA@mail.gmail.com>
	<20130823152859.GB5439@variantweb.net>
Date: Sun, 25 Aug 2013 20:00:53 +0800
Message-ID: <CAL1ERfPp8p=42+pyLzAeFUrUSt17ocHaDCtOrYNPmS=b+rsqGw@mail.gmail.com>
Subject: Re: [PATCH 1/4] zswap bugfix: memory leaks when re-swapon
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        weijie.yang@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/23 Seth Jennings <sjenning@linux.vnet.ibm.com>:
> On Fri, Aug 23, 2013 at 07:03:37PM +0800, Weijie Yang wrote:
>> zswap_tree is not freed when swapoff, and it got re-kzalloc in swapon,
>> memory leak occurs.
>> Add check statement in zswap_frontswap_init so that zswap_tree is
>> inited only once.
>>
>> ---
>>  mm/zswap.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index deda2b6..1cf1c07 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -826,6 +826,11 @@ static void zswap_frontswap_init(unsigned type)
>>  {
>>       struct zswap_tree *tree;
>>
>> +     if (zswap_trees[type]) {
>> +             BUG_ON(zswap_trees[type]->rbroot != RB_ROOT);  /* invalidate_area set it */
>
> Lets leave this BUG_ON() out.  If we want to make sure that the rbtree has
> been properly emptied out, we should do it in
> zswap_frontswap_invalidate_area() after the while loop and make it a
> WARN_ON() since the problem is not fatal.
>
> Seth
>

ok.

>> +             return;
>> +     }
>> +
>>       tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
>>       if (!tree)
>>               goto err;
>> --
>> 1.7.0.4
>>
>
