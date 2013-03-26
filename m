Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3CZRfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:35:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56329 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3CZRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:35:50 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="32858068"
Message-ID: <5151DC75.7030606@codeaurora.org>
Date: Tue, 26 Mar 2013 10:35:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sched_clock: Add more notrace to prevent recursion
References: <1363306086-23501-1-git-send-email-sboyd@codeaurora.org> <514B483F.7000304@codeaurora.org>
In-Reply-To: <514B483F.7000304@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 10:49, Stephen Boyd wrote:
> On 03/14/13 17:08, Stephen Boyd wrote:
>> cyc_to_sched_clock() is called by sched_clock() and cyc_to_ns()
>> is called by cyc_to_sched_clock(). I suspect that some compilers
>> inline both of these functions into sched_clock() and so we've
>> been getting away without having a notrace marking. It seems that
>> my compiler isn't inlining cyc_to_sched_clock() though, so I'm
>> hitting a recursion bug when I enable the function graph tracer,
>> causing my system to crash. Marking these functions notrace fixes
>> it. Technically cyc_to_ns() doesn't need the notrace because it's
>> already marked inline, but let's just add it so that if we ever
>> remove inline from that function it doesn't blow up.
> Anyone else seeing this problem?

Russell, should I put this into the patch tracker?

>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/kernel/sched_clock.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
>> index bd6f56b..59d2adb 100644
>> --- a/arch/arm/kernel/sched_clock.c
>> +++ b/arch/arm/kernel/sched_clock.c
>> @@ -45,12 +45,12 @@ static u32 notrace jiffy_sched_clock_read(void)
>>  
>>  static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
>>  
>> -static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>> +static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>>  {
>>  	return (cyc * mult) >> shift;
>>  }
>>  
>> -static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
>> +static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
>>  {
>>  	u64 epoch_ns;
>>  	u32 epoch_cyc;


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

