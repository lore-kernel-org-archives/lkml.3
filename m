Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3LFO0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:26:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab3LFO0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:26:06 -0500
Date: Fri, 6 Dec 2013 15:26:02 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131206142602.GH22878@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
 <20131120183900.GA25735@localhost>
 <529D2BA6.5020005@linaro.org>
 <529D5805.20903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D5805.20903@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 08:03:17PM -0800, John Stultz wrote:
> On 12/02/2013 04:53 PM, John Stultz wrote:
> Finally found a config to get it working (disabling kernel debugging
> seems to work), and am currently trying to fixup the missing symbols
> (although I'm getting segfaults from various inline cli's :)

Patches are welcome :).

> Very cool simulator, by the way. Do you plan to have a git repo at some
> point for it?

It's now at https://github.com/mlichvar/linux-tktest

I'm considering to include it in https://github.com/mlichvar/clknetsim
as an optional replacement of the somewhat idealized clock which is
currently implemented there. This would allow us to see the whole
picture with applications controlling the clock.

> See the patch below. I'm doing some actual testing with it to see if its
> maybe too dampened.

It seems to fix the problem with stability, that's good. But the
response seems to be very slow now. In the simulated test with 10Hz
clock update it takes about 1000 updates (100 seconds!) for the loop
to converge to the correct frequency.

With the current tktest code from git:
n: 30, slope: 1.00 (1.00 GHz), dev: 3.1 ns, max: 3.6 ns, freq: -100.43404 ppm

You can see here the frequency is off by 0.43 ppm, that's after the 20
skipped updates.

When the sampling interval is changed to 100*50 ticks:
n: 30, slope: 1.00 (1.00 GHz), dev: 2146.9 ns, max: 5446.5 ns, freq: -100.07928 ppm

Only when the warmup period is extended to 100*1000 ticks, it produces
a nice fit:
n: 30, slope: 1.00 (1.00 GHz), dev: 7.3 ns, max: 12.2 ns, freq: -100.00004 ppm

This graph shows the value of tk->mult as it changes with clock
updates:
http://mlichvar.fedorapeople.org/tmp/tk_test1.png

When the TSC frequency is set to 100 MHz, it becomes more pronounced:
http://mlichvar.fedorapeople.org/tmp/tk_test2.png

I'm worried about the artifacts in the response, is that a bug?

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1068,7 +1068,7 @@ static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
>  	 * here.  This is tuned so that an error of about 1 msec is adjusted
>  	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
>  	 */
> -	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
> +	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT/2);
>  	error2 = abs(error2);
>  	for (look_ahead = 0; error2 > 0; look_ahead++)
>  		error2 >>= 2;
> 

-- 
Miroslav Lichvar
