Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3CKFBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:01:46 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:41877 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vpLumng7bXpAYD3+e8MfR6ge-9qduAaMiJWmcHnxfnrMg@mail.gmail.com>
References: <1362654678.6034.2.camel@anish-Inspiron-N5050>
	<CAK7N6vpLumng7bXpAYD3+e8MfR6ge-9qduAaMiJWmcHnxfnrMg@mail.gmail.com>
Date: Mon, 11 Mar 2013 10:31:44 +0530
Message-ID: <CAK7N6vo0w=YVFzifoJN8EKqfP_56dmXiGtsEt1QBN4G+muFwBQ@mail.gmail.com>
Subject: Re: [PATCH] [Timer][Trivial] __clocksource_register_scale return
 value use?
From: anish singh <anish198519851985@gmail.com>
To: tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK or NACK this patch please.

On Sat, Mar 9, 2013 at 11:33 AM, anish singh
<anish198519851985@gmail.com> wrote:
> ping
>
> On Thu, Mar 7, 2013 at 4:41 PM, anish kumar <anish198519851985@gmail.com> wrote:
>> __clocksource_register_scale() currently returns int but it should
>> return void as there are no error paths in that function.
>> Making it void would help some amount of code to be removed at various
>> places.
>>
>> clocksource_register_hz/khz() return value is checked
>> in most of the places but I think it will translate to always
>> if(true) so let's remove those checks as well(patch will be sent
>> later for that).
>>
>> Is this return value for some future usecase(?), if yes then my
>> apologies.
>>
>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> ---
>>  include/linux/clocksource.h |    6 +++---
>>  kernel/time/clocksource.c   |    7 +------
>>  2 files changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
>> index 27cfda4..2b074cc 100644
>> --- a/include/linux/clocksource.h
>> +++ b/include/linux/clocksource.h
>> @@ -294,17 +294,17 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32
>> from, u32 to, u32 minsec);
>>   * Don't call __clocksource_register_scale directly, use
>>   * clocksource_register_hz/khz
>>   */
>> -extern int
>> +extern void
>>  __clocksource_register_scale(struct clocksource *cs, u32 scale, u32
>> freq);
>>  extern void
>>  __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32
>> freq);
>>
>> -static inline int clocksource_register_hz(struct clocksource *cs, u32
>> hz)
>> +static inline void clocksource_register_hz(struct clocksource *cs, u32
>> hz)
>>  {
>>         return __clocksource_register_scale(cs, 1, hz);
>>  }
>>
>> -static inline int clocksource_register_khz(struct clocksource *cs, u32
>> khz)
>> +static inline void clocksource_register_khz(struct clocksource *cs, u32
>> khz)
>>  {
>>         return __clocksource_register_scale(cs, 1000, khz);
>>  }
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index c958338..1915550 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -703,14 +703,11 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>>   * @scale:     Scale factor multiplied against freq to get clocksource hz
>>   * @freq:      clocksource frequency (cycles per second) divided by scale
>>   *
>> - * Returns -EBUSY if registration fails, zero otherwise.
>> - *
>>   * This *SHOULD NOT* be called directly! Please use the
>>   * clocksource_register_hz() or clocksource_register_khz helper
>> functions.
>>   */
>> -int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32
>> freq)
>> +void __clocksource_register_scale(struct clocksource *cs, u32 scale,
>> u32 freq)
>>  {
>> -
>>         /* Initialize mult/shift and max_idle_ns */
>>         __clocksource_updatefreq_scale(cs, scale, freq);
>>
>> @@ -720,11 +717,9 @@ int __clocksource_register_scale(struct clocksource
>> *cs, u32 scale, u32 freq)
>>         clocksource_enqueue_watchdog(cs);
>>         clocksource_select();
>>         mutex_unlock(&clocksource_mutex);
>> -       return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(__clocksource_register_scale);
>>
>> -
>>  /**
>>   * clocksource_register - Used to install new clocksources
>>   * @cs:                clocksource to be registered
>> --
>> 1.7.1
>>
>>
