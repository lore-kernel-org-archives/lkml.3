Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3GQJbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:31:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10628 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3GQJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:31:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Jul 2013 02:29:21 -0700
Message-ID: <51E663FC.5050209@nvidia.com>
Date: Wed, 17 Jul 2013 17:29:32 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status
 bit
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-3-git-send-email-wni@nvidia.com> <20130715185727.4ebde8c4@endymion.delvare>	<51E641C7.4000107@nvidia.com> <20130717102803.6ee36313@endymion.delvare>
In-Reply-To: <20130717102803.6ee36313@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 04:28 PM, Jean Delvare wrote:
> Hi Wei,
> 
> On Wed, 17 Jul 2013 15:03:35 +0800, Wei Ni wrote:
>> On 07/16/2013 12:57 AM, Jean Delvare wrote:
>>> On Fri, 12 Jul 2013 15:48:05 +0800, Wei Ni wrote:
>>>> Add bit defines for the status register.
>>>
>>> Regarding the subject: for me these are constants, not macros. AFAIK
>>> the term "macro" refers to defines with parameters only.
>>
>> How about "Introduce status bits"
> 
> I'd say "Define status bits" as this is exactly what you're doing ;-)
> That being said, your patch actually does more than this, as you are
> moving code around and to a separate function. The patch description
> should say that and explain why.

ok, I will update it in my next version.

> 
>>>> (...)
>>>> +	if ((status & 0x7f) == 0 && (status2 & 0xfe) == 0)
>>>> +		return false;
>>>
>>> It's a bit disappointing to not use the freshly introduced constants.
>>> That being said I agree it would make the code hard to read, so you can
>>> leave it as is.
>>
>> Sorry, I forgot it.
>> How about to define:
>> #define LM90_STATUS_MASK 0x7f
>> #define MAX6696_STATUS2_MASK 0xfe
> 
> I wouldn't bother. I suspect that this code will have to be reworked
> soon anyway and these constants may no longer be needed then.

Ok, let's leave it as is.

> 
>> Or since Guenter is for vacation, I can just leave it as is, and wait
>> him back to talk about below issue.
> 
> I do maintain the lm90 driver, so the decision is up to me. Guenter did
> a preliminary review of your patches and I am grateful for that, but I
> do not intend to wait for his return to continue with your patches.
> Otherwise he will have to do the same when he returns and I am gone,
> and this may end up delaying your patches by one kernel version.

I will send out patches soon :)

> 
>>>> (...)
>>>> +		struct lm90_data *data = i2c_get_clientdata(client);
>>>> +		u8 config, alarms;
>>>> +
>>>> +		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
>>>
>>> You end up reading LM90_REG_R_STATUS, which is not OK. This register
>>> contains self-clearing bits, so there is no guarantee that the second
>>> read will return the same value as the first read. You'll have to come
>>> up with a different approach that reads LM90_REG_R_STATUS only once.
>>
>> Oh, yes, this is a problem, I didn't noticed it.
>> How about to use this:
>> bool lm90_alarms_tripped(*client, *status);
>> bool lm90_alarms2_tripped(*client, *status2);
>> So we can read the status only once and pass it.
> 
> This is a good idea but you only need status, not status2, so it can be
> made simpler:
> bool lm90_is_tripped(*client, *status);
> (handling both status and status 2 as you already do.)

Yes this is simpler, but I think in the future we may need to handle the
status2, how to handle it ? Or we can define the status as
bit[0~7]->status and bit[8~15]->status2 .

> 

