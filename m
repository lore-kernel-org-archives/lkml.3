Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbaD2UAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:00:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46479 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaD2UAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:00:44 -0400
Message-ID: <536004E9.1010300@codeaurora.org>
Date: Tue, 29 Apr 2014 13:00:41 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] PM / devfreq: Use freq_table for available_frequencies
References: <4324793.197151398649314597.JavaMail.weblogic@epv6ml10>
In-Reply-To: <4324793.197151398649314597.JavaMail.weblogic@epv6ml10>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 06:41 PM, MyungJoo Ham wrote:
>> Some devices use freq_table instead of OPP. For those devices, the
>> available_frequencies file shows up empty. Fix that by using freq_table to
>> generate the available_frequencies data when it's available.
>>
>> OPP find frequency APIs also skips frequencies that have been temporarily
>> disabled (say, due to thermal, etc). Since available_frequencies is
>> supposed to show the entire list of available frequencies without taking
>> temporary limits into consideration, preference is given to freq_table when
>> available.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>   drivers/devfreq/devfreq.c | 29 ++++++++++++++++++-----------
>>   1 file changed, 18 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 2042ec3..527cbe2 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -912,20 +912,27 @@ static ssize_t available_frequencies_show(struct device *d,
>>   	struct devfreq *df = to_devfreq(d);
>>   	struct device *dev = df->dev.parent;
>>   	struct dev_pm_opp *opp;
>> +	unsigned int i = 0;
>>   	ssize_t count = 0;
>>   	unsigned long freq = 0;
>>   
>> -	rcu_read_lock();
>> -	do {
>> -		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
>> -		if (IS_ERR(opp))
>> -			break;
>> -
>> -		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
>> -				   "%lu ", freq);
>> -		freq++;
>> -	} while (1);
>> -	rcu_read_unlock();
>> +	if (df->profile->freq_table) {
>> +		for (i = 0; i < df->profile->max_state; i++)
>> +			count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
>> +					   "%u ", df->profile->freq_table[i]);
> 
> You are hereby changing the semmantics of the original
> available_frequencies node.
> 
> When a frequency/voltage pair has been disabled (opp_disable), probably
> by opp_disable(), the frequency is no more "available".
> However, when the driver author supplied freq_table as well as OPP
> in order to see the statistics, the node will behave differently.
> 
> Please do not affect the current users as long as it does not give
> additional benefit or fix a bug.

I was actually trying to stick with the semantics as it was documented.
The documentation for this file says it'll show frequencies that are not
allowed by the current min/max settings either. To me, an OPP disable
seems similar to some frequencies "disabled" by min/max settings.

Giving preference to OPP is not a hard change to do, but it seems to go
againsts the documented semantics.

Thoughts?

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
