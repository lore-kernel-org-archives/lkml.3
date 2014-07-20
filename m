Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaGTVv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:51:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaGTVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:51:54 -0400
Date: Sun, 20 Jul 2014 23:51:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Eliminate the deadband effect
Message-ID: <20140720215151.GA7817@amd.pavel.ucw.cz>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
 <1404147574-17422-3-git-send-email-stratosk@semaphore.gr>
 <20140711165710.GA18033@amd.pavel.ucw.cz>
 <53C01F15.2090702@semaphore.gr>
 <20140711183414.GA18951@amd.pavel.ucw.cz>
 <53C03CDD.5020701@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C03CDD.5020701@semaphore.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>> Tested on Intel i7-3770 CPU @ 3.40GHz and on ARM quad core 1500MHz Krait
> >>>> (Android smartphone).
> >>>> Benchmarks on Intel i7 shows a performance improvement on low and medium
> >>>> work loads with lower power consumption. Specifics:
> >>>>
> >>>> Phoronix Linux Kernel Compilation 3.1:
> >>>> Time: -0.40%, energy: -0.07%
> >>>> Phoronix Apache:
> >>>> Time: -4.98%, energy: -2.35%
> >>>> Phoronix FFMPEG:
> >>>> Time: -6.29%, energy: -4.02%
> >>>
> >>> Hmm. Intel i7 should be race-to-idle machine. So basically rule like
> >>> if (load > 0) go to max frequency else go to lowest frequency would do
> >>> the right thing in your test, right?
> >>
> >> I don't think that "if (load > 0) go to max" will work even on i7.
> >> For low load this will have impact on energy consumption.
> > 
> > Are you sure? CPU frequency should not matter on idle CPU.
> 
> Even on a totally idle CPU there will be a small impact because of leakage
> current (thanks to Dirk Brandewie for this info).

Are you sure? IIRC Intel cpus will automatically lower CPU frequency
in deep C states..

> This simple test on a nearly idle system shows this:
> 
> [root@albert cpufreq]# for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do [ -f $CPUFREQ ] || continue; echo -n performance > $CPUFREQ; done
> [root@albert cpufreq]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat -J sleep 20
>     Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7   Pkg_J   Cor_J   GFX_J   time
>        -       -       2    0.06    2712    3392       0    0.30    0.00   99.63    0.00      34      34    8.09    0.00   81.94    0.00  380.41   14.51    1.64   20.00
>        0       0       0    0.02    1891    3392       0    0.09    0.00   99.88    0.00      34      34    8.09    0.00   81.94    0.00  380.41   14.51    1.64   20.00
>        0       4       1    0.04    3006    3392       0    0.07
>        1       1       1    0.04    2501    3392       0    0.62    0.00   99.33    0.00      34
>        1       5       0    0.01    2346    3392       0    0.66
>        2       2       0    0.01    1996    3392       0    0.44    0.00   99.55    0.00      34
>        2       6       4    0.18    2278    3392       0    0.26
>        3       3       5    0.15    3449    3392       0    0.07    0.01   99.77    0.00      34
>        3       7       0    0.01    1839    3392       0    0.21
> 20.000899 sec
> [root@albert cpufreq]# ^C
> [root@albert cpufreq]# for CPUFREQ in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do [ -f $CPUFREQ ] || continue; echo -n ondemand > $CPUFREQ; done
> [root@albert cpufreq]# /home/stratosk/kernels/linux-pm/tools/power/x86/turbostat/turbostat -J sleep 20
>     Core     CPU Avg_MHz   %Busy Bzy_MHz TSC_MHz     SMI  CPU%c1  CPU%c3  CPU%c6  CPU%c7 CoreTmp  PkgTmp Pkg%pc2 Pkg%pc3 Pkg%pc6 Pkg%pc7   Pkg_J   Cor_J   GFX_J   time
>        -       -       2    0.09    1693    3392       0    0.35    0.01   99.55    0.00      35      36    8.33    0.00   84.31    0.00  377.68   12.23    1.15   20.00
>        0       0       1    0.08    1603    3392       0    0.13    0.00   99.79    0.00      35      36    8.33    0.00   84.31    0.00  377.68   12.23    1.15   20.00
>        0       4       1    0.08    1646    3392       0    0.13
>        1       1       1    0.06    1647    3392       0    0.66    0.00   99.28    0.00      35
>        1       5       0    0.01    1611    3392       0    0.71
>        2       2       0    0.02    1617    3392       0    0.50    0.02   99.46    0.00      35
>        2       6       4    0.22    1764    3392       0    0.30
>        3       3       4    0.25    1701    3392       0    0.07    0.00   99.68    0.00      35
>        3       7       0    0.01    1602    3392       0    0.31
> 20.001580 sec
> 
> 
> So, for low loads the impact will be higher.

So it seems ondemand saves cca 1% of energy?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
