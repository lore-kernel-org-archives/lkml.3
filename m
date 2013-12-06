Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3LFSh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab3LFSh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:37:26 -0500
Date: Fri, 6 Dec 2013 19:37:18 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131206183718.GL22878@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
 <20131120183900.GA25735@localhost>
 <529D2BA6.5020005@linaro.org>
 <529D5805.20903@linaro.org>
 <20131206142602.GH22878@localhost>
 <52A212BF.8060101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A212BF.8060101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:09:03AM -0800, John Stultz wrote:
> On 12/06/2013 06:26 AM, Miroslav Lichvar wrote:
> > It seems to fix the problem with stability, that's good. But the
> > response seems to be very slow now. In the simulated test with 10Hz
> > clock update it takes about 1000 updates (100 seconds!) for the loop
> > to converge to the correct frequency.
> 
> Yea. That was my concern that it over dampens the correction. In my
> tests on actual systems it doesn't seem to cause much change in the
> overall convergence picture with ntp, so I'll have to look more closely.

In a few quick tests with phc2sys I didn't see any changes either.
But I couldn't get the wakeup rate on my test system below 20 per
second even after playing with powertop and killing everything, so I'm
not sure if that means anything.

What is the wakeup rate on your test system?

My feeling is that the internal kernel loop should be faster than the
application's loop.

> Just to be clear, when you say 10Hz clock update, what exactly are you
> changing, as that doesn't quite match to the terminology in the tktest
> simulator (ie: are you changing the ticks count?).

Yes, the second argument of advance_ticks(), 100 for 10 Hz (the
current value) and 1000 for 1 Hz.

> > When the sampling interval is changed to 100*50 ticks:
> > n: 30, slope: 1.00 (1.00 GHz), dev: 2146.9 ns, max: 5446.5 ns, freq: -100.07928 ppm

> I get the first and the last numbers, but the middle are different for
> me. Are you just setting:

> -       advance_ticks(freq, 100, 1, 20);
> +       advance_ticks(freq, 100, 1, 50);
>  
>         for (i = 0; i < samples; i++) {
>                 getnstimeofday(&ts);

No, I'm setting the one in the loop:

                ts_x[i] = simtsc;
                ts_y[i] = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 
-               advance_ticks(freq, 100, 1, 1);
+               advance_ticks(freq, 100, 1, 50);

> > When the TSC frequency is set to 100 MHz, it becomes more pronounced:
> > http://mlichvar.fedorapeople.org/tmp/tk_test2.png
> >
> > I'm worried about the artifacts in the response, is that a bug?
> 
> It does look strange. And again so I can reproduce this, how are you
> generating the charts?

I changed TSC_FREQ, added "printk("mult: %d\n", tk->mult);" to
update_wall_time() in timekeeping.c, grepped the output for "^mult"
and used this command in gnuplot on display the data:

plot [] [167755330:167755390] "log.mult" using 2

-- 
Miroslav Lichvar
