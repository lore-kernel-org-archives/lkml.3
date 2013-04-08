Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306Ab3DHOxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964950Ab3DHOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:53:19 -0400
Message-ID: <5162D9D4.7010500@redhat.com>
Date: Mon, 08 Apr 2013 10:53:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
References: <1365425235-26191-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1365425235-26191-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 08:47 AM, Prarit Bhargava wrote:

> When we change the system time to a low value like this, the value of
> timekeeper->offs_real will be a negative value.
>
> It seems that the WARN occurs because an hrtimer has been started in the time
> between the releasing of the timekeeper lock and the IPI call (via a call to
> on_each_cpu) in clock_was_set() in the do_settimeofday() code.  The end result
> is that a REALTIME_CLOCK timer has been added with softexpires = expires =
> KTIME_MAX.  The hrtimer_interrupt() fires/is called and the loop at
> kernel/hrtimer.c:1289 is executed.  In this loop the code subtracts the
> clock base's offset (which was set to timekeeper->offs_real in
> do_settimeofday()) from the current hrtimer_cpu_base->expiry value (which
> was KTIME_MAX):
>
> 	KTIME_MAX - (a negative value) = overflow
>
> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
> instead of the overflow value will result in the hrtimer function being run,
> and the reprogramming of the timer after that.
 >
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
