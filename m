Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaIJDdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:33:07 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47940 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJDdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <1410312665-25381-1-git-send-email-rlarocque@google.com>
References: <1410312665-25381-1-git-send-email-rlarocque@google.com>
Date: Tue, 9 Sep 2014 20:33:04 -0700
Message-ID: <CALAqxLWped1Qsh=Ps7Vc2=ORpKGNhjvKc-hWoA0Wg5aAf7O8Xg@mail.gmail.com>
Subject: Re: [PATCH 0/3] alarmtimer: Fix some non-standard alarm timer behavior
From: John Stultz <john.stultz@linaro.org>
To: Richard Larocque <rlarocque@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 6:31 PM, Richard Larocque <rlarocque@google.com> wrote:
> I've been working on some changes to posix-timers.c in an attempt to better
> support CRIU.  Along the way, I've discovered some issues with the posix alarm
> timers that should be fixed independent of any other work.
>
> It seems that there was an older issue with the setting of relative timeouts
> with timer_settime().  That was addressed around 3.16 with
> 16927776ae757d0d132bdbfabbfe2c498342bd59 ("alarmtimer: Fix bug where relative
> alarm timers were treated as absolute").  That fixed the setting of times, but
> it doesn't fix the retrieval of times.
>
> According to the man pages (and POSIX), timer_gettime() is supposed to return
> the time left until the timeout, not the absolute time at which the timeout is
> expected to fire.  The non-ALARM clocks correctly show relative times, but
> CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM do not.
>
> A second issue with these timers is that they call posix_event_timer() without
> checking the value of it_sigev_notify.  This is a problem, because
> it_sigev_notify could be SIGEV_NONE, in which case the signal should not be
> delivered.  The non-alarm timers don't need to check it_sigev_notify in their
> timeout handling code path, because they never schedule timeouts for those
> kinds of timers in the first place.
>
> See below for a program that demonstrates these behaviors, and some sample output.
>
> The third patch in this stack is the odd one out.  I suspect that there's
> a locking issue in the alarm timer code, and this is my attempt to fix it.
> It's not quite related to the first two, but it does conflict with one of them,
> so I figured I should include it in this patch stack.

Oof. More paper bags for me to wear. Thanks so much for discovering
these and providing these fixes.

I'll review and queue these up for my own testing and then send them
on (the locking one I'll have to look closely at). Do you mind if I
add a variant of your demo code to my timekeeping test suite?

thanks
-john
