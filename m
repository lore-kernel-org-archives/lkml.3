Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbaD3Uf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbaD3UfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:35:23 -0400
Message-ID: <53615DEE.90808@redhat.com>
Date: Wed, 30 Apr 2014 16:32:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, mpatlasov@parallels.com,
        Motohiro.Kosaki@us.fujitsu.com
Subject: Re: [PATCH v4] mm,writeback: fix divide by zero in pos_ratio_polynom
References: <20140429151910.53f740ef@annuminas.surriel.com>	<5360C9E7.6010701@jp.fujitsu.com>	<20140430093035.7e7226f2@annuminas.surriel.com>	<20140430134826.GH4357@dhcp22.suse.cz>	<20140430104114.4bdc588e@cuia.bos.redhat.com>	<20140430120001.b4b95061ac7252a976b8a179@linux-foundation.org>	<53614F3C.8020009@redhat.com>	<20140430123526.bc6a229c1ea4addad1fb483d@linux-foundation.org>	<20140430160218.442863e0@cuia.bos.redhat.com> <20140430131353.fa9f49604ea39425bc93c24a@linux-foundation.org>
In-Reply-To: <20140430131353.fa9f49604ea39425bc93c24a@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 04:13 PM, Andrew Morton wrote:
> On Wed, 30 Apr 2014 16:02:18 -0400 Rik van Riel <riel@redhat.com> wrote:
>
>> I believe this should do the trick.
>>
>> ---8<---
>>
>> Subject: mm,writeback: fix divide by zero in pos_ratio_polynom
>>
>> It is possible for "limit - setpoint + 1" to equal zero, leading to a
>> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
>> working, so we need to actually test the divisor before calling div64.
>
> Changelog is a bit stale.

Will update.

>> -static inline long long pos_ratio_polynom(unsigned long setpoint,
>> +static long long pos_ratio_polynom(unsigned long setpoint,
>>   					  unsigned long dirty,
>>   					  unsigned long limit)
>>   {
>> +	unsigned long divisor;
>>   	long long pos_ratio;
>>   	long x;
>>
>> -	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
>> -		    limit - setpoint + 1);
>> +	divisor = limit - setpoint;
>> +	if (!divisor)
>> +		divisor = 1;	/* Avoid div-by-zero */
>
> This was a consequence of 64->32 truncation and it can't happen any
> more, can it?

That is a good question.  Looking at the code some more,
I guess it may indeed be exclusively due to the truncation,
and we can go back to the older code, just with the fully
64 bit divide functions...

Good thing Masayoshi-san has a reproducer :)

