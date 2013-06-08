Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3FHJ4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:56:08 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:47957 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889Ab3FHJ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:56:05 -0400
Message-ID: <51B2FFB0.9030008@semaphore.gr>
Date: Sat, 08 Jun 2013 12:56:00 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@suse.de>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51AF60D5.3080605@semaphore.gr> <105446113.ZumbZWCbSi@vostro.rjw.lan> <51B2311A.9040308@semaphore.gr> <34284216.Ce55kPas6V@vostro.rjw.lan>
In-Reply-To: <34284216.Ce55kPas6V@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 11:57 PM, Rafael J. Wysocki wrote:
> On Friday, June 07, 2013 10:14:34 PM Stratos Karafotis wrote:
>> On 06/05/2013 11:35 PM, Rafael J. Wysocki wrote:
>>> On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
>>>> Hi Borislav,
>>>>
>>>> On 06/05/2013 07:17 PM, Borislav Petkov wrote:
>>>>> On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
>>>>>> Ondemand calculates load in terms of frequency and increases it only
>>>>>> if the load_freq is greater than up_threshold multiplied by current
>>>>>> or average frequency. This seems to produce oscillations of frequency
>>>>>> between min and max because, for example, a relatively small load can
>>>>>> easily saturate minimum frequency and lead the CPU to max. Then, the
>>>>>> CPU will decrease back to min due to a small load_freq.
>>>>>
>>>>> Right, and I think this is how we want it, no?
>>>>>
>>>>> The thing is, the faster you finish your work, the faster you can become
>>>>> idle and save power.
>>>>
>>>> This is exactly the goal of this patch. To use more efficiently middle
>>>> frequencies to finish faster the work.
>>>>
>>>>> If you switch frequencies in a staircase-like manner, you're going to
>>>>> take longer to finish, in certain cases, and burn more power while doing
>>>>> so.
>>>>
>>>> This is not true with this patch. It switches to middle frequencies
>>>> when the load < up_threshold.
>>>> Now, ondemand does not increase freq. CPU runs in lowest freq till the
>>>> load is greater than up_threshold.
>>>>
>>>>> Btw, racing to idle is also a good example for why you want boosting:
>>>>> you want to go max out the core but stay within power limits so that you
>>>>> can finish sooner.
>>>>>
>>>>>> This patch changes the calculation method of load and target frequency
>>>>>> considering 2 points:
>>>>>> - Load computation should be independent from current or average
>>>>>> measured frequency. For example an absolute load 80% at 100MHz is not
>>>>>> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
>>>>>> - Target frequency should be increased to any value of frequency table
>>>>>> proportional to absolute load, instead to only the max. Thus:
>>>>>>
>>>>>> Target frequency = C * load
>>>>>>
>>>>>> where C = policy->cpuinfo.max_freq / 100
>>>>>>
>>>>>> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
>>>>>> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
>>>>>> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
>>>>>> that middle frequencies are used more, with this patch. Highest
>>>>>> and lowest frequencies were used less by ~9%
>>>
>>> Can you also use powertop to measure the percentage of time spent in idle
>>> states for the same workload with and without your patchset?  Also, it would
>>> be good to measure the total energy consumption somehow ...
>>>
>>> Thanks,
>>> Rafael
>>
>> Hi Rafael,
>>
>> I repeated the tests extracting also powertop results.
>> Measurement steps with and without this patch:
>> 1) Reboot system
>> 2) Running twice Phoronix benchmark of Linux Kernel Compilation 3.1 test
>>     without taking measurement
>> 3) Wait few minutes
>> 4) Run Phoronix and powertop for 100secs and take measurement.
> 
> Well, while this is not conclusive, it definitely looks very promising. :-)
> 
> We're seeing measurable performance improvement with the patchset applied *and*
> more time spent in idle states both at the same time.  I'd be very surprised if
> the energy consumption measuremets did not confirm that the patchset allowed
> us to reduce it.
> 
> If my computations are correct (somebody please check), the cores spent about
> 20% more time in idle on the average with the patchset applied and in addition
> to that the cc6 residency was greater by about 2% on the average with respect
> to the kernel without the patchset.
> 
> We need to verify if there are gains (or at least no regressions) with other
> workloads, but since this *also* reduces code complexity quite a bit, I'm
> seriously considering taking it.
> 
>> I will try to repeat the test and take measurements with turbostat as
>> Borislav suggested.
> 
> Please do!
> 
> Thanks,
> Rafael
> 

Hi,

I repeated the tests extracting results from turbostat.
Measurement steps with and without this patch:
1) Reboot system
2) Running twice Phoronix benchmark of Linux Kernel Compilation 3.1 test
   without taking measurement
3) Wait few minutes
4) Run Phoronix and turbostat (-i 100) and take measurement


Thanks,
Stratos

------------------------------------------------------------------
Test WITHOUT this patch:

Phoronix Test Suite v4.6.0

    Installed: pts/build-linux-kernel-1.3.0

System Information

Hardware:
Processor: Intel Core i7-3770 @ 3.40GHz (8 Cores), Motherboard: ASUS CM6870, Chipset: Intel Xeon E3-1200 v2/3rd, Memory: 2 x 4096 MB DDR3-1600MHz HY64C1C1624ZY, Disk: 1000GB Seagate ST1000DM003-9YN1, Graphics: NVIDIA GeForce GT 640 3072MB, Audio: Realtek ALC892, Monitor: S23B350, Network: Realtek RTL8111/8168 + Ralink RT3090 Wireless 802.11n 1T/1R

Software:
OS: Fedora 18, Kernel: 3.10.0-rc3v+ (x86_64), Desktop: KDE 4.10.3, Display Server: X Server 1.13.3, Display Driver: nouveau 1.0.7, File-System: ext4, Screen Resolution: 1920x1080

    Would you like to save these test results (Y/n): n


Timed Linux Kernel Compilation 3.1:
    pts/build-linux-kernel-1.3.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 2 Minutes
        Running Pre-Test Script @ 12:38:35
        Started Run 1 @ 12:38:46
        Running Interim Test Script @ 12:38:59
        Started Run 2 @ 12:39:03
        Running Interim Test Script @ 12:39:14
        Started Run 3 @ 12:39:18
        Running Interim Test Script @ 12:39:27  [Std. Dev: 8.57%]
        Started Run 4 @ 12:39:31
        Running Interim Test Script @ 12:39:41  [Std. Dev: 8.56%]
        Started Run 5 @ 12:39:44
        Running Interim Test Script @ 12:39:54  [Std. Dev: 8.05%]
        Started Run 6 @ 12:39:58  [Std. Dev: 7.57%]
        Running Post-Test Script @ 12:40:07

    Test Results:
        10.280334949493
        11.148964166641
        9.3881862163544
        9.3307340145111
        9.3948450088501
        9.3976459503174

    Average: 9.82 Seconds

cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
         38.86 3.57 3.39   0  10.07   2.98  48.09   0.00   44   44   0.00   0.00   0.00   0.00  26.23  20.28  0.00
  0   0  33.32 3.65 3.39   0  19.88   3.26  43.54   0.00   44   44   0.00   0.00   0.00   0.00  26.23  20.28  0.00
  0   4  48.87 3.52 3.39   0   4.32
  1   1  35.58 3.67 3.39   0  12.93   3.28  48.21   0.00   39
  1   5  42.12 3.51 3.39   0   6.39
  2   2  33.42 3.66 3.39   0  13.11   2.78  50.69   0.00   34
  2   6  40.83 3.43 3.39   0   5.70
  3   3  35.97 3.68 3.39   0  11.51   2.61  49.92   0.00   39
  3   7  40.75 3.49 3.39   0   6.73


---------------------------------------------------------------------
Test WITH this patch:

Phoronix Test Suite v4.6.0

    Installed: pts/build-linux-kernel-1.3.0

System Information

Hardware:
Processor: Intel Core i7-3770 @ 3.40GHz (8 Cores), Motherboard: ASUS CM6870, Chipset: Intel Xeon E3-1200 v2/3rd, Memory: 2 x 4096 MB DDR3-1600MHz HY64C1C1624ZY, Disk: 1000GB Seagate ST1000DM003-9YN1, Graphics: NVIDIA GeForce GT 640 3072MB, Audio: Realtek ALC892, Monitor: S23B350, Network: Realtek RTL8111/8168 + Ralink RT3090 Wireless 802.11n 1T/1R

Software:
OS: Fedora 18, Kernel: 3.10.0-rc3+ (x86_64), Desktop: KDE 4.10.3, Display Server: X Server 1.13.3, Display Driver: nouveau 1.0.7, File-System: ext4, Screen Resolution: 1920x1080

    Would you like to save these test results (Y/n): n


Timed Linux Kernel Compilation 3.1:
    pts/build-linux-kernel-1.3.0
    Test 1 of 1
    Estimated Trial Run Count:    3
    Estimated Time To Completion: 2 Minutes
        Running Pre-Test Script @ 12:28:03
        Started Run 1 @ 12:28:15
        Running Interim Test Script @ 12:28:28
        Started Run 2 @ 12:28:31
        Running Interim Test Script @ 12:28:41
        Started Run 3 @ 12:28:47
        Running Interim Test Script @ 12:28:56  [Std. Dev: 5.03%]
        Started Run 4 @ 12:29:00
        Running Interim Test Script @ 12:29:09  [Std. Dev: 4.37%]
        Started Run 5 @ 12:29:13
        Running Interim Test Script @ 12:29:22  [Std. Dev: 3.79%]
        Started Run 6 @ 12:29:26  [Std. Dev: 3.49%]
        Running Post-Test Script @ 12:29:35

    Test Results:
        10.134061098099
        9.3411478996277
        9.2629590034485
        9.3126730918884
        9.4799311161041
        9.3236708641052

    Average: 9.48 Seconds

cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
         38.61 3.59 3.39   0   9.64   3.04  48.71   0.00   43   43   0.00   0.00   0.00   0.00  26.30  20.35  0.00
  0   0  34.73 3.67 3.39   0  13.33   3.02  48.93   0.00   43   43   0.00   0.00   0.00   0.00  26.30  20.35  0.00
  0   4  41.86 3.52 3.39   0   6.19
  1   1  33.48 3.66 3.39   0  12.53   4.00  49.99   0.00   40
  1   5  40.62 3.52 3.39   0   5.39
  2   2  34.41 3.66 3.39   0  18.06   2.98  44.55   0.00   35
  2   6  48.26 3.58 3.39   0   4.22
  3   3  35.79 3.69 3.39   0  10.70   2.16  51.36   0.00   40
  3   7  39.77 3.50 3.39   0   6.71



