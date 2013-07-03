Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3GCCoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:44:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54019 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3GCCoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:44:22 -0400
Message-ID: <51D39004.9000907@wwwdotorg.org>
Date: Tue, 02 Jul 2013 20:44:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org> <20130702232259.GH11625@codeaurora.org>
In-Reply-To: <20130702232259.GH11625@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 05:22 PM, Stephen Boyd wrote:
> On 07/02, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Commit 281ecb7 "arm: delete __cpuinit/__CPUINIT usage from all ARM
>> users" removed a __CPUINIT from head-common.S. However, the code
>> immediately before the removed tag was marked __INIT, and was missing
>> a match __FINIT. This caused code after the removed __CPUINIT to end
>> up in the init section rather than the main text section as desired.
>> This caused issues such as secondary CPU boot failures or crashes.
>> Add the missing __FINIT to solve this.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>  arch/arm/kernel/head-common.S | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
>> index 529ce99..a9dc804 100644
>> --- a/arch/arm/kernel/head-common.S
>> +++ b/arch/arm/kernel/head-common.S
>> @@ -122,6 +122,8 @@ __mmap_switched_data:
>>  	.long	init_thread_union + THREAD_START_SP @ sp
>>  	.size	__mmap_switched_data, . - __mmap_switched_data
>>  
>> +	__FINIT
>> +
>>  /*
>>   * This provides a C-API version of __lookup_processor_type
>>   */
> 
> Shouldn't this come after lookup_processor_type()? Otherwise you
> just removed that function from the init section?

I think this is correct. Prior to "arm: delete __cpuinit/__CPUINIT usage
from all ARM users", lookup_processor_type() was in the cpuinit section.
After that commit, it moved to the init section and hence got dumped
soon after boot. The change above moves lookup_processor_type() back
into the regular text section, which I believe was the intent of the
__cpuinit removal patch.
