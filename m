Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3FGTOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:14:41 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:45311 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754902Ab3FGTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:14:39 -0400
Message-ID: <51B2311A.9040308@semaphore.gr>
Date: Fri, 07 Jun 2013 22:14:34 +0300
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
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic> <51AF71B6.6030408@semaphore.gr> <105446113.ZumbZWCbSi@vostro.rjw.lan>
In-Reply-To: <105446113.ZumbZWCbSi@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 11:35 PM, Rafael J. Wysocki wrote:
> On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
>> Hi Borislav,
>>
>> On 06/05/2013 07:17 PM, Borislav Petkov wrote:
>>> On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
>>>> Ondemand calculates load in terms of frequency and increases it only
>>>> if the load_freq is greater than up_threshold multiplied by current
>>>> or average frequency. This seems to produce oscillations of frequency
>>>> between min and max because, for example, a relatively small load can
>>>> easily saturate minimum frequency and lead the CPU to max. Then, the
>>>> CPU will decrease back to min due to a small load_freq.
>>>
>>> Right, and I think this is how we want it, no?
>>>
>>> The thing is, the faster you finish your work, the faster you can become
>>> idle and save power.
>>
>> This is exactly the goal of this patch. To use more efficiently middle
>> frequencies to finish faster the work.
>>
>>> If you switch frequencies in a staircase-like manner, you're going to
>>> take longer to finish, in certain cases, and burn more power while doing
>>> so.
>>
>> This is not true with this patch. It switches to middle frequencies
>> when the load < up_threshold.
>> Now, ondemand does not increase freq. CPU runs in lowest freq till the
>> load is greater than up_threshold.
>>
>>> Btw, racing to idle is also a good example for why you want boosting:
>>> you want to go max out the core but stay within power limits so that you
>>> can finish sooner.
>>>
>>>> This patch changes the calculation method of load and target frequency
>>>> considering 2 points:
>>>> - Load computation should be independent from current or average
>>>> measured frequency. For example an absolute load 80% at 100MHz is not
>>>> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
>>>> - Target frequency should be increased to any value of frequency table
>>>> proportional to absolute load, instead to only the max. Thus:
>>>>
>>>> Target frequency = C * load
>>>>
>>>> where C = policy->cpuinfo.max_freq / 100
>>>>
>>>> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
>>>> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
>>>> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
>>>> that middle frequencies are used more, with this patch. Highest
>>>> and lowest frequencies were used less by ~9%
> 
> Can you also use powertop to measure the percentage of time spent in idle
> states for the same workload with and without your patchset?  Also, it would
> be good to measure the total energy consumption somehow ...
> 
> Thanks,
> Rafael

Hi Rafael,

I repeated the tests extracting also powertop results.
Measurement steps with and without this patch:
1) Reboot system
2) Running twice Phoronix benchmark of Linux Kernel Compilation 3.1 test
   without taking measurement
3) Wait few minutes
4) Run Phoronix and powertop for 100secs and take measurement.

I will try to repeat the test and take measurements with turbostat as
Borislav suggested.


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
        Running Pre-Test Script @ 21:41:19
        Started Run 1 @ 21:41:30
        Running Interim Test Script @ 21:41:44
        Started Run 2 @ 21:41:47
        Running Interim Test Script @ 21:42:02
        Started Run 3 @ 21:42:05
        Running Interim Test Script @ 21:42:15  [Std. Dev: 19.28%]
        Started Run 4 @ 21:42:19
        Running Interim Test Script @ 21:42:29  [Std. Dev: 18.72%]
        Started Run 5 @ 21:42:32
        Running Interim Test Script @ 21:42:42  [Std. Dev: 17.84%]
        Started Run 6 @ 21:42:46  [Std. Dev: 16.91%]
        Running Post-Test Script @ 21:42:55

    Test Results:
        11.073544979095
        14.059958934784
        9.6814110279083
        9.6158590316772
        9.5762379169464
        9.5944919586182

    Average: 10.60 Seconds

Powertop results:
http://www.semaphore.gr/results/powertop_without.html


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
        Running Pre-Test Script @ 21:28:05
        Started Run 1 @ 21:28:17
        Running Interim Test Script @ 21:28:30
        Started Run 2 @ 21:28:34
        Running Interim Test Script @ 21:28:44
        Started Run 3 @ 21:28:47
        Running Interim Test Script @ 21:28:58  [Std. Dev: 4.81%]
        Started Run 4 @ 21:29:02
        Running Interim Test Script @ 21:29:12  [Std. Dev: 6.05%]
        Started Run 5 @ 21:29:15
        Running Interim Test Script @ 21:29:25  [Std. Dev: 6.13%]
        Started Run 6 @ 21:29:28  [Std. Dev: 6.02%]
        Running Post-Test Script @ 21:29:38

    Test Results:
        10.442322015762
        10.038927078247
        11.044027090073
        9.5781810283661
        9.5812470912933
        9.5545389652252

    Average: 10.04 Seconds

Powertop results:
http://www.semaphore.gr/results/powertop_with.html
