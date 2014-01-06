Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaAFTI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:08:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbaAFTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:08:27 -0500
Message-ID: <52CAFF2A.5060407@codeaurora.org>
Date: Mon, 06 Jan 2014 11:08:26 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 00/11] Intermix Lowmem and vmalloc
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org> <52C70024.1060605@sr71.net> <52C734F4.5020602@codeaurora.org> <20140104073143.GA5594@gmail.com>
In-Reply-To: <20140104073143.GA5594@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/2014 11:31 PM, Minchan Kim wrote:
> Hello,
>
> On Fri, Jan 03, 2014 at 02:08:52PM -0800, Laura Abbott wrote:
>> On 1/3/2014 10:23 AM, Dave Hansen wrote:
>>> On 01/02/2014 01:53 PM, Laura Abbott wrote:
>>>> The goal here is to allow as much lowmem to be mapped as if the block of memory
>>>> was not reserved from the physical lowmem region. Previously, we had been
>>>> hacking up the direct virt <-> phys translation to ignore a large region of
>>>> memory. This did not scale for multiple holes of memory however.
>>>
>>> How much lowmem do these holes end up eating up in practice, ballpark?
>>> I'm curious how painful this is going to get.
>>>
>>
>> In total, the worst case can be close to 100M with an average case
>> around 70M-80M. The split and number of holes vary with the layout
>> but end up with 60M-80M one hole and the rest in the other.
>
> One more thing I'd like to know is how bad direct virt <->phys tranlsation
> in scale POV and how often virt<->phys tranlsation is called in your worload
> so what's the gain from this patch?
>
> Thanks.
>

With one hole we did

#define __phys_to_virt(phys)
	phys >= mem_hole_end ? mem_hole : normal

We had a single global variable to check for the bounds and to do 
something similar with multiple holes the worst case would be O(number 
of holes). This would also all need to be macroized. Detection and 
accounting for these holes in other data structures (e.g. ARM meminfo) 
would be increasingly complex and lead to delays in bootup. The 
error/sanity checking for bad memory configurations would also be 
messier. Non-linear lowmem mappings also make debugging more difficult.

virt <-> phys translation is used on hot paths in IOMMU mapping so we 
want to keep virt <-> phys as fast as possible and not have to walk an 
array of addresses every time.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
