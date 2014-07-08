Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaGHGm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:42:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39671 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaGHGm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:42:28 -0400
Date: Tue, 8 Jul 2014 08:42:04 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] alarmtimer: Fix bug where relative alarm timers were
 treated as absolute
Message-ID: <20140708064204.GD3977@localhost.localdomain>
References: <1404767171-6902-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404767171-6902-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 02:06:11PM -0700, John Stultz wrote:
> @@ -597,8 +602,16 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
>  
>  	/* start the timer */
>  	timr->it.alarm.interval = timespec_to_ktime(new_setting->it_interval);
> -	alarm_start(&timr->it.alarm.alarmtimer,
> -			timespec_to_ktime(new_setting->it_value));
> +	exp = timespec_to_ktime(new_setting->it_value);
> +	/* Convert (if necessary) to absolute time */
> +	if (flags != TIMER_ABSTIME) {
> +		ktime_t now;
> +
> +		now = alarm_bases[timr->it.alarm.alarmtimer.type].gettime();
> +		exp = ktime_add(now, exp);
> +	}
> +
> +	alarm_start(&timr->it.alarm.alarmtimer, exp);

Nothing protects 'exp' from becoming invalid before queuing the alarm,
if the time base is reset on another cpu. Or would that be harmless
here?

>  	return 0;
>  }

Thanks,
Richard
