Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3FHMeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 08:34:50 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48679 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368Ab3FHMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 08:34:36 -0400
Date: Sat, 08 Jun 2013 15:34:29 +0300
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
From: Stratos Karafotis <stratosk@semaphore.gr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r58CZ3Gf027784

I also did the test with the way you mentioned. But I thought to run turbostat for 100 sec as I did with powertop.
Actually benchmark lasts about 96 secs.

I think that we use almost the same energy for 100 sec to run the same load a little bit faster. I think this means also a reduce to power consumption.

I will also send the results running the test as you said.

Thanks again,
Stratos

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Saturday, June 08, 2013 12:56:00 PM Stratos Karafotis wrote:
>> On 06/07/2013 11:57 PM, Rafael J. Wysocki wrote:
>> > On Friday, June 07, 2013 10:14:34 PM Stratos Karafotis wrote:
>> >> On 06/05/2013 11:35 PM, Rafael J. Wysocki wrote:
>> >>> On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
>> >>>> Hi Borislav,
>> >>>>
>> >>>> On 06/05/2013 07:17 PM, Borislav Petkov wrote:
>> >>>>> On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
>> >>>>>> Ondemand calculates load in terms of frequency and increases it only
>> >>>>>> if the load_freq is greater than up_threshold multiplied by current
>> >>>>>> or average frequency. This seems to produce oscillations of frequency
>> >>>>>> between min and max because, for example, a relatively small load can
>> >>>>>> easily saturate minimum frequency and lead the CPU to max. Then, the
>> >>>>>> CPU will decrease back to min due to a small load_freq.
>> >>>>>
>> >>>>> Right, and I think this is how we want it, no?
>> >>>>>
>> >>>>> The thing is, the faster you finish your work, the faster you can become
>> >>>>> idle and save power.
>> >>>>
>> >>>> This is exactly the goal of this patch. To use more efficiently middle
>> >>>> frequencies to finish faster the work.
>> >>>>
>> >>>>> If you switch frequencies in a staircase-like manner, you're going to
>> >>>>> take longer to finish, in certain cases, and burn more power while doing
>> >>>>> so.
>> >>>>
>> >>>> This is not true with this patch. It switches to middle frequencies
>> >>>> when the load < up_threshold.
>> >>>> Now, ondemand does not increase freq. CPU runs in lowest freq till the
>> >>>> load is greater than up_threshold.
>> >>>>
>> >>>>> Btw, racing to idle is also a good example for why you want boosting:
>> >>>>> you want to go max out the core but stay within power limits so that you
>> >>>>> can finish sooner.
>> >>>>>
>> >>>>>> This patch changes the calculation method of load and target frequency
>> >>>>>> considering 2 points:
>> >>>>>> - Load computation should be independent from current or average
>> >>>>>> measured frequency. For example an absolute load 80% at 100MHz is not
>> >>>>>> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
>> >>>>>> - Target frequency should be increased to any value of frequency table
>> >>>>>> proportional to absolute load, instead to only the max. Thus:
>> >>>>>>
>> >>>>>> Target frequency = C * load
>> >>>>>>
>> >>>>>> where C = policy->cpuinfo.max_freq / 100
>> >>>>>>
>> >>>>>> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
>> >>>>>> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
>> >>>>>> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
>> >>>>>> that middle frequencies are used more, with this patch. Highest
>> >>>>>> and lowest frequencies were used less by ~9%
>> >>>
>> >>> Can you also use powertop to measure the percentage of time spent in idle
>> >>> states for the same workload with and without your patchset?  Also, it would
>> >>> be good to measure the total energy consumption somehow ...
>> >>>
>> >>> Thanks,
>> >>> Rafael
>> >>
>> >> Hi Rafael,
>> >>
>> >> I repeated the tests extracting also powertop results.
>> >> Measurement steps with and without this patch:
>> >> 1) Reboot system
>> >> 2) Running twice Phoronix benchmark of Linux Kernel Compilation 3.1 test
>> >>     without taking measurement
>> >> 3) Wait few minutes
>> >> 4) Run Phoronix and powertop for 100secs and take measurement.
>> > 
>> > Well, while this is not conclusive, it definitely looks very promising. :-)
>> > 
>> > We're seeing measurable performance improvement with the patchset applied *and*
>> > more time spent in idle states both at the same time.  I'd be very surprised if
>> > the energy consumption measuremets did not confirm that the patchset allowed
>> > us to reduce it.
>> > 
>> > If my computations are correct (somebody please check), the cores spent about
>> > 20% more time in idle on the average with the patchset applied and in addition
>> > to that the cc6 residency was greater by about 2% on the average with respect
>> > to the kernel without the patchset.
>> > 
>> > We need to verify if there are gains (or at least no regressions) with other
>> > workloads, but since this *also* reduces code complexity quite a bit, I'm
>> > seriously considering taking it.
>> > 
>> >> I will try to repeat the test and take measurements with turbostat as
>> >> Borislav suggested.
>> > 
>> > Please do!
>> > 
>> > Thanks,
>> > Rafael
>> > 
>> 
>> Hi,
>> 
>> I repeated the tests extracting results from turbostat.
>> Measurement steps with and without this patch:
>> 1) Reboot system
>> 2) Running twice Phoronix benchmark of Linux Kernel Compilation 3.1 test
>>    without taking measurement
>> 3) Wait few minutes
>> 4) Run Phoronix and turbostat (-i 100) and take measurement
>
>You need to do something like
>
># ./turbostat <command invoking the phoronix suite>
>
>Did you do that?
>
>Rafael
>
>
>-- 
>I speak only for myself.
>Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
