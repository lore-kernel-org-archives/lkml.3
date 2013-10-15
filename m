Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3JOTA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:00:27 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48973 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606Ab3JOTAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131015103334.E3877E0090@blue.fi.intel.com>
References: <20131015001228.GE3432@hippobay.mtv.corp.google.com> <20131015103334.E3877E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 12:00:03 -0700
Message-ID: <CACz4_2eoRoyUU1G3veS=veWTi1HtPrgLQK0tyXONXcQj1Xi4EQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] mm, thp, tmpfs: split huge page when moving from
 page cache to swap
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me take another look at that logic. Thanks!
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Tue, Oct 15, 2013 at 3:33 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> in shmem_writepage, we have to split the huge page when moving pages
>> from page cache to swap because we don't support huge page in swap
>> yet.
>>
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/shmem.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 8fe17dd..68a0e1d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -898,6 +898,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>>       swp_entry_t swap;
>>       pgoff_t index;
>>
>> +     /* TODO: we have to break the huge page at this point,
>> +      * since we have no idea how to recover a huge page from
>> +      * swap.
>> +      */
>> +     if (PageTransCompound(page))
>> +             split_huge_page(compound_trans_head(page));
>> +
>
> After the split you handle here only first small page of the huge page.
> Is it what we want to do? Should we swap out all small pages of the huge
> page?
>
> --
>  Kirill A. Shutemov
