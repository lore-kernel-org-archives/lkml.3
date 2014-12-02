Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaLBPA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:00:28 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35217 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaLBPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:00:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141202093228.GA8792@hudson.localdomain>
References: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
	<1416890145-30048-1-git-send-email-john.stultz@linaro.org>
	<20141202093228.GA8792@hudson.localdomain>
Date: Tue, 2 Dec 2014 23:00:26 +0800
Message-ID: <CADcy93Wf9q1hyL43UwVjfCrWyn_PHSHJgLnzHvianjkxUxr2Sg@mail.gmail.com>
Subject: Re: [PATCH] time: Fix sign bug in ntp mult overflow warning
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Jeremiah Mahler <jmmahler@gmail.com>, John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 17:32, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> John,
>
> On Mon, Nov 24, 2014 at 08:35:45PM -0800, John Stultz wrote:
>> In commit 6067dc5a8c2b ("time: Avoid possible NTP adjustment mult
>> overflow") a new check was added to watch for adjustments that could
>> cause a mult overflow.
>>
>> Unfortunately the check compares a signed with unsigned value and
>> ignored the case where the adjustment was negative, which causes
>> spurious warn-ons on some systems (and seems like it would result in
>> problematic time adjustments there as well, due to the early
>> return).
>>
>> Thus this patch adds a check to make sure the adjustment is positive
>> before we check for an overflow, and resovles the issue in my
>> testing.
>>
>> Cc: pang.xunlei <pang.xunlei@linaro.org>
>> Cc: Fengguang Wu <fengguang.wu@intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Debugged-by: pang.xunlei <pang.xunlei@linaro.org>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  kernel/time/timekeeping.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 29a7d67..2dc0646 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -1330,7 +1330,7 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
>>        *
>>        * XXX - TODO: Doc ntp_error calculation.
>>        */
>> -     if (tk->tkr.mult + mult_adj < mult_adj) {
>> +     if ((mult_adj > 0) && (tk->tkr.mult + mult_adj < mult_adj)) {
>>               /* NTP adjustment caused clocksource mult overflow */
>>               WARN_ON_ONCE(1);
>>               return;
>
> This change does quiet the warning but I think it does so for the wrong
> reason.
>
> mult_adj is a signed number and tk->tkr.mult is an unsigned number.
> Adding the check that (mult_adj > 0) limits the test to only positive
> numbers.  A positive number plus a positive number will never be less
> than either of the two positive numbers.  The test is always false.

Hi Jeremiah,

The result of a positive number plus a positive number may overflow,
for example, u32  (0xFFFF_FFF0 + 0x20) will be 0x10,
that's what this patch is dealing with.

Thanks,
Xunlei
>
> --
> - Jeremiah Mahler
