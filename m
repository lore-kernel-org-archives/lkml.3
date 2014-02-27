Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaB0ApR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:45:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55703 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaB0ApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:45:15 -0500
Message-ID: <530E8A99.50402@codeaurora.org>
Date: Wed, 26 Feb 2014 16:45:13 -0800
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
Subject: Re: [PATCH] PM / devfreq: Fix out of bounds access of transition
 table array
References: <19338058.266151393391521988.JavaMail.weblogic@epml02>
In-Reply-To: <19338058.266151393391521988.JavaMail.weblogic@epml02>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 09:12 PM, ÇÔ¸íÁÖ wrote:
>> On 02/23/2014 11:15 PM, Saravana Kannan wrote:
>>> The previous_freq value for a device could be an invalid frequency that
>>> results in a error value being returned from devfreq_get_freq_level().
>>> Check for an error value before using that to index into the transition
>>> table.
>>>
>>> Not doing this check will result in memory corruption when previous_freq is
>>> not a valid frequency.
>>>
>>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>>
>> MyungJoo/Kyungmin,
>>
>> Would either of you have some time to respond to this?
>>
>> Thanks,
>> Saravana
> 
> Dear Saravana,
> 
>>> +	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
>>> +	if (prev_lev < 0)
>>> +		return 0;
> 
> If devfreq_get_freq_level returned error, please return that error
> to the caller. You are retuning 0 in that case.
> 
> Plus, do you think we are going to change profile->freq_table in run-time?
> (by accidently? or intentionally?)

Hi MyungJoo,

The reason for this fix is that some devices can't reliably detect their
current frequency. So, we set the initial freq to 0 so that the first
request from the default governor actually goes through.

If we randomly pick one of the valid frequencies, then the initial
request could get short circuited by devfreq, cause wrong stats, the
device itself might short circuit it after comparing it to prev freq, etc.

The reason I intentionally ignored the error was to prevent printing an
error at boot every time for such devices. I could do better with more
complicated code, but I couldn't imagine any other case where
previous_freq could actually end up being an invalid value.

Hold on, I just realized that the stats code is completely wrong! Isn't
the current code updating the time_in_state[] of the wrong level? It's
updating the new level's time in state instead of the previous one?

I'll send out a patch that fixes all this with in a couple of days.

Thanks,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
