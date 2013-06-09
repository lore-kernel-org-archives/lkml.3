Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3FISI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 14:08:29 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54709 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667Ab3FISI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 14:08:27 -0400
Message-ID: <51B4C497.2030308@semaphore.gr>
Date: Sun, 09 Jun 2013 21:08:23 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <1731097.2elXaGsAyC@vostro.rjw.lan> <51B394A9.3020005@semaphore.gr> <2892497.M93vsSKx5I@vostro.rjw.lan> <20130609162653.GA5004@pd.tnic>
In-Reply-To: <20130609162653.GA5004@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 07:26 PM, Borislav Petkov wrote:
> On Sun, Jun 09, 2013 at 12:18:09AM +0200, Rafael J. Wysocki wrote:
>> The average power drawn by the package is slightly higher with the
>> patchset applied (27.66 W vs 27.25 W), but since the time needed to
>> complete the workload with the patchset applied was shorter by about
>> 2.3 sec, the total energy used was less in the latter case (by about
>> 25.7 J if I'm not mistaken, or 1% relative). This means that in the
>> absence of a power limit between 27.25 W and 27.66 W it's better to
>> use the kernel with the patchset applied for that particular workload
>> from the performance and energy usage perspective.
>>
>> Good, hopefully that's going to be confirmed on other systems and/or
>> with other workloads. :-)
> 
> Yep, I see similar results on my AMD F15h.
> 
> So there's a register which tells you what the current energy
> consumption in Watts is and support for it is integrated in lm_sensors.
> I did one read per second, for the duration of the kernel build (10-r5 +
> tip), with and without the patch, and averaged out the results:
> 
> without
> =======
> 
> 1. 158 samples, avg Watts: 116.915
> 2. 158 samples, avg Watts: 116.855
> 3. 158 samples, avg Watts: 116.737
> 4. 158 samples, avg Watts: 116.792
> 
> => 116.82475 avg Watts.
> 
> with
> ====
> 
> 1. 157 samples, avg Watts: 116.496
> 2. 156 samples, avg Watts: 117.535
> 3. 156 samples, avg Watts: 118.174
> 4. 157 samples, avg Watts: 117.95
> 
> => 117.53875 avg Watts.
> 
> So there's a slight raise in the average power consumption but the
> samples count drops by 1 or 2, which is consistent with the observed
> kernel build speedup of 1 or 2 seconds.
> 
> perf doesn't show any significant difference with and without the patch
> but those are single runs only.
> 
> without
> =======
> 
>   Performance counter stats for 'make -j9':
> 
>      1167856.647713 task-clock                #    7.272 CPUs utilized
>           1,071,177 context-switches          #    0.917 K/sec
>              52,844 cpu-migrations            #    0.045 K/sec
>          43,600,721 page-faults               #    0.037 M/sec
>   4,712,068,048,465 cycles                    #    4.035 GHz
>   1,181,730,064,794 stalled-cycles-frontend   #   25.08% frontend cycles idle
>     243,576,229,438 stalled-cycles-backend    #    5.17% backend  cycles idle
>   2,966,369,010,209 instructions              #    0.63  insns per cycle
>                                               #    0.40  stalled cycles per insn
>     651,136,706,156 branches                  #  557.548 M/sec
>      34,582,447,788 branch-misses             #    5.31% of all branches
> 
>       160.599796045 seconds time elapsed
> 
> with
> ====
> 
>   Performance counter stats for 'make -j9':
> 
>      1169278.095561 task-clock                #    7.271 CPUs utilized
>           1,076,528 context-switches          #    0.921 K/sec
>              53,284 cpu-migrations            #    0.046 K/sec
>          43,598,610 page-faults               #    0.037 M/sec
>   4,721,747,687,668 cycles                    #    4.038 GHz
>   1,182,301,583,422 stalled-cycles-frontend   #   25.04% frontend cycles idle
>     248,675,448,161 stalled-cycles-backend    #    5.27% backend  cycles idle
>   2,967,419,684,598 instructions              #    0.63  insns per cycle
>                                               #    0.40  stalled cycles per insn
>     651,527,448,140 branches                  #  557.205 M/sec
>      34,560,656,638 branch-misses             #    5.30% of all branches
> 
>       160.811815170 seconds time elapsed

Hi,

Boris, thanks so much for your tests!

Rafael, thanks for your analysis!

I did some additional tests to see how the CPU behaves in it's low and high limits.

I used Phoronix Java SciMark 2.0 test (FFT, Monte Carlo etc) to check the patch in
really heavy loads. The results were almost identical with and without this patch.
This is the expected behavior because I believe the load is greater than up_threshold
most of the time in this cases.
With this patch.
Duration: 120.568521 sec
Pkg_W: 20.97

Without this patch
Duration: 120.606813 sec
Pkg_W: 21.11


I also used a small program to check the CPU in very small loads with duration
comparable to sampling rate (10000 in my config).
The program uses a tight 'for' loop with duration ~ (2 x sampling_rate).
After this it sleeps for 5000us.
I repeat the above for 100 times and then the program sleeps for 1 sec.
The above procedure repeats 15 times.

Results show that there is a slow down (~4%) WITH this patch.
Though, less energy used WITH this patch (25,23J ~3.3%)

Thanks,
Stratos


WITHOUT patch:
----------------
Starting benchmark
run 0
Avg time: 21907 us
run 1
Avg time: 21792 us
run 2
Avg time: 21827 us
run 3
Avg time: 21831 us
run 4
Avg time: 21828 us
run 5
Avg time: 21838 us
run 6
Avg time: 21819 us
run 7
Avg time: 21836 us
run 8
Avg time: 21761 us
run 9
Avg time: 21586 us
run 10
Avg time: 20366 us
run 11
Avg time: 21732 us
run 12
Avg time: 20225 us
run 13
Avg time: 21818 us
run 14
Avg time: 21812 us
Elapsed time: 55004.660000 msec
cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
          8.34 3.30 3.39   0   8.78   0.48  82.41   0.00   43   43   0.00   0.00   0.00   0.00  13.87   8.15  0.00
  0   0   0.28 3.10 3.39   0   0.95   0.26  98.51   0.00   43   43   0.00   0.00   0.00   0.00  13.87   8.15  0.00
  0   4   0.54 2.97 3.39   0   0.69
  1   1   0.18 2.15 3.39   0  59.11   0.03  40.67   0.00   39
  1   5  58.86 3.26 3.39   0   0.43
  2   2   3.20 3.82 3.39   0   0.28   0.03  96.50   0.00   36
  2   6   0.13 2.40 3.39   0   3.34
  3   3   0.47 3.04 3.39   0   4.01   1.58  93.94   0.00   39
  3   7   3.04 3.73 3.39   0   1.45
55.027201 sec


WITH patch
----------
Starting benchmark
run 0
Avg time: 23198 us
run 1
Avg time: 23100 us
run 2
Avg time: 23068 us
run 3
Avg time: 23101 us
run 4
Avg time: 23075 us
run 5
Avg time: 23173 us
run 6
Avg time: 23151 us
run 7
Avg time: 23123 us
run 8
Avg time: 23112 us
run 9
Avg time: 23157 us
run 10
Avg time: 23107 us
run 11
Avg time: 23146 us
run 12
Avg time: 23067 us
run 13
Avg time: 23189 us
run 14
Avg time: 23053 us
Elapsed time: 57288.522000 msec
cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
          7.69 3.03 3.39   0   7.86   0.56  83.89   0.00   44   44   0.00   0.00   0.00   0.00  12.88   7.17  0.00
  0   0  60.24 3.05 3.39   0   0.34   0.02  39.40   0.00   44   44   0.00   0.00   0.00   0.00  12.88   7.17  0.00
  0   4   0.11 1.84 3.39   0  60.47
  1   1   0.22 2.15 3.39   0   0.61   0.04  99.13   0.00   37
  1   5   0.50 2.53 3.39   0   0.33
  2   2   0.12 2.12 3.39   0   0.29   0.11  99.48   0.00   34
  2   6   0.05 2.26 3.39   0   0.36
  3   3   0.31 2.66 3.39   0   0.08   2.08  97.53   0.00   38
  3   7   0.03 1.96 3.39   0   0.37
57.290084 sec
