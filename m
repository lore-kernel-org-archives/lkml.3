Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaCFSFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:05:11 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34178 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaCFSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:05:07 -0500
Message-ID: <5318B8F2.8000107@gmail.com>
Date: Thu, 06 Mar 2014 19:05:38 +0100
From: Felix Rueegg <felix.rueegg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: ff-memless: don't schedule already playing effect
 to play again
References: <1393760143-5986-1-git-send-email-felix.rueegg@gmail.com> <20140304170731.GA30486@core.coreip.homeip.net>
In-Reply-To: <20140304170731.GA30486@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 03/04/2014 06:07 PM, Dmitry Torokhov wrote:
> Hi Felix,
>
> On Sun, Mar 02, 2014 at 12:35:43PM +0100, Felix Rueegg wrote:
>> When an effect with zero replay length, zero replay delay
>> and zero envelope attack length is uploaded, it is played and then scheduled to play
>> again one timer tick later. This triggers a warning (URB submitted while
>> active) in combination with the xpad driver.
>>
>> Skipping the rescheduling of this effect fixes the issue.
> Won't the same issue happen if we happen to schedule a different effect
> that would start at "now" time? We should not be "dropping" the new
> effect, at least not in core.
I can confirm this. It also happens sometimes with an effect that has a 
length and a replay count greater than one at the time, when the effect 
ends and restarts again.
> It looks to me xpad.c needs [more] love.
I agree and will try to come up with a fix for the xpad driver.

>> Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
>> ---
>>   drivers/input/ff-memless.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
>> index 74c0d8c..2e06948 100644
>> --- a/drivers/input/ff-memless.c
>> +++ b/drivers/input/ff-memless.c
>> @@ -139,10 +139,13 @@ static void ml_schedule_timer(struct ml_device *ml)
>>   		if (!test_bit(FF_EFFECT_STARTED, &state->flags))
>>   			continue;
>>   
>> -		if (test_bit(FF_EFFECT_PLAYING, &state->flags))
>> +		if (test_bit(FF_EFFECT_PLAYING, &state->flags)) {
>>   			next_at = calculate_next_time(state);
>> -		else
>> +			if (next_at == now)
>> +				continue;
>> +		} else {
>>   			next_at = state->play_at;
>> +		}
>>   
>>   		if (time_before_eq(now, next_at) &&
>>   		    (++events == 1 || time_before(next_at, earliest)))
>> -- 
>> 1.9.0
>>
> Thanks.
>

