Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaD3Ie6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:34:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:58788 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaD3Ie5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:34:57 -0400
Message-ID: <5360B5A5.5060101@parallels.com>
Date: Wed, 30 Apr 2014 12:34:45 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Rik van Riel <riel@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <sandeen@redhat.com>,
        <akpm@linux-foundation.org>, <jweiner@redhat.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
References: <20140429151910.53f740ef@annuminas.surriel.com> <5360AE74.7050100@parallels.com> <20140430081256.GA4357@dhcp22.suse.cz>
In-Reply-To: <20140430081256.GA4357@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.30.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 12:12 PM, Michal Hocko wrote:
> On Wed 30-04-14 12:04:04, Maxim Patlasov wrote:
>> Hi Rik!
>>
>> On 04/29/2014 11:19 PM, Rik van Riel wrote:
>>> It is possible for "limit - setpoint + 1" to equal zero, leading to a
>>> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
>>> working, so we need to actually test the divisor before calling div64.
>> The patch looks correct, but I'm afraid it can hide an actual bug in a
>> caller of pos_ratio_polynom(). The latter is not intended for setpoint >
>> limit. All callers take pains to ensure that setpoint <= limit. Look, for
>> example, at global_dirty_limits():
> The bug might trigger even if setpoint < limit because the result is
> trucated to s32 and I guess this is what is going on here?
> Is (limit - setpoint + 1) > 4G possible?

Yes, you are right. Probably the problem came from s32 overflow.

>
>>>      if (background >= dirty)
>>>         background = dirty / 2;
>> If you ever encountered "limit - setpoint + 1" equal zero, it may be worthy
>> to investigate how you came to setpoint greater than limit.
>>
>> Thanks,
>> Maxim
>>
>>> Signed-off-by: Rik van Riel <riel@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>   mm/page-writeback.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>> index ef41349..2682516 100644
>>> --- a/mm/page-writeback.c
>>> +++ b/mm/page-writeback.c
>>> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>>>   					  unsigned long dirty,
>>>   					  unsigned long limit)
>>>   {
>>> +	unsigned int divisor;
>>>   	long long pos_ratio;
>>>   	long x;
>>> +	divisor = limit - setpoint;
>>> +	if (!divisor)
>>> +		divisor = 1;
>>> +
>>>   	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
>>> -		    limit - setpoint + 1);
>>> +		    divisor);
>>>   	pos_ratio = x;
>>>   	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
>>>   	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;

