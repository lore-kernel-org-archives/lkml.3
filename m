Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3FIQ1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:27:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3FIQ1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:27:01 -0400
Date: Sun, 9 Jun 2013 18:26:53 +0200
From: Borislav Petkov <bp@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130609162653.GA5004@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <1731097.2elXaGsAyC@vostro.rjw.lan>
 <51B394A9.3020005@semaphore.gr>
 <2892497.M93vsSKx5I@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2892497.M93vsSKx5I@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 12:18:09AM +0200, Rafael J. Wysocki wrote:
> The average power drawn by the package is slightly higher with the
> patchset applied (27.66 W vs 27.25 W), but since the time needed to
> complete the workload with the patchset applied was shorter by about
> 2.3 sec, the total energy used was less in the latter case (by about
> 25.7 J if I'm not mistaken, or 1% relative). This means that in the
> absence of a power limit between 27.25 W and 27.66 W it's better to
> use the kernel with the patchset applied for that particular workload
> from the performance and energy usage perspective.
>
> Good, hopefully that's going to be confirmed on other systems and/or
> with other workloads. :-)

Yep, I see similar results on my AMD F15h.

So there's a register which tells you what the current energy
consumption in Watts is and support for it is integrated in lm_sensors.
I did one read per second, for the duration of the kernel build (10-r5 +
tip), with and without the patch, and averaged out the results:

without
=======

1. 158 samples, avg Watts: 116.915
2. 158 samples, avg Watts: 116.855
3. 158 samples, avg Watts: 116.737
4. 158 samples, avg Watts: 116.792

=> 116.82475 avg Watts.

with
====

1. 157 samples, avg Watts: 116.496
2. 156 samples, avg Watts: 117.535
3. 156 samples, avg Watts: 118.174
4. 157 samples, avg Watts: 117.95

=> 117.53875 avg Watts.

So there's a slight raise in the average power consumption but the
samples count drops by 1 or 2, which is consistent with the observed
kernel build speedup of 1 or 2 seconds.

perf doesn't show any significant difference with and without the patch
but those are single runs only.

without
=======

 Performance counter stats for 'make -j9':

    1167856.647713 task-clock                #    7.272 CPUs utilized
         1,071,177 context-switches          #    0.917 K/sec
            52,844 cpu-migrations            #    0.045 K/sec
        43,600,721 page-faults               #    0.037 M/sec
 4,712,068,048,465 cycles                    #    4.035 GHz
 1,181,730,064,794 stalled-cycles-frontend   #   25.08% frontend cycles idle
   243,576,229,438 stalled-cycles-backend    #    5.17% backend  cycles idle
 2,966,369,010,209 instructions              #    0.63  insns per cycle
                                             #    0.40  stalled cycles per insn
   651,136,706,156 branches                  #  557.548 M/sec
    34,582,447,788 branch-misses             #    5.31% of all branches

     160.599796045 seconds time elapsed

with
====

 Performance counter stats for 'make -j9':

    1169278.095561 task-clock                #    7.271 CPUs utilized
         1,076,528 context-switches          #    0.921 K/sec
            53,284 cpu-migrations            #    0.046 K/sec
        43,598,610 page-faults               #    0.037 M/sec
 4,721,747,687,668 cycles                    #    4.038 GHz
 1,182,301,583,422 stalled-cycles-frontend   #   25.04% frontend cycles idle
   248,675,448,161 stalled-cycles-backend    #    5.27% backend  cycles idle
 2,967,419,684,598 instructions              #    0.63  insns per cycle
                                             #    0.40  stalled cycles per insn
   651,527,448,140 branches                  #  557.205 M/sec
    34,560,656,638 branch-misses             #    5.30% of all branches

     160.811815170 seconds time elapsed


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
