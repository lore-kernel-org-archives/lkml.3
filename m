Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3AQMaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:30:23 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:47567 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3AQMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:30:22 -0500
Message-ID: <50F7EED3.1050309@oldelvet.org.uk>
Date: Thu, 17 Jan 2013 12:30:11 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc: kernel/sbus.c: fix memory leakage
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com> <20130116211309.GA13993@merkur.ravnborg.org> <20130116211725.GC18593@gmail.com> <20130116220018.GA14063@merkur.ravnborg.org> <20130116220153.GD18593@gmail.com> <50F7D577.8010506@oldelvet.org.uk> <20130117115637.GB25615@gmail.com>
In-Reply-To: <20130117115637.GB25615@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/01/2013 11:56, Cong Ding wrote:
> On Thu, Jan 17, 2013 at 10:41:59AM +0000, Richard Mortimer wrote:
>>
>>
>> On 16/01/2013 22:01, Cong Ding wrote:
>>> the variable iommu and strbuf are not freed if it goes to error.
>>>
>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>> ---
>>>   arch/sparc/kernel/sbus.c |    2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
>>> index 1271b3a..78aa26b 100644
>>> --- a/arch/sparc/kernel/sbus.c
>>> +++ b/arch/sparc/kernel/sbus.c
>>> @@ -656,6 +656,8 @@ static void __init sbus_iommu_init(struct platform_device *op)
>>>   	return;
>>>
>>>   fatal_memory_error:
>>> +	kfree(strbuf);
>>
>> strbuf will be uninitialized if the iommu allocation fails. I don't
>> have a particular preference for how to fix this but tend to dislike
>> initial assignment with NULL because it hides other control flow
>> issues.
> Sorry I didn't notice strbuf will be uninitialized here. But if we don't
> initially assign a NULL value to strbuf, I cannot find a way to handle it
> besides the first version patch. Did you have any suggestions? For me, I like
> the first version.

Two thoughts...

1 - just use a goto target for the iommu allocation failure and make 
that skip the strbuf free call. The others use the existing 
fatal_memory_error label.

2 - Move the strbuf kzalloc up 2 lines so that it occurs before the test 
for iommu.

2b - In case (2) above the failure test could be changed to
if (!iommu || !strbuf)
to remove duplication of goto.

I'd probably go for 2/2b to address Sam's initial comment.

Regards

Richard


> - cong
>>
>> Regards
>>
>> Richard
>>
>>> +	kfree(iommu);
>>>   	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
>>>   }
>>>
>>>
