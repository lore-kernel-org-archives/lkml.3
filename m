Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbaD3O3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbaD3O3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:29:10 -0400
Message-ID: <5361081A.5040602@redhat.com>
Date: Wed, 30 Apr 2014 10:26:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, sandeen@redhat.com, akpm@linux-foundation.org,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, mpatlasov@parallels.com,
        Motohiro.Kosaki@us.fujitsu.com
Subject: Re: [PATCH v2] mm,writeback: fix divide by zero in pos_ratio_polynom
References: <20140429151910.53f740ef@annuminas.surriel.com> <5360C9E7.6010701@jp.fujitsu.com> <20140430093035.7e7226f2@annuminas.surriel.com> <20140430134826.GH4357@dhcp22.suse.cz>
In-Reply-To: <20140430134826.GH4357@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 09:48 AM, Michal Hocko wrote:
> On Wed 30-04-14 09:30:35, Rik van Riel wrote:
> [...]
>> Subject: mm,writeback: fix divide by zero in pos_ratio_polynom
>>
>> It is possible for "limit - setpoint + 1" to equal zero, leading to a
>> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
>> working, so we need to actually test the divisor before calling div64.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>>   mm/page-writeback.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index ef41349..f98a297 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>>   					  unsigned long dirty,
>>   					  unsigned long limit)
>>   {
>> +	unsigned long divisor;
>>   	long long pos_ratio;
>>   	long x;
>>
>> +	divisor = limit - setpoint;
>> +	if (!divisor)
>> +		divisor = 1;	/* Avoid div-by-zero */
>> +
>
> This is still prone to u64 -> s32 issue, isn't it?
> What was the original problem anyway? Was it really setpoint > limit or
> rather the overflow?

Good point. I guess we need these divisors to be "int" and
"unsigned int" respectively, since those are the arguments
given to div_s64 and div_u64.

Let me send a v3 right now.

>>   	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
>> -		    limit - setpoint + 1);
>> +		    divisor);
>>   	pos_ratio = x;
>>   	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
>>   	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
>> @@ -842,8 +847,12 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
>>   	x_intercept = bdi_setpoint + span;
>>
>>   	if (bdi_dirty < x_intercept - span / 4) {
>> +		unsigned long divisor = x_intercept - bdi_setpoint;
>
> Same here.
>
>> +		if (!divisor)
>> +			divisor = 1;	/* Avoid div-by-zero */
>> +
>>   		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
>> -				    x_intercept - bdi_setpoint + 1);
>> +				    divisor);
>>   	} else
>>   		pos_ratio /= 4;
>>
>

