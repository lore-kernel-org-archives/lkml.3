Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaLDBJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:09:11 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:49072 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaLDBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:09:09 -0500
MIME-Version: 1.0
In-Reply-To: <1417652705-1959-1-git-send-email-sasha.levin@oracle.com>
References: <1417652705-1959-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 3 Dec 2014 17:09:09 -0800
Message-ID: <CALAqxLUhheX1=jPmhTvnQyOH3X=+4Tgx5-kwQwQHj1c2YK+Neg@mail.gmail.com>
Subject: Re: [PATCH] time: adjtimex: validate the ADJ_FREQUENCY case
From: John Stultz <john.stultz@linaro.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 4:25 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Verify that the frequency value from userspace is valid and makes sense.
>
> Unverified values can cause overflows later on.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/time/ntp.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 87a346f..54828cf 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -633,6 +633,15 @@ int ntp_validate_timex(struct timex *txc)
>         if ((txc->modes & ADJ_SETOFFSET) && (!capable(CAP_SYS_TIME)))
>                 return -EPERM;
>
> +       if (txc->modes & ADJ_FREQUENCY) {
> +               if (!capable(CAP_SYS_TIME))
> +                       return -EPERM;

So does this actually change behavior? We check CAP_SYS_TIME if modes
is set to anything a few lines above (with the exception of
ADJ_ADJTIME which only allows for ADJ_OFFSET_SINGLESHOT or
ADJ_OFFSET_READONLY).

Granted, that logic isn't intuitive to read (and probably needs a
cleanup) but seems ok.

> +               if (txc->freq < 0)
> +                       return -EINVAL;

?  Freq adjustments can be negative....  Am I just missing something here?

> +               if (LONG_MAX / PPM_SCALE < txc->freq)
> +                       return -EINVAL;
> +       }

This part seems reasonable though. We bound the output, but overflows
could result in negative result when it was specified positive.

I'm curious: I know many of your patches come from trinity issues, but
this one isn't super clear in the commit message how it was found. Did
an actually issue crop up here, or was this just something you came up
with while looking at the 3.18rc hang problem?

thanks
-john
