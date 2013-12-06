Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3LFSJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:09:15 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53713 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3LFSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:09:12 -0500
Message-ID: <52A212BF.8060101@linaro.org>
Date: Fri, 06 Dec 2013 10:09:03 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com> <528A7C88.1030801@linaro.org> <20131120183900.GA25735@localhost> <529D2BA6.5020005@linaro.org> <529D5805.20903@linaro.org> <20131206142602.GH22878@localhost>
In-Reply-To: <20131206142602.GH22878@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 06:26 AM, Miroslav Lichvar wrote:
> On Mon, Dec 02, 2013 at 08:03:17PM -0800, John Stultz wrote:
>> On 12/02/2013 04:53 PM, John Stultz wrote:
>> Finally found a config to get it working (disabling kernel debugging
>> seems to work), and am currently trying to fixup the missing symbols
>> (although I'm getting segfaults from various inline cli's :)
> Patches are welcome :).
>
>> Very cool simulator, by the way. Do you plan to have a git repo at some
>> point for it?
> It's now at https://github.com/mlichvar/linux-tktest
>
> I'm considering to include it in https://github.com/mlichvar/clknetsim
> as an optional replacement of the somewhat idealized clock which is
> currently implemented there. This would allow us to see the whole
> picture with applications controlling the clock.

Interesting!  I don't think I've seen clknetsim before. I'll have to
look at it more closely!


>> See the patch below. I'm doing some actual testing with it to see if its
>> maybe too dampened.
> It seems to fix the problem with stability, that's good. But the
> response seems to be very slow now. In the simulated test with 10Hz
> clock update it takes about 1000 updates (100 seconds!) for the loop
> to converge to the correct frequency.

Yea. That was my concern that it over dampens the correction. In my
tests on actual systems it doesn't seem to cause much change in the
overall convergence picture with ntp, so I'll have to look more closely.

Just to be clear, when you say 10Hz clock update, what exactly are you
changing, as that doesn't quite match to the terminology in the tktest
simulator (ie: are you changing the ticks count?).


> With the current tktest code from git:
> n: 30, slope: 1.00 (1.00 GHz), dev: 3.1 ns, max: 3.6 ns, freq: -100.43404 ppm
>
> You can see here the frequency is off by 0.43 ppm, that's after the 20
> skipped updates.
>
> When the sampling interval is changed to 100*50 ticks:
> n: 30, slope: 1.00 (1.00 GHz), dev: 2146.9 ns, max: 5446.5 ns, freq: -100.07928 ppm
>
> Only when the warmup period is extended to 100*1000 ticks, it produces
> a nice fit:
> n: 30, slope: 1.00 (1.00 GHz), dev: 7.3 ns, max: 12.2 ns, freq: -100.00004 ppm


I get the first and the last numbers, but the middle are different for
me. Are you just setting:

diff --git a/tk_test.c b/tk_test.c
index e44a488..680f315 100644
--- a/tk_test.c
+++ b/tk_test.c
@@ -82,7 +82,7 @@ void tk_test(uint64_t *ts_x, uint64_t *ts_y, int samples, int 
 
        advance_ticks(freq, 1, 1, 200);
        ntp_freq -= 100000;
-       advance_ticks(freq, 100, 1, 20);
+       advance_ticks(freq, 100, 1, 50);
 
        for (i = 0; i < samples; i++) {
                getnstimeofday(&ts);

?

> This graph shows the value of tk->mult as it changes with clock
> updates:
> http://mlichvar.fedorapeople.org/tmp/tk_test1.png
>
> When the TSC frequency is set to 100 MHz, it becomes more pronounced:
> http://mlichvar.fedorapeople.org/tmp/tk_test2.png
>
> I'm worried about the artifacts in the response, is that a bug?

It does look strange. And again so I can reproduce this, how are you
generating the charts?


thanks
-john

