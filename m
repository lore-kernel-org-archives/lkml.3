Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3BFMG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:06:28 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50614 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3BFMGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:06:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130206112327.GA1824@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
	<alpine.LFD.2.02.1302011450160.11905@ionos>
	<20130204193223.GA11910@redhat.com>
	<20130205103455.GB18313@redhat.com>
	<alpine.LFD.2.02.1302051155000.11905@ionos>
	<20130206112327.GA1824@redhat.com>
Date: Wed, 6 Feb 2013 14:01:21 +0200
Message-ID: <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com>
Subject: Re: clock_nanosleep() task_struct leak
From: Tommi Rantala <tt.rantala@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6 Stanislaw Gruszka <sgruszka@redhat.com>:
> Below is proposed fix. Error cases wasn't that bad since there are
> various limitations when timer could be fired (i.e. timer which
> already fired can not be fired again).
>
> Tommi, please check if patch really fixes the problem. I tested it
> with signal interrupt and timeout scenarios, but I don't know how
> to confirm if it fix the leak or not.

Hi, looks good, this patch fixes the leaks I'm seeing.

Without the patch, running the program from my earlier mail shows
task_struct count growing:

{ttrantal@arkki ~}> uname -r
3.8.0-rc6+
{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct           93    123   8880    3    8 : tunables    0    0
  0 : slabdata     41     41      0
{ttrantal@arkki ~}> for i in `seq 1000` ; do ./leak ; done
{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct         1089   1089   8880    3    8 : tunables    0    0
  0 : slabdata    363    363      0
{ttrantal@arkki ~}> for i in `seq 1000` ; do ./leak ; done
{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct         2088   2088   8880    3    8 : tunables    0    0
  0 : slabdata    696    696      0
{ttrantal@arkki ~}>

With the patch applied, the leak is gone:

{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct           92    108   8880    3    8 : tunables    0    0
  0 : slabdata     36     36      0
{ttrantal@arkki ~}> for i in `seq 1000` ; do ./leak ; done
{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct           92    108   8880    3    8 : tunables    0    0
  0 : slabdata     36     36      0
{ttrantal@arkki ~}> for i in `seq 1000` ; do ./leak ; done
{ttrantal@arkki ~}> sudo grep task_struct /proc/slabinfo
task_struct           92    108   8880    3    8 : tunables    0    0
  0 : slabdata     36     36      0
{ttrantal@arkki ~}>

Running Trinity with kmemleak enabled also resulted to a lot of
detected leaks, which are all gone now based on a quick run.

> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 125cb67..07a38b6 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -1424,6 +1424,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
>                                 /*
>                                  * Our timer fired and was reset.
>                                  */
> +                               posix_cpu_timer_del(&timer);
>                                 spin_unlock_irq(&timer.it_lock);
>                                 return 0;
>                         }
> @@ -1441,9 +1442,17 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
>                  * We were interrupted by a signal.
>                  */
>                 sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
> -               posix_cpu_timer_set(&timer, 0, &zero_it, it);
> +               error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
> +               if (!error)
> +                       posix_cpu_timer_del(&timer);
>                 spin_unlock_irq(&timer.it_lock);
>
> +               while (error == TIMER_RETRY) {
> +                       spin_lock_irq(&timer.it_lock);
> +                       error = posix_cpu_timer_del(&timer);
> +                       spin_unlock_irq(&timer.it_lock);
> +               }
> +
>                 if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
>                         /*
>                          * It actually did fire already.
