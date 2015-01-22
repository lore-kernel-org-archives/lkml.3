Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbbAVSbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:31:03 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:37731 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbAVSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
Date: Thu, 22 Jan 2015 10:30:57 -0800
Message-ID: <CALAqxLVGquBDT-rgLhPi068Y3BYXLUNJu-okPb4sh4+vTfqFBw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] time: Don't bother to run rtc_resume() for the
 nonstop clocksource
From: John Stultz <john.stultz@linaro.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:01 AM, Xunlei Pang <pang.xunlei@linaro.org> wrote:
> If a system does not provide a persistent_clock(), the time
> will be updated on resume by rtc_resume(). With the addition
> of the non-stop clocksources for suspend timing, those systems
> set the time on resume in timekeeping_resume(), but may not
> provide a valid persistent_clock().
>
> This results in the rtc_resume() logic thinking no one has set
> the time and it then will over-write the suspend time again,
> which is not necessary and only increases clock error.
>
> So, fix this for rtc_resume().
>
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
> ---
> v1->v2:
> Modify according to Thomas' feedback.
>
>  drivers/rtc/class.c         |  2 +-
>  include/linux/timekeeping.h |  7 +++++++
>  kernel/time/timekeeping.c   | 16 +++++-----------
>  3 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 472a5ad..6100af5 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
>         struct timespec64       sleep_time;
>         int err;
>
> -       if (has_persistent_clock())
> +       if (timekeeping_sleeptime_injected())
>                 return 0;
>
>         rtc_hctosys_ret = -ENODEV;
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index 9b63d13..2b87c64 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -238,6 +238,13 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
>   */
>  extern bool persistent_clock_exist;
>  extern int persistent_clock_is_local;
> +extern bool timekeeping_sleeptime_inject;
> +
> +/* Used by rtc_resume() */
> +static inline bool timekeeping_sleeptime_injected(void)
> +{
> +       return timekeeping_sleeptime_inject;
> +}
>

Again, there's no reason to make this a static inline, nor the
sleeptime_inject variable global.
Just make it a function in timekeeping and provide definition so it
can be used by the rtc resume.

thanks
-john
