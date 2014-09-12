Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaILQnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:43:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61621 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaILQno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140912045913.GA2160@bbox>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
 <1410468841-320-2-git-send-email-ddstreet@ieee.org> <20140912045913.GA2160@bbox>
From: Dan Streetman <ddstreet@ieee.org>
Date: Fri, 12 Sep 2014 12:43:22 -0400
X-Google-Sender-Auth: QUHnTu23jMfRXfdFdZFDWU9z46g
Message-ID: <CALZtONAuJhgZLJECxwQOyKPj2n02d+521d+eHCkqLjjc=Ba9FQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] zsmalloc: fix init_zspage free obj linking
To: Minchan Kim <minchan@kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:59 AM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Sep 11, 2014 at 04:53:52PM -0400, Dan Streetman wrote:
>> When zsmalloc creates a new zspage, it initializes each object it contains
>> with a link to the next object, so that the zspage has a singly-linked list
>> of its free objects.  However, the logic that sets up the links is wrong,
>> and in the case of objects that are precisely aligned with the page boundries
>> (e.g. a zspage with objects that are 1/2 PAGE_SIZE) the first object on the
>> next page is skipped, due to incrementing the offset twice.  The logic can be
>> simplified, as it doesn't need to calculate how many objects can fit on the
>> current page; simply checking the offset for each object is enough.
>
> If objects are precisely aligned with the page boundary, pages_per_zspage
> should be 1 so there is no next page.

ah, ok.  I wonder if it should be changed anyway so it doesn't rely on
that detail, in case that's ever changed in the future.  It's not
obvious the existing logic relies on that for correct operation.  And
this simplifies the logic too.

>
>>
>> Change zsmalloc init_zspage() logic to iterate through each object on
>> each of its pages, checking the offset to verify the object is on the
>> current page before linking it into the zspage.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>> Cc: Minchan Kim <minchan@kernel.org>
>> ---
>>  mm/zsmalloc.c | 14 +++++---------
>>  1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index c4a9157..03aa72f 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -628,7 +628,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
>>       while (page) {
>>               struct page *next_page;
>>               struct link_free *link;
>> -             unsigned int i, objs_on_page;
>> +             unsigned int i = 1;
>>
>>               /*
>>                * page->index stores offset of first object starting
>> @@ -641,14 +641,10 @@ static void init_zspage(struct page *first_page, struct size_class *class)
>>
>>               link = (struct link_free *)kmap_atomic(page) +
>>                                               off / sizeof(*link);
>> -             objs_on_page = (PAGE_SIZE - off) / class->size;
>>
>> -             for (i = 1; i <= objs_on_page; i++) {
>> -                     off += class->size;
>> -                     if (off < PAGE_SIZE) {
>> -                             link->next = obj_location_to_handle(page, i);
>> -                             link += class->size / sizeof(*link);
>> -                     }
>> +             while ((off += class->size) < PAGE_SIZE) {
>> +                     link->next = obj_location_to_handle(page, i++);
>> +                     link += class->size / sizeof(*link);
>>               }
>>
>>               /*
>> @@ -660,7 +656,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
>>               link->next = obj_location_to_handle(next_page, 0);
>>               kunmap_atomic(link);
>>               page = next_page;
>> -             off = (off + class->size) % PAGE_SIZE;
>> +             off %= PAGE_SIZE;
>>       }
>>  }
>>
>> --
>> 1.8.3.1
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
