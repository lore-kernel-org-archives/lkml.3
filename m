Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3LRSoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:44:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52601 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3LRSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:44:09 -0500
Message-ID: <52B1ECF5.2000204@linaro.org>
Date: Wed, 18 Dec 2013 10:44:05 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>, xen-devel@lists.xen.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] timekeeping: Fix potential lost pv notification of
 time change
References: <1387308457-25364-1-git-send-email-john.stultz@linaro.org> <1387308457-25364-3-git-send-email-john.stultz@linaro.org> <20131218100807.GC19319@gmail.com>
In-Reply-To: <20131218100807.GC19319@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 02:08 AM, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
>
>> In 780427f0e11 (Indicate that clock was set in the pvclock
>> gtod notifier), logic was added to pass a CLOCK_WAS_SET
>> notification to the pvclock notifier chain.
>>
>> While that patch added a action flag returned from
>> accumulate_nsecs_to_secs(), it only uses the returned value
>> in one location, and not in the logarithmic accumulation.
>>
>> This means if a leap second triggered during the logarithmic
>> accumulation (which is most likely where it would happen),
>> the notification that the clock was set would not make it to
>> the pv notifiers.
>>
>> This patch extends the logarithmic_accumulation pass down
>> that action flag so proper notification will occur.
>>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: David Vrabel <david.vrabel@citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Prarit Bhargava <prarit@redhat.com>
>> Cc: Richard Cochran <richardcochran@gmail.com>
>> Cc: <xen-devel@lists.xen.org>
>> Cc: stable <stable@vger.kernel.org> #3.11+
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  kernel/time/timekeeping.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 6bad3d9..998ec751 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -1295,7 +1295,7 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
>>   * Returns the unconsumed cycles.
>>   */
>>  static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
>> -						u32 shift)
>> +						u32 shift, unsigned int *action)
> I have two complaints about this patch:
>
> 1)
>
> I think the 'action' name sucks because it's too obfuscated. It's only 
> ever set to TK_CLOCK_WAS_SET, so why not name it more descriptively, 
> i.e. 'clock_was_set'?

Sure, I was reusing the existing variables, but no issue changing the
name here too.


> 2)
>
> Secondly, the proliferation of parameters passed around I think calls 
> for a helper structure which would carry the (offset, shift, 
> clock_was_set) triple:
>
> 	struct acc_params {
> 		cycle_t		offset;
> 		u32		shift;
> 		bool		clock_was_set;
> 	};
>
> And then passed down like this:
>
>>  static cycle_t logarithmic_accumulation(struct timekeeper *tk, struct acc_params *params)
> Agreed?

Huh. Ok, I don't see the parameters structure likely being reused, so
this would be a special struct only for the logarithmic_accumulation() call?

Also, since we want to pass down TK_CLOCK_WAS_SET to timekeeping_update,
you ok with clock_was_set being an int instead of a bool?

thanks
-john


