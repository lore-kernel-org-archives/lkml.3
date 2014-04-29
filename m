Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaD2WsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaD2WsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:48:24 -0400
Message-ID: <53602C2B.50604@redhat.com>
Date: Tue, 29 Apr 2014 18:48:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz,
        fengguang.wu@intel.com, mpatlasov@parallels.com
Subject: Re: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
References: <20140429151910.53f740ef@annuminas.surriel.com> <20140429153936.49a2710c0c2bba4d233032f2@linux-foundation.org>
In-Reply-To: <20140429153936.49a2710c0c2bba4d233032f2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:39 PM, Andrew Morton wrote:
> On Tue, 29 Apr 2014 15:19:10 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
>> It is possible for "limit - setpoint + 1" to equal zero, leading to a
>> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
>> working, so we need to actually test the divisor before calling div64.
>>
>> ...
>>
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
>>  					  unsigned long dirty,
>>  					  unsigned long limit)
>>  {
>> +	unsigned int divisor;
> 
> I'm thinking this would be better as a ulong so I don't have to worry
> my pretty head over truncation things?

I looked at div_*64, and the second argument is a 32 bit
variable. I guess a long would be ok, since if we are
dividing by more than 4 billion we don't really care :)

static inline s64 div_s64(s64 dividend, s32 divisor)

> --- a/mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-pos_ratio_polynom-fix
> +++ a/mm/page-writeback.c
> @@ -597,13 +597,13 @@ static inline long long pos_ratio_polyno
>  					  unsigned long dirty,
>  					  unsigned long limit)
>  {
> -	unsigned int divisor;
> +	unsigned long divisor;
>  	long long pos_ratio;
>  	long x;
>  
>  	divisor = limit - setpoint;
>  	if (!divisor)
> -		divisor = 1;
> +		divisor = 1;	/* Avoid div-by-zero */

Works for me :)

-- 
All rights reversed
