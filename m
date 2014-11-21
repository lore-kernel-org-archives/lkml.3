Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbaKUO4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:56:12 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35451 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaKUO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141121103232.GA31540@blaptop>
References: <1416489716-9967-1-git-send-email-opensource.ganesh@gmail.com>
	<20141121035442.GB10123@bbox>
	<CADAEsF975+a6Y5dcEu1B2OscQ5JaxD+ZQ1jnFOJ115BXgMqULA@mail.gmail.com>
	<20141121064849.GA17181@gmail.com>
	<20141121103232.GA31540@blaptop>
Date: Fri, 21 Nov 2014 22:56:10 +0800
Message-ID: <CADAEsF8L1J_HgQi+v_jo1x43RxpGNWXcgMNdzRoNiL4fv0ucPA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/zsmalloc: remove unnecessary check
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan

2014-11-21 18:32 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> On Fri, Nov 21, 2014 at 06:48:49AM +0000, Minchan Kim wrote:
>> On Fri, Nov 21, 2014 at 01:33:26PM +0800, Ganesh Mahendran wrote:
>> > Hello
>> >
>> > 2014-11-21 11:54 GMT+08:00 Minchan Kim <minchan@kernel.org>:
>> > > On Thu, Nov 20, 2014 at 09:21:56PM +0800, Mahendran Ganesh wrote:
>> > >> ZS_SIZE_CLASSES is calc by:
>> > >>   ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1)
>> > >>
>> > >> So when i is in [0, ZS_SIZE_CLASSES - 1), the size:
>> > >>   size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA
>> > >> will not be greater than ZS_MAX_ALLOC_SIZE
>> > >>
>> > >> This patch removes the unnecessary check.
>> > >
>> > > It depends on ZS_MIN_ALLOC_SIZE.
>> > > For example, we would change min to 8 but MAX is still 4096.
>> > > ZS_SIZE_CLASSES is (4096 - 8) / 16 + 1 = 256 so 8 + 255 * 16 = 4088,
>> > > which exceeds the max.
>> > Here, 4088 is less than MAX(4096).
>> >
>> > ZS_SIZE_CLASSES = (MAX - MIN) / Delta + 1
>> > So, I think the value of
>> >     MIN + (ZS_SIZE_CLASSES - 1) * Delta =
>> >     MIN + ((MAX - MIN) / Delta) * Delta =
>> >     MAX
>> > will not exceed the MAX
>>
>> You're right. It was complext math for me.
>> I should go back to elementary school.
>>
>> Thanks!
>>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>
> I catch a nasty cold but above my poor math makes me think more.
> ZS_SIZE_CLASSES is broken. In above my example, current code cannot
> allocate 4096 size class so we should correct ZS_SIZE_CLASSES
> at first.
>
> zs_size_classes = zs_max - zs_min / delta + 1;
> if ((zs_max - zs_min) % delta)
>         zs_size_classes += 1;
Yes, you are right.
When the zs_min is less than delta, we can not allocate PAGE_SIZE size class.

>
> Then, we need to code piece you removed.
> As well, we need to fix below.
>
> - area->vm_buf = (char *)__get_free_page(GFP_KERNEL);
> + area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE);
If our purpose is to allocate the max obj size as len of PAGE_SIZE, we
do not need to
change this line. Since the ZS_MAX_ALLOC_SIZE will always be PAGE_SIZE

Thanks.

>
> Hope I am sane in this time :(
