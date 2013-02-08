Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947226Ab3BHVqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:46:31 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:41560 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947110Ab3BHVqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:46:30 -0500
MIME-Version: 1.0
In-Reply-To: <1360328120-9899-1-git-send-email-prarit@redhat.com>
References: <1360328120-9899-1-git-send-email-prarit@redhat.com>
Date: Fri, 8 Feb 2013 13:46:29 -0800
X-Google-Sender-Auth: SwrTrPQToU7wI7G4ehjxmLSHVq0
Message-ID: <CANcMJZAzT-fCXY2P0ZRjdMoXq+dNd3rrq3eNY18pgob-hS6L9g@mail.gmail.com>
Subject: Re: [PATCH] time, Fix setting of hardware clock in NTP code
From: John Stultz <john.stultz@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 4:55 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 24174b4..e98f6b7 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -510,8 +510,12 @@ static void sync_cmos_clock(struct work_struct *work)
>         }
>
>         getnstimeofday(&now);
> -       if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
> -               fail = update_persistent_clock(now);
> +       if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
> +               struct timespec adjust = now;
> +               if (persistent_clock_is_local)
> +                       adjust.tv_sec -= (sys_tz.tz_minuteswest * 60);
> +               fail = update_persistent_clock(adjust);
> +       }
>
Do you mind reworking this patch on top of tip/timers/core?  There's
some recent changes that interact here.

thanks
-john
