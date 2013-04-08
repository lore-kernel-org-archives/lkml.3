Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab3DHOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:42:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45439 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462Ab3DHOmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:42:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="36553279"
Message-ID: <5162D750.9050706@codeaurora.org>
Date: Mon, 08 Apr 2013 10:42:24 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] arm64: Fix task tracing
References: <1365012061-31660-1-git-send-email-cov@codeaurora.org> <20130403180443.GB21167@mudshark.cambridge.arm.com>
In-Reply-To: <20130403180443.GB21167@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 04/03/2013 02:04 PM, Will Deacon wrote:
> Hi Christopher,
> 
> On Wed, Apr 03, 2013 at 07:01:01PM +0100, Christopher Covington wrote:
>> For accurate accounting call contextidr_thread_switch before a
>> task is scheduled, rather than after.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>>  arch/arm64/kernel/process.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 0337cdb..c2cc249 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -311,11 +311,11 @@ struct task_struct *__switch_to(struct task_struct *prev,
>>  	fpsimd_thread_switch(next);
>>  	tls_thread_switch(next);
>>  	hw_breakpoint_thread_switch(next);
>> +	contextidr_thread_switch(next);
>>  
>>  	/* the actual thread switch */
>>  	last = cpu_switch_to(prev, next);
>>  
>> -	contextidr_thread_switch(next);
>>  	return last;
>>  }
> 
> Catalin and I wondered about this and decided to go with the current
> approach in case a debugger, in response to the contextidr write, decided to
> go off and mine information about the *new* task using the sp.

The problem with the existing implementation is that it doesn't seem to
compensate for how cpu_switch_to changes the stack pointer. Consider the
following sequence.

cpu_switch_to(prev=A, next=B)
cpu_switch_to(prev=B, next=C)
cpu_switch_to(prev=C, next=A)

After the third call, using A's stack, next will be B, and its thread ID will
be written to CONTEXTIDR. An easy way to see this in a simulator is to just
instrument the code with some printk's.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
