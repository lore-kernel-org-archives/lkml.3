Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161074Ab3BGScy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:32:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161017Ab3BGScw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:32:52 -0500
Message-ID: <5113F05E.30001@redhat.com>
Date: Thu, 07 Feb 2013 13:20:14 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFE PATCH] time, Fix setting of hardware clock in NTP code
References: <1360243741-25213-1-git-send-email-prarit@redhat.com> <CANcMJZAYY779QNCBV5OR7_ybk=RFqNazwPxUsWt12G60aiRuSw@mail.gmail.com>
In-Reply-To: <CANcMJZAYY779QNCBV5OR7_ybk=RFqNazwPxUsWt12G60aiRuSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2013 12:24 PM, John Stultz wrote:
> On Thu, Feb 7, 2013 at 5:29 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>> We do not see this manifest on some architectures because they limit changes
>> to the rtc to +/-15 minutes of the current value of the rtc (x86, alpha,
>> mn10300).  Other arches do nothing (cris, mips, sh), and only a few seem to
>> show this problem (power, sparc).  I can reproduce this reliably on powerpc
>> with the latest Fedoras (17, 18, rawhide), as well as an Ubuntu powerpc spin.
>> I can also reproduce it "older" OSes such as RHEL6.
> 
> Interesting.
> Yea, local RTC time is probably pretty rare outside of x86 (due to windows).
> And the +/- 15minute trick has always explicitly masked this issue there.
> 

I'm not sure I understand the purpose behind the +/-15 minute window?  Is it
just to prevent a wild swing on the RTC?  I can understand that to some degree,
however, I'm not sure I agree with it being the default behaviour.

Here's a real-world scenario:

My RTC on my laptop is set to 1:30PM Jan 7, 2013.  I boot, systemd and ntp do
their magic, and the system time comes up as Feb 7, 12:48PM.  I never will
notice that the RTC is wrong.

Now I go somewhere and have to work on a plane.  I have no internet connection
and then boot.  Now the system time will be 1:30PM Jan 7, 2013.  That's actually
happened to me and I remember filing it away for a bug to be looked at.

AFAIK, no other OS does that ... if I install Windows or use a Mac in the
no-internet connection case, the time is *always* corrected.  I tried to see if
I could get this to happen on a Mac and I can't.

99.99999% of Linux users out there are using some sort of time protocol (usually
NTP, but PTP is starting to catch on) to sync their systems.  NTP is a trusted
source of timekeeping IMO.  How often do we see systems that run NTP but don't
trust the numbers that come from it?

We should be doing a full sync of the RTC in NTP, or at least it should be an
option/CONFIG option (FYI: I want to patch for that ... it'll give me something
to do).

> 
>> A few things about the patch.  'sys_time_offset' certainly could have a
>> better name and it could be a bool.  Also, technically I do not need to add the
>> 'adjust' struct in sync_cmos_clock() as the value of now.tv_sec is not used
>> after being passed into update_persistent_clock().  However, I think the code
>> is easier to follow if I do add 'adjust'.
>>
>> ------8<---------
>>
>> Take the timezone offset applied in warp_clock() into account when writing
>> the hardware clock in the ntp code.  This patch adds sys_time_offset which
>> indicates that an offset has been applied in warp_clock().
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: John Stultz <johnstul@us.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  include/linux/time.h |    1 +
>>  kernel/time.c        |    8 ++++++++
>>  kernel/time/ntp.c    |    8 ++++++--
>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/time.h b/include/linux/time.h
>> index 4d358e9..02754b5 100644
>> --- a/include/linux/time.h
>> +++ b/include/linux/time.h
>> @@ -117,6 +117,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
>>
>>  extern void read_persistent_clock(struct timespec *ts);
>>  extern void read_boot_clock(struct timespec *ts);
>> +extern int sys_time_offset;
>>  extern int update_persistent_clock(struct timespec now);
>>  void timekeeping_init(void);
>>  extern int timekeeping_suspended;
>> diff --git a/kernel/time.c b/kernel/time.c
>> index d226c6a..66533d3 100644
>> --- a/kernel/time.c
>> +++ b/kernel/time.c
>> @@ -115,6 +115,12 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
>>  }
>>
>>  /*
>> + * Indicates if there is an offset between the system clock and the hardware
>> + * clock/persistent clock/rtc.
>> + */
>> +int sys_time_offset;
> 
> So why is this extra flag necessary instead of just using if
> (sys_tz.tz_minuteswest) ?

sys_tz can be set during runtime via settimeofday() without affecting the
current system time.  The bug *only* happens if the system clock is "warped"
ahead relative to the hardware clock on the first call to settimeofday(), so
checking for sys_tz.tz_minuteswest isn't good enough of a test.

> 
> 
>> +
>> +/*
>>   * Adjust the time obtained from the CMOS to be UTC time instead of
>>   * local time.
>>   *
>> @@ -135,6 +141,8 @@ static inline void warp_clock(void)
>>         struct timespec adjust;
>>
>>         adjust = current_kernel_time();
>> +       if (sys_tz.tz_minuteswest > 0)
>> +               sys_time_offset = 1;
> 
> This seems like it wouldn't work for localtimes that are east of GMT.

Ah, good point.  I had it in my head that minuteswest was always negative.  That
should be

if (sys_tz.tz_minuteswest != 0)

I'll fix that in the next !RFE patch.

P.
