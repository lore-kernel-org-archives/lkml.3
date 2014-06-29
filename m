Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaF2TiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:38:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60766 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaF2TiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:38:12 -0400
Message-ID: <53B06B22.9090203@codeaurora.org>
Date: Sun, 29 Jun 2014 12:38:10 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: David Riley <davidriley@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3 2/5] lib/genalloc.c: Add genpool range check function
References: <1402969165-7526-1-git-send-email-lauraa@codeaurora.org> <1402969165-7526-3-git-send-email-lauraa@codeaurora.org> <20140620093856.GM25104@arm.com>
In-Reply-To: <20140620093856.GM25104@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2014 2:38 AM, Will Deacon wrote:
> On Tue, Jun 17, 2014 at 02:39:22AM +0100, Laura Abbott wrote:
>> After allocating an address from a particular genpool,
>> there is no good way to verify if that address actually
>> belongs to a genpool. Introduce addr_in_gen_pool which
>> will return if an address plus size falls completely
>> within the genpool range.
>>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>> ---
>>  include/linux/genalloc.h |  3 +++
>>  lib/genalloc.c           | 29 +++++++++++++++++++++++++++++
>>  2 files changed, 32 insertions(+)
>>
>> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
>> index 3cd0934..1ccaab4 100644
>> --- a/include/linux/genalloc.h
>> +++ b/include/linux/genalloc.h
>> @@ -121,6 +121,9 @@ extern struct gen_pool *devm_gen_pool_create(struct device *dev,
>>  		int min_alloc_order, int nid);
>>  extern struct gen_pool *dev_get_gen_pool(struct device *dev);
>>  
>> +bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
>> +			size_t size);
>> +
>>  #ifdef CONFIG_OF
>>  extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
>>  	const char *propname, int index);
>> diff --git a/lib/genalloc.c b/lib/genalloc.c
>> index 9758529..66edf93 100644
>> --- a/lib/genalloc.c
>> +++ b/lib/genalloc.c
>> @@ -403,6 +403,35 @@ void gen_pool_for_each_chunk(struct gen_pool *pool,
>>  EXPORT_SYMBOL(gen_pool_for_each_chunk);
>>  
>>  /**
>> + * addr_in_gen_pool - checks if an address falls within the range of a pool
>> + * @pool:	the generic memory pool
>> + * @start:	start address
>> + * @size:	size of the region
>> + *
>> + * Check if the range of addresses falls within the specified pool. Takes
>> + * the rcu_read_lock for the duration of the check.
>> + */
>> +bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
>> +			size_t size)
>> +{
>> +	bool found = false;
>> +	unsigned long end = start + size;
>> +	struct gen_pool_chunk *chunk;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk) {
>> +		if (start >= chunk->start_addr && start <= chunk->end_addr) {
> 
> Why do you need to check start against the end of the chunk? Is that in case
> of overflow?
> 

Yes, this provides an extra check for overflow and also matches similar logic for
gen_pool_virt_to_phys.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
