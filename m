Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaLDCke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:40:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46643 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaLDCkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:40:32 -0500
Message-ID: <547FC990.5010100@oracle.com>
Date: Wed, 03 Dec 2014 21:40:16 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: adjtimex: validate the ADJ_FREQUENCY case
References: <1417652705-1959-1-git-send-email-sasha.levin@oracle.com> <CALAqxLUhheX1=jPmhTvnQyOH3X=+4Tgx5-kwQwQHj1c2YK+Neg@mail.gmail.com>
In-Reply-To: <CALAqxLUhheX1=jPmhTvnQyOH3X=+4Tgx5-kwQwQHj1c2YK+Neg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 08:09 PM, John Stultz wrote:
> On Wed, Dec 3, 2014 at 4:25 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Verify that the frequency value from userspace is valid and makes sense.
>>
>> Unverified values can cause overflows later on.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  kernel/time/ntp.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
>> index 87a346f..54828cf 100644
>> --- a/kernel/time/ntp.c
>> +++ b/kernel/time/ntp.c
>> @@ -633,6 +633,15 @@ int ntp_validate_timex(struct timex *txc)
>>         if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
>>                 return -EPERM;
>>
>> +       if (txc->modes & ADJ_FREQUENCY) {
>> +               if (!capable(CAP_SYS_TIME))
>> +                       return -EPERM;
> 
> So does this actually change behavior? We check CAP_SYS_TIME if modes
> is set to anything a few lines above (with the exception of
> ADJ_ADJTIME which only allows for ADJ_OFFSET_SINGLESHOT or
> ADJ_OFFSET_READONLY).
> 
> Granted, that logic isn't intuitive to read (and probably needs a
> cleanup) but seems ok.

No, it doesn't change behaviour. The logic, as you said, is a mess - so
I tried to keep this change (I actually have a few more which look very
similar) as readable and safe as possible

>> +               if (txc->freq < 0)
>> +                       return -EINVAL;
> 
> ?  Freq adjustments can be negative....  Am I just missing something here?

No, My bad, this should actually be:

	if (LONG_MIN / PPM_SCALE > txc->freq)
		return -EINVAL;

>> +               if (LONG_MAX / PPM_SCALE < txc->freq)
>> +                       return -EINVAL;
>> +       }
> 
> This part seems reasonable though. We bound the output, but overflows
> could result in negative result when it was specified positive.

The overflows could actually result in being anything, as this is considered
undefined behaviour.

> I'm curious: I know many of your patches come from trinity issues, but
> this one isn't super clear in the commit message how it was found. Did
> an actually issue crop up here, or was this just something you came up
> with while looking at the 3.18rc hang problem?

This is just me playing with the undefined behaviour/gcc5 patch and trinity,
it doesn't have anything to do with the hang problem.


Thanks,
Sasha

