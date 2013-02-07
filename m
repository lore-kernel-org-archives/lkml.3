Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab3BGRY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:24:58 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48330 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab3BGRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:24:57 -0500
MIME-Version: 1.0
In-Reply-To: <1360243741-25213-1-git-send-email-prarit@redhat.com>
References: <1360243741-25213-1-git-send-email-prarit@redhat.com>
Date: Thu, 7 Feb 2013 09:24:56 -0800
X-Google-Sender-Auth: QAPnrOm7UI7CnCZHMpZ8hfXlZH8
Message-ID: <CANcMJZAYY779QNCBV5OR7_ybk=RFqNazwPxUsWt12G60aiRuSw@mail.gmail.com>
Subject: Re: [RFE PATCH] time, Fix setting of hardware clock in NTP code
From: John Stultz <john.stultz@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 5:29 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> The problem with this model is what happens if /etc/adjtime is LOCAL, ie)
> the rtc is set to localtime:
>
> Reboot the system, on the next boot,
>         rtc0_time = rtc + sys_tz.tz_minuteswest
> Reboot the system, on the next boot,
>         rtc0_time = rtc + sys_tz.tz_minuteswest + sys_tz.tz_minuteswest
>
> AFAICT the only call to update_persistent_clock() in the kernel is the
> ntp code.  It is wired in to allow ntp to occasionally update the system
> clock.  Other calls to update the rtc are made directly through the
> RTC_SET_TIME ioctl.
>
> I believe that the value passed into update_persistent_time() is wrong.  It
> should take into account the sys_tz data.  If the rtc is UTC, then the
> offset is 0.  If the system is LOCAL, then there should be a 300 min offset
> for the value of now.
>
> We do not see this manifest on some architectures because they limit changes
> to the rtc to +/-15 minutes of the current value of the rtc (x86, alpha,
> mn10300).  Other arches do nothing (cris, mips, sh), and only a few seem to
> show this problem (power, sparc).  I can reproduce this reliably on powerpc
> with the latest Fedoras (17, 18, rawhide), as well as an Ubuntu powerpc spin.
> I can also reproduce it "older" OSes such as RHEL6.

Interesting.
Yea, local RTC time is probably pretty rare outside of x86 (due to windows).
And the +/- 15minute trick has always explicitly masked this issue there.


> A few things about the patch.  'sys_time_offset' certainly could have a
> better name and it could be a bool.  Also, technically I do not need to add the
> 'adjust' struct in sync_cmos_clock() as the value of now.tv_sec is not used
> after being passed into update_persistent_clock().  However, I think the code
> is easier to follow if I do add 'adjust'.
>
> ------8<---------
>
> Take the timezone offset applied in warp_clock() into account when writing
> the hardware clock in the ntp code.  This patch adds sys_time_offset which
> indicates that an offset has been applied in warp_clock().
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/time.h |    1 +
>  kernel/time.c        |    8 ++++++++
>  kernel/time/ntp.c    |    8 ++++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 4d358e9..02754b5 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -117,6 +117,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
>
>  extern void read_persistent_clock(struct timespec *ts);
>  extern void read_boot_clock(struct timespec *ts);
> +extern int sys_time_offset;
>  extern int update_persistent_clock(struct timespec now);
>  void timekeeping_init(void);
>  extern int timekeeping_suspended;
> diff --git a/kernel/time.c b/kernel/time.c
> index d226c6a..66533d3 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -115,6 +115,12 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
>  }
>
>  /*
> + * Indicates if there is an offset between the system clock and the hardware
> + * clock/persistent clock/rtc.
> + */
> +int sys_time_offset;

So why is this extra flag necessary instead of just using if
(sys_tz.tz_minuteswest) ?


> +
> +/*
>   * Adjust the time obtained from the CMOS to be UTC time instead of
>   * local time.
>   *
> @@ -135,6 +141,8 @@ static inline void warp_clock(void)
>         struct timespec adjust;
>
>         adjust = current_kernel_time();
> +       if (sys_tz.tz_minuteswest > 0)
> +               sys_time_offset = 1;

This seems like it wouldn't work for localtimes that are east of GMT.
Or am I misunderstanding this? I feel like the warp_clock code has
always been a bit unloved, and I've never worked out all the
subtleties around it.

thanks
-john
