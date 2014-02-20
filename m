Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaBTSJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:09:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaBTSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:09:19 -0500
Date: Thu, 20 Feb 2014 10:10:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Commit fcb6a15c2e7e (intel_pstate: Take core C0 time into
 account for core busy calculation) sucks rocks
Message-ID: <20140220181046.GA860@kroah.com>
References: <20140219224752.GA370@kroah.com>
 <5305465C.7060806@gmail.com>
 <20140220003537.GA4671@kroah.com>
 <20140220005148.GA15760@kroah.com>
 <53061798.6010703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <53061798.6010703@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 06:56:24AM -0800, Dirk Brandewie wrote:
> On 02/19/2014 04:51 PM, Greg KH wrote:
> >On Wed, Feb 19, 2014 at 04:35:37PM -0800, Greg KH wrote:
> >>On Wed, Feb 19, 2014 at 04:03:40PM -0800, Dirk Brandewie wrote:
> >>>On 02/19/2014 02:47 PM, Greg KH wrote:
> >>>>Hi Dirk,
> >>>>
> >>>>I've been having some huge slowdowns on my box building kernels, and I
> >>>>took the time to bisect it down to commit
> >>>>fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 (intel_pstate: Take core C0
> >>>>time into account for core busy calculation).  With that patch reverted
> >>>>on Linus's current tree, my build speeds are back up to the normal rate.
> >>>>
> >>>>The difference is huge, 2 minutes to do a kernel build with that patch
> >>>>reverted, 8-10 minutes with it applied!  With all of the stable kernel
> >>>>builds and other trees, this is a huge problem for my workload (all I do
> >>>>is kernel builds it seems...)
> >>>>
> >>>>I see some patches you marked as "fixes" that you sent to Rafael, do you
> >>>>want me to test any of those?  How am I the only one seeing this
> >>>>problem, do you need my cpu information or anything else?
> >>>
> >>>Can you give me a description of you build system?  CPU, number of sockets,
> >>
> >>The last processor in /proc/cpuinfo:
> >>
> >>processor       : 7
> >>vendor_id       : GenuineIntel
> >>cpu family      : 6
> >>model           : 60
> >>model name      : Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz
> >>stepping        : 3
> >>microcode       : 0x9
> >>cpu MHz         : 3556.464
> >>cache size      : 8192 KB
> >>physical id     : 0
> >>siblings        : 8
> >>core id         : 3
> >>cpu cores       : 4
> >>apicid          : 7
> >>initial apicid  : 7
> >>fpu             : yes
> >>fpu_exception   : yes
> >>cpuid level     : 13
> >>wp              : yes
> >>flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
> >>bogomips        : 7000.78
> >>clflush size    : 64
> >>cache_alignment : 64
> >>address sizes   : 39 bits physical, 48 bits virtual
> >>
> >>>building from/to local media.  Any special setup I should use here for my test?
> >>
> >>I build on a SSD-like disk (flash media on PCI Express slot), so I
> >>should have almost no i/o time.
> >>
> >>I build with 'make -j16'
> >>
> >>>If you have time having the output of turbostat for a build with and
> >>>without would be very useful.
> >>
> >>  $ ./turbostat
> >>  turbostat: no /dev/cpu/0/msr
> >>  Try "# modprobe msr": No such file or directory
> >>
> >>Bah, I'll rebuild with msr and get you that info...
> >
> >Attached is two files, "fast_build.txt" is when your patch is reverted,
> >and building a kernel takes only 2 minutes.  "slow_build.txt" is when
> >the patch is not reverted, using Linus's latest tree, and I stopped it
> >after a while because I got bored :)
> >
> >I think the numbers in these two files shows the real problem that is
> >happening...
> 
> For some reason intel_pstate is deciding you have no load and no increasing
> the P state :-(
> >
> >If there's anything else you need me to test, please let me know.
> 
> I are running on Linus's tree could you run the following script with the patch
> applied and send the output of "perf script".
> 
> #! /bin/sh
> 
> sudo perf record -C 5  -c 1 -e power:pstate_sample&
> sleep .5
> foo=$!
> taskset -c 5 cat /dev/zero > /dev/null&
> bar=$!
> sleep 1
> kill $bar
> sleep .5
> sudo kill $foo

The output of this is attached below as "bad.perf", and for comparison,
I ran this with the patch reverted, which is the result in the
"good.perf" file below.

Anything else I can test?

thanks,

greg k-h

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bad.perf"

# ========
# captured on: Thu Feb 20 10:08:29 2014
# hostname : thunder
# os release : 3.14.0-rc3-00168-g960dfc4eb23a
# perf version : 3.13.3
# arch : x86_64
# nrcpus online : 8
# nrcpus avail : 8
# cpudesc : Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz
# cpuid : GenuineIntel,6,60,3
# total memory : 7843716 kB
# cmdline : /usr/bin/perf record -C 5 -c 1 -e power:pstate_sample 
# event : name = power:pstate_sample, type = 2, config = 0x97, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 0, attr_mmap  = 1, attr_mmap_data = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, breakpoint = 5
# ========
#
            :821   821 [005]    33.459535: power:pstate_sample: core_busy=0 scaled=0 state=8 mperf=967942 aperf=221343 freq=770000 
             cat   821 [005]    33.469539: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34967293 aperf=7992496 freq=770000 
             cat   821 [005]    33.479547: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34982605 aperf=7996061 freq=770000 
             cat   821 [005]    33.489558: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989377 aperf=7997575 freq=770000 
             cat   821 [005]    33.499570: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990148 aperf=7997758 freq=770000 
             cat   821 [005]    33.509581: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34988992 aperf=7997486 freq=770000 
             cat   821 [005]    33.519593: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989728 aperf=7997651 freq=770000 
             cat   821 [005]    33.529605: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989955 aperf=7997704 freq=770000 
             cat   821 [005]    33.539617: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989832 aperf=7997673 freq=770000 
             cat   821 [005]    33.549628: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989763 aperf=7997664 freq=770000 
             cat   821 [005]    33.559640: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990795 aperf=7997894 freq=770000 
             cat   821 [005]    33.569652: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34988817 aperf=7997446 freq=770000 
             cat   821 [005]    33.579663: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990130 aperf=7997740 freq=770000 
             cat   821 [005]    33.589675: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989955 aperf=7997706 freq=770000 
             cat   821 [005]    33.599687: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989378 aperf=7997572 freq=770000 
             cat   821 [005]    33.609699: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989867 aperf=7997683 freq=770000 
             cat   821 [005]    33.619711: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990218 aperf=7997766 freq=770000 
             cat   821 [005]    33.629722: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989570 aperf=7997613 freq=770000 
             cat   821 [005]    33.639734: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989395 aperf=7997579 freq=770000 
             cat   821 [005]    33.649746: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990077 aperf=7997730 freq=770000 
             cat   821 [005]    33.659757: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989920 aperf=7997696 freq=770000 
             cat   821 [005]    33.669769: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989570 aperf=7997617 freq=770000 
             cat   821 [005]    33.679781: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990008 aperf=7997713 freq=770000 
             cat   821 [005]    33.689792: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989517 aperf=7997609 freq=770000 
             cat   821 [005]    33.699804: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990463 aperf=7997806 freq=770000 
             cat   821 [005]    33.709816: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990060 aperf=7997738 freq=770000 
             cat   821 [005]    33.719828: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989570 aperf=7997619 freq=770000 
             cat   821 [005]    33.729840: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989762 aperf=7997660 freq=770000 
             cat   821 [005]    33.739852: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990393 aperf=7997789 freq=770000 
             cat   821 [005]    33.749865: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34993507 aperf=7998508 freq=770000 
             cat   821 [005]    33.759876: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989518 aperf=7997615 freq=770000 
             cat   821 [005]    33.769887: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34985720 aperf=7996737 freq=770000 
             cat   821 [005]    33.779898: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989920 aperf=7997708 freq=770000 
             cat   821 [005]    33.789910: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989710 aperf=7997646 freq=770000 
             cat   821 [005]    33.799922: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990322 aperf=7997789 freq=770000 
             cat   821 [005]    33.809933: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989063 aperf=7997499 freq=770000 
             cat   821 [005]    33.819945: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990112 aperf=7997736 freq=770000 
             cat   821 [005]    33.829957: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989955 aperf=7997707 freq=770000 
             cat   821 [005]    33.839969: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990305 aperf=7997786 freq=770000 
             cat   821 [005]    33.849980: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989763 aperf=7997662 freq=770000 
             cat   821 [005]    33.859992: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989377 aperf=7997568 freq=770000 
             cat   821 [005]    33.870004: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989675 aperf=7997643 freq=770000 
             cat   821 [005]    33.880015: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989658 aperf=7997635 freq=770000 
             cat   821 [005]    33.890027: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990112 aperf=7997738 freq=770000 
             cat   821 [005]    33.900039: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989833 aperf=7997673 freq=770000 
             cat   821 [005]    33.910051: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989692 aperf=7997645 freq=770000 
             cat   821 [005]    33.920063: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990130 aperf=7997744 freq=770000 
             cat   821 [005]    33.930074: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989815 aperf=7997671 freq=770000 
             cat   821 [005]    33.940086: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989675 aperf=7997641 freq=770000 
             cat   821 [005]    33.950098: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989675 aperf=7997641 freq=770000 
             cat   821 [005]    33.960109: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989745 aperf=7997661 freq=770000 
             cat   821 [005]    33.970121: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990445 aperf=7997806 freq=770000 
             cat   821 [005]    33.980133: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989763 aperf=7997667 freq=770000 
             cat   821 [005]    33.990145: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989465 aperf=7997590 freq=770000 
             cat   821 [005]    34.000156: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990165 aperf=7997754 freq=770000 
             cat   821 [005]    34.010168: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989430 aperf=7997581 freq=770000 
             cat   821 [005]    34.020180: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990200 aperf=7997757 freq=770000 
             cat   821 [005]    34.030192: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989745 aperf=7997660 freq=770000 
             cat   821 [005]    34.040203: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990025 aperf=7997724 freq=770000 
             cat   821 [005]    34.050215: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990532 aperf=7997837 freq=770000 
             cat   821 [005]    34.060227: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34988643 aperf=7997398 freq=770000 
             cat   821 [005]    34.070239: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990287 aperf=7997782 freq=770000 
             cat   821 [005]    34.080250: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989465 aperf=7997590 freq=770000 
             cat   821 [005]    34.090262: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990375 aperf=7997804 freq=770000 
             cat   821 [005]    34.100274: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989308 aperf=7997557 freq=770000 
             cat   821 [005]    34.110286: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990060 aperf=7997729 freq=770000 
             cat   821 [005]    34.120297: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989727 aperf=7997652 freq=770000 
             cat   821 [005]    34.130309: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989990 aperf=7997709 freq=770000 
             cat   821 [005]    34.140321: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989868 aperf=7997680 freq=770000 
             cat   821 [005]    34.150333: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989745 aperf=7997658 freq=770000 
             cat   821 [005]    34.160344: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989902 aperf=7997695 freq=770000 
             cat   821 [005]    34.170356: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989903 aperf=7997689 freq=770000 
             cat   821 [005]    34.180368: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989780 aperf=7997669 freq=770000 
             cat   821 [005]    34.190380: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989797 aperf=7997666 freq=770000 
             cat   821 [005]    34.200391: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989938 aperf=7997699 freq=770000 
             cat   821 [005]    34.210403: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989727 aperf=7997650 freq=770000 
             cat   821 [005]    34.220415: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989938 aperf=7997704 freq=770000 
             cat   821 [005]    34.230426: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989675 aperf=7997639 freq=770000 
             cat   821 [005]    34.240438: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989832 aperf=7997665 freq=770000 
             cat   821 [005]    34.250450: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989693 aperf=7997653 freq=770000 
             cat   821 [005]    34.260462: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989745 aperf=7997660 freq=770000 
             cat   821 [005]    34.270473: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989972 aperf=7997707 freq=770000 
             cat   821 [005]    34.280485: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989885 aperf=7997689 freq=770000 
             cat   821 [005]    34.290497: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989535 aperf=7997605 freq=770000 
             cat   821 [005]    34.300509: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989763 aperf=7997662 freq=770000 
             cat   821 [005]    34.310520: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990007 aperf=7997717 freq=770000 
             cat   821 [005]    34.320532: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990113 aperf=7997738 freq=770000 
             cat   821 [005]    34.330544: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989832 aperf=7997678 freq=770000 
             cat   821 [005]    34.340556: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989675 aperf=7997639 freq=770000 
             cat   821 [005]    34.350568: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990113 aperf=7997735 freq=770000 
             cat   821 [005]    34.360579: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989360 aperf=7997568 freq=770000 
             cat   821 [005]    34.370591: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34990182 aperf=7997758 freq=770000 
             cat   821 [005]    34.380602: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989535 aperf=7997610 freq=770000 
             cat   821 [005]    34.390614: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989780 aperf=7997664 freq=770000 
             cat   821 [005]    34.400627: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34991985 aperf=7998164 freq=770000 
             cat   821 [005]    34.410638: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34987750 aperf=7997204 freq=770000 
             cat   821 [005]    34.420649: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989728 aperf=7997652 freq=770000 
             cat   821 [005]    34.430662: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34990602 aperf=7997837 freq=770000 
             cat   821 [005]    34.440673: power:pstate_sample: core_busy=22 scaled=96 state=8 mperf=34989570 aperf=7997630 freq=770000 
             cat   821 [005]    34.450685: power:pstate_sample: core_busy=22 scaled=97 state=8 mperf=34989675 aperf=7997637 freq=770000 
         swapper     0 [005]    34.470751: power:pstate_sample: core_busy=11 scaled=48 state=8 mperf=34905746 aperf=7978460 freq=770000 
         swapper     0 [005]    34.484100: power:pstate_sample: core_busy=0 scaled=0 state=8 mperf=129641 aperf=29655 freq=770000 
         swapper     0 [005]    34.497456: power:pstate_sample: core_busy=0 scaled=0 state=8 mperf=170450 aperf=38984 freq=770000 
         swapper     0 [005]    34.510793: power:pstate_sample: core_busy=0 scaled=0 state=8 mperf=415013 aperf=94909 freq=770000 
         swapper     0 [005]    34.971331: power:pstate_sample: core_busy=0 scaled=0 state=8 mperf=385821 aperf=88241 freq=770000 

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="good.perf"

# ========
# captured on: Thu Feb 20 10:04:27 2014
# hostname : thunder
# os release : 3.14.0-rc3-00169-g61d81fafdf07
# perf version : 3.13.3
# arch : x86_64
# nrcpus online : 8
# nrcpus avail : 8
# cpudesc : Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz
# cpuid : GenuineIntel,6,60,3
# total memory : 7843720 kB
# cmdline : /usr/bin/perf record -C 5 -c 1 -e power:pstate_sample 
# event : name = power:pstate_sample, type = 2, config = 0x97, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 0, attr_mmap  = 1, attr_mmap_data = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, breakpoint = 5
# ========
#
         swapper     0 [005] 61435.228822: power:pstate_sample: core_busy=105 scaled=96 state=38 mperf=117675 aperf=124347 freq=3698378 
             cat 20481 [005] 61435.672634: power:pstate_sample: core_busy=101 scaled=92 state=38 mperf=6401489 aperf=6483508 freq=3544707 
             cat 20481 [005] 61435.682644: power:pstate_sample: core_busy=108 scaled=97 state=39 mperf=34983090 aperf=37981660 freq=3799960 
             cat 20481 [005] 61435.692654: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34886623 aperf=38868334 freq=3899355 
             cat 20481 [005] 61435.702666: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34890066 aperf=38872130 freq=3899355 
             cat 20481 [005] 61435.712678: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34897018 aperf=38884312 freq=3899902 
             cat 20481 [005] 61435.722690: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989661 aperf=38988486 freq=3899902 
             cat 20481 [005] 61435.732701: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34898491 aperf=38885509 freq=3899765 
             cat 20481 [005] 61435.742713: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989780 aperf=38988611 freq=3899902 
             cat 20481 [005] 61435.752725: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989735 aperf=38988548 freq=3899902 
             cat 20481 [005] 61435.762737: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989941 aperf=38988800 freq=3899902 
             cat 20481 [005] 61435.772748: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989789 aperf=38988624 freq=3899902 
             cat 20481 [005] 61435.782760: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989908 aperf=38988754 freq=3899902 
             cat 20481 [005] 61435.792772: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989759 aperf=38988583 freq=3899902 
             cat 20481 [005] 61435.802783: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989938 aperf=38988790 freq=3899902 
             cat 20481 [005] 61435.812795: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989708 aperf=38988514 freq=3899902 
             cat 20481 [005] 61435.822807: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989858 aperf=38988721 freq=3899902 
             cat 20481 [005] 61435.832819: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989929 aperf=38988778 freq=3899902 
             cat 20481 [005] 61435.842830: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989765 aperf=38988592 freq=3899902 
             cat 20481 [005] 61435.852842: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989789 aperf=38988620 freq=3899902 
             cat 20481 [005] 61435.862854: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989884 aperf=38988726 freq=3899902 
             cat 20481 [005] 61435.872866: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989801 aperf=38988640 freq=3899902 
             cat 20481 [005] 61435.882877: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989828 aperf=38988670 freq=3899902 
             cat 20481 [005] 61435.892889: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989955 aperf=38988789 freq=3899902 
             cat 20481 [005] 61435.902901: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989697 aperf=38988530 freq=3899902 
             cat 20481 [005] 61435.912913: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989795 aperf=38988633 freq=3899902 
             cat 20481 [005] 61435.922924: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989857 aperf=38988683 freq=3899902 
             cat 20481 [005] 61435.932936: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989992 aperf=38988862 freq=3899902 
             cat 20481 [005] 61435.942948: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989741 aperf=38988560 freq=3899902 
             cat 20481 [005] 61435.952960: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989807 aperf=38988651 freq=3899902 
             cat 20481 [005] 61435.962972: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989890 aperf=38988726 freq=3899902 
             cat 20481 [005] 61435.972983: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989837 aperf=38988689 freq=3899902 
             cat 20481 [005] 61435.982995: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990590 aperf=38989482 freq=3899902 
             cat 20481 [005] 61435.993007: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990051 aperf=38988923 freq=3899902 
             cat 20481 [005] 61436.003018: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34924586 aperf=38914564 freq=3899765 
             cat 20481 [005] 61436.013030: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989685 aperf=38988521 freq=3899902 
             cat 20481 [005] 61436.023042: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989902 aperf=38988741 freq=3899902 
             cat 20481 [005] 61436.033054: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990355 aperf=38989256 freq=3899902 
             cat 20481 [005] 61436.043065: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989244 aperf=38988021 freq=3899902 
             cat 20481 [005] 61436.053077: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989988 aperf=38988830 freq=3899902 
             cat 20481 [005] 61436.063089: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989807 aperf=38988648 freq=3899902 
             cat 20481 [005] 61436.073100: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989783 aperf=38988614 freq=3899902 
             cat 20481 [005] 61436.083112: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989756 aperf=38988581 freq=3899902 
             cat 20481 [005] 61436.093124: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989905 aperf=38988745 freq=3899902 
             cat 20481 [005] 61436.103136: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989774 aperf=38988606 freq=3899902 
             cat 20481 [005] 61436.113147: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989926 aperf=38988775 freq=3899902 
             cat 20481 [005] 61436.123159: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989709 aperf=38988551 freq=3899902 
             cat 20481 [005] 61436.133171: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989887 aperf=38988719 freq=3899902 
             cat 20481 [005] 61436.143183: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34991031 aperf=38989992 freq=3899902 
             cat 20481 [005] 61436.153195: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989449 aperf=38988243 freq=3899902 
             cat 20481 [005] 61436.163206: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989089 aperf=38987846 freq=3899902 
             cat 20481 [005] 61436.173218: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989715 aperf=38988556 freq=3899902 
             cat 20481 [005] 61436.183230: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989920 aperf=38988771 freq=3899902 
             cat 20481 [005] 61436.193241: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989857 aperf=38988680 freq=3899902 
             cat 20481 [005] 61436.203253: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989956 aperf=38988819 freq=3899902 
             cat 20481 [005] 61436.213265: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989589 aperf=38988388 freq=3899902 
             cat 20481 [005] 61436.223276: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989417 aperf=38988215 freq=3899902 
             cat 20481 [005] 61436.233288: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990236 aperf=38989130 freq=3899902 
             cat 20481 [005] 61436.243300: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989926 aperf=38988776 freq=3899902 
             cat 20481 [005] 61436.253312: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989675 aperf=38988470 freq=3899902 
             cat 20481 [005] 61436.263324: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990087 aperf=38988963 freq=3899902 
             cat 20481 [005] 61436.273335: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989652 aperf=38988472 freq=3899902 
             cat 20481 [005] 61436.283347: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989771 aperf=38988601 freq=3899902 
             cat 20481 [005] 61436.293359: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989849 aperf=38988703 freq=3899902 
             cat 20481 [005] 61436.303370: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989887 aperf=38988725 freq=3899902 
             cat 20481 [005] 61436.313382: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989813 aperf=38988651 freq=3899902 
             cat 20481 [005] 61436.323394: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989881 aperf=38988715 freq=3899902 
             cat 20481 [005] 61436.333406: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989825 aperf=38988678 freq=3899902 
             cat 20481 [005] 61436.343418: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34993041 aperf=38992225 freq=3899902 
             cat 20481 [005] 61436.353429: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34986632 aperf=38985120 freq=3899902 
             cat 20481 [005] 61436.363441: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989747 aperf=38988566 freq=3899902 
             cat 20481 [005] 61436.373453: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989914 aperf=38988762 freq=3899902 
             cat 20481 [005] 61436.383464: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989923 aperf=38988763 freq=3899902 
             cat 20481 [005] 61436.393476: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989759 aperf=38988595 freq=3899902 
             cat 20481 [005] 61436.403488: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34931709 aperf=38825285 freq=3890058 
             cat 20481 [005] 61436.413500: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989726 aperf=38988542 freq=3899902 
             cat 20481 [005] 61436.423512: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34993703 aperf=38992984 freq=3899902 
             cat 20481 [005] 61436.433523: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34986060 aperf=38984480 freq=3899902 
             cat 20481 [005] 61436.443535: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34990086 aperf=38988929 freq=3899902 
             cat 20481 [005] 61436.453547: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989646 aperf=38988460 freq=3899902 
             cat 20481 [005] 61436.463558: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989733 aperf=38988584 freq=3899902 
             cat 20481 [005] 61436.473570: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989824 aperf=38988639 freq=3899902 
             cat 20481 [005] 61436.483582: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989837 aperf=38988691 freq=3899902 
             cat 20481 [005] 61436.493593: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989825 aperf=38988671 freq=3899902 
             cat 20481 [005] 61436.503605: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989827 aperf=38988646 freq=3899902 
             cat 20481 [005] 61436.513617: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989819 aperf=38988662 freq=3899902 
             cat 20481 [005] 61436.523629: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989878 aperf=38988713 freq=3899902 
             cat 20481 [005] 61436.533640: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989783 aperf=38988615 freq=3899902 
             cat 20481 [005] 61436.543652: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989882 aperf=38988749 freq=3899902 
             cat 20481 [005] 61436.553664: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989809 aperf=38988620 freq=3899902 
             cat 20481 [005] 61436.563676: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989885 aperf=38988752 freq=3899902 
             cat 20481 [005] 61436.573687: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989842 aperf=38988660 freq=3899902 
             cat 20481 [005] 61436.583699: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989807 aperf=38988645 freq=3899902 
             cat 20481 [005] 61436.593711: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989807 aperf=38988656 freq=3899902 
             cat 20481 [005] 61436.603723: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989786 aperf=38988618 freq=3899902 
             cat 20481 [005] 61436.613734: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989857 aperf=38988686 freq=3899902 
             cat 20481 [005] 61436.623746: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989950 aperf=38988804 freq=3899902 
             cat 20481 [005] 61436.633758: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989741 aperf=38988564 freq=3899902 
             cat 20481 [005] 61436.643770: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989855 aperf=38988706 freq=3899902 
             cat 20481 [005] 61436.653781: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989973 aperf=38988801 freq=3899902 
             cat 20481 [005] 61436.663793: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=34989655 aperf=38988487 freq=3899902 
         swapper     0 [005] 61436.683852: power:pstate_sample: core_busy=111 scaled=99 state=39 mperf=28745848 aperf=32026974 freq=3899492 
         swapper     0 [005] 61436.697202: power:pstate_sample: core_busy=100 scaled=91 state=38 mperf=124360 aperf=124457 freq=3502597 
         swapper     0 [005] 61436.710551: power:pstate_sample: core_busy=100 scaled=94 state=37 mperf=129452 aperf=129543 freq=3502324 

--VbJkn9YxBvnuCH5J--
