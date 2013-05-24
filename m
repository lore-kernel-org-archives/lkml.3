Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab3EXAoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 20:44:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39147 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3EXAoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 20:44:10 -0400
Message-ID: <519EB798.2080904@hp.com>
Date: Fri, 24 May 2013 08:43:04 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
References: <1369354931-19373-1-git-send-email-zhen-hual@hp.com> <1369355784.2080.5.camel@joe-AO722>
In-Reply-To: <1369355784.2080.5.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use lo and hi for clear, may run faster than memset.

But it is not a big problem.  Never mind.

Thanks
ZhenHua

On 05/24/2013 08:36 AM, Joe Perches wrote:
> On Fri, 2013-05-24 at 08:22 +0800, Li, Zhen-Hua wrote:
>> There is a structure named context_entry used by intel iommu, and there
>> are some bit operations on it. Use bit structure may make these operations
>> easy.
> []
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> []
>> @@ -221,55 +221,28 @@ get_context_addr_from_root(struct root_entry *root)
>>    * 8-23: domain id
>>    */
>>   struct context_entry {
>> -	u64 lo;
>> -	u64 hi;
>> +	union {
>> +		struct {
>> +			u64	present:1,
> why use struct and union at all?
>
> Why not just:
>
> struct context_entry {
> 	u64	present:1,
> 		fpd:1,
> 		translation_type:2,
> 		reserved_l:8,
> 		asr:52;
> 	u64	aw:3,
> 		avail:4,
> 		reserved_h1:1,
> 		did:16,
> 		reserved_h2:40;
> };
>
>> @@ -743,7 +716,8 @@ static void clear_context_table(struct intel_iommu *iommu, u8 bus, u8 devfn)
> []
>>   	if (context) {
>> -		context_clear_entry(&context[devfn]);
>> +		context[devfn].lo = 0;
>> +		context[devfn].hi = 0;
> 		memset(&context[devfn], 0, sizeof(...))
>
>

