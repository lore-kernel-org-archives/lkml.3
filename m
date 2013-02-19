Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab3BSTqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:46:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3BSTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:46:10 -0500
Date: Tue, 19 Feb 2013 14:46:08 -0500 (EST)
Message-Id: <20130219.144608.1425049879680985441.davem@davemloft.net>
To: rientjes@google.com
Cc: mroos@ut.ee, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1302191134570.790@chino.kir.corp.google.com>
References: <alpine.SOC.1.00.1302191405140.10147@math.ut.ee>
	<20130219.143320.1413047009797673492.davem@davemloft.net>
	<alpine.DEB.2.02.1302191134570.790@chino.kir.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 11:46:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Tue, 19 Feb 2013 11:37:30 -0800 (PST)

> On Tue, 19 Feb 2013, David Miller wrote:
> 
>> diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
>> index 7f64743..338b406 100644
>> --- a/arch/sparc/mm/tsb.c
>> +++ b/arch/sparc/mm/tsb.c
>> @@ -288,14 +288,13 @@ static unsigned long tsb_size_to_rss_limit(unsigned long new_size)
>>   * the number of entries that the current TSB can hold at once.  Currently,
>>   * we trigger when the RSS hits 3/4 of the TSB capacity.
>>   */
>> -void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
>> +void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss, gfp_t gfp)
>>  {
>>  	unsigned long max_tsb_size = 1 * 1024 * 1024;
>>  	unsigned long new_size, old_size, flags;
>>  	struct tsb *old_tsb, *new_tsb;
>>  	unsigned long new_cache_index, old_cache_index;
>>  	unsigned long new_rss_limit;
>> -	gfp_t gfp_flags;
>>  
>>  	if (max_tsb_size > (PAGE_SIZE << MAX_ORDER))
>>  		max_tsb_size = (PAGE_SIZE << MAX_ORDER);
>> @@ -312,12 +311,11 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
>>  		new_rss_limit = ~0UL;
>>  
>>  retry_tsb_alloc:
>> -	gfp_flags = GFP_KERNEL;
>>  	if (new_size > (PAGE_SIZE * 2))
>> -		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
>> +		gfp = __GFP_NOWARN | __GFP_NORETRY;
> 
> The existing code here already looks buggy for a different reason, it 
> should be gfp |= __GFP_NOWARN | __GFP_NORETRY;
> 
> I was wondering if you could get away with just a simple one-liner fix 
> above by doing
> 
> 	gfp_flags = rss ? GFP_KERNEL : GFP_NOWAIT;
> 
> but I agree this is more robust.

Thanks for noticing that bug.  I'll probably just fix the "=" to an "|="
for now.
