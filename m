Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3BUTd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:33:59 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:64600 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3BUTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:33:58 -0500
Message-ID: <51267695.8090800@synopsys.com>
Date: Fri, 22 Feb 2013 01:03:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Marc Gauthier <marc@tensilica.com>, Tejun Heo <tj@kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] memblock: add assertion for zero allocation size
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com> <1361471962-25164-2-git-send-email-vgupta@synopsys.com> <CAE9FiQXSPHjRsCWcHpz7s1gQjNGuj5_X_YE2Ln=EA7_-Ka_cNg@mail.gmail.com>
In-Reply-To: <CAE9FiQXSPHjRsCWcHpz7s1gQjNGuj5_X_YE2Ln=EA7_-Ka_cNg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 12:57 AM, Yinghai Lu wrote:
> [+Cc: hpa]
>
> On Thu, Feb 21, 2013 at 10:39 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> This came to light when calling memblock allocator from arc port (for
>> copying flattended DT). If a "0" alignment is passed, the allocator
>> round_up() call incorrectly rounds up the size to 0.
>>
>> round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1
>>
>> While the obvious allocation failure causes kernel to panic, it is
>> better to BUG_ON() if effective size for allocation (as passed by caller
>> and/or computed after alignemtn rounding) is zero.
> should we just make align to 1 instead of 0 ?

Where - you mean if user passes 0, just make it 1. Nah - it's better to complain
and get the call site fixed !

> or BUG_ON(!align) instead?

That could be done too but you would also need BUG_ON(!size) - to catch another
API abuse.
BUG_ON(!size) however catches both the cases.


>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/memblock.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 1bcd9b9..32b36d0 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -824,6 +824,8 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
>>         /* align @size to avoid excessive fragmentation on reserved array */
>>         size = round_up(size, align);
>>
>> +       BUG_ON(!size);
>> +
>>         found = memblock_find_in_range_node(0, max_addr, size, align, nid);
>>         if (found && !memblock_reserve(found, size))
>>                 return found;
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

