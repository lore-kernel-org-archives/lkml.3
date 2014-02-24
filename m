Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaBXWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:36:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaBXWgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:36:13 -0500
Date: Mon, 24 Feb 2014 14:37:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Commit fcb6a15c2e7e (intel_pstate: Take core C0 time into
 account for core busy calculation) sucks rocks
Message-ID: <20140224223745.GA26619@kroah.com>
References: <20140219224752.GA370@kroah.com>
 <5305465C.7060806@gmail.com>
 <20140220003537.GA4671@kroah.com>
 <20140220005148.GA15760@kroah.com>
 <53061798.6010703@gmail.com>
 <20140220181046.GA860@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220181046.GA860@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:10:46AM -0800, Greg KH wrote:
> On Thu, Feb 20, 2014 at 06:56:24AM -0800, Dirk Brandewie wrote:
> > On 02/19/2014 04:51 PM, Greg KH wrote:
> > >On Wed, Feb 19, 2014 at 04:35:37PM -0800, Greg KH wrote:
> > >>On Wed, Feb 19, 2014 at 04:03:40PM -0800, Dirk Brandewie wrote:
> > >>>On 02/19/2014 02:47 PM, Greg KH wrote:
> > >>>>Hi Dirk,
> > >>>>
> > >>>>I've been having some huge slowdowns on my box building kernels, and I
> > >>>>took the time to bisect it down to commit
> > >>>>fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 (intel_pstate: Take core C0
> > >>>>time into account for core busy calculation).  With that patch reverted
> > >>>>on Linus's current tree, my build speeds are back up to the normal rate.
> > >>>>
> > >>>>The difference is huge, 2 minutes to do a kernel build with that patch
> > >>>>reverted, 8-10 minutes with it applied!  With all of the stable kernel
> > >>>>builds and other trees, this is a huge problem for my workload (all I do
> > >>>>is kernel builds it seems...)
> > >>>>
> > >>>>I see some patches you marked as "fixes" that you sent to Rafael, do you
> > >>>>want me to test any of those?  How am I the only one seeing this
> > >>>>problem, do you need my cpu information or anything else?
> > >>>
> > >>>Can you give me a description of you build system?  CPU, number of sockets,
> > >>
> > >>The last processor in /proc/cpuinfo:
> > >>
> > >>processor       : 7
> > >>vendor_id       : GenuineIntel
> > >>cpu family      : 6
> > >>model           : 60
> > >>model name      : Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz
> > >>stepping        : 3
> > >>microcode       : 0x9
> > >>cpu MHz         : 3556.464
> > >>cache size      : 8192 KB
> > >>physical id     : 0
> > >>siblings        : 8
> > >>core id         : 3
> > >>cpu cores       : 4
> > >>apicid          : 7
> > >>initial apicid  : 7
> > >>fpu             : yes
> > >>fpu_exception   : yes
> > >>cpuid level     : 13
> > >>wp              : yes
> > >>flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
> > >>bogomips        : 7000.78
> > >>clflush size    : 64
> > >>cache_alignment : 64
> > >>address sizes   : 39 bits physical, 48 bits virtual
> > >>
> > >>>building from/to local media.  Any special setup I should use here for my test?
> > >>
> > >>I build on a SSD-like disk (flash media on PCI Express slot), so I
> > >>should have almost no i/o time.
> > >>
> > >>I build with 'make -j16'
> > >>
> > >>>If you have time having the output of turbostat for a build with and
> > >>>without would be very useful.
> > >>
> > >>  $ ./turbostat
> > >>  turbostat: no /dev/cpu/0/msr
> > >>  Try "# modprobe msr": No such file or directory
> > >>
> > >>Bah, I'll rebuild with msr and get you that info...
> > >
> > >Attached is two files, "fast_build.txt" is when your patch is reverted,
> > >and building a kernel takes only 2 minutes.  "slow_build.txt" is when
> > >the patch is not reverted, using Linus's latest tree, and I stopped it
> > >after a while because I got bored :)
> > >
> > >I think the numbers in these two files shows the real problem that is
> > >happening...
> > 
> > For some reason intel_pstate is deciding you have no load and no increasing
> > the P state :-(
> > >
> > >If there's anything else you need me to test, please let me know.
> > 
> > I are running on Linus's tree could you run the following script with the patch
> > applied and send the output of "perf script".
> > 
> > #! /bin/sh
> > 
> > sudo perf record -C 5  -c 1 -e power:pstate_sample&
> > sleep .5
> > foo=$!
> > taskset -c 5 cat /dev/zero > /dev/null&
> > bar=$!
> > sleep 1
> > kill $bar
> > sleep .5
> > sudo kill $foo
> 
> The output of this is attached below as "bad.perf", and for comparison,
> I ran this with the patch reverted, which is the result in the
> "good.perf" file below.
> 
> Anything else I can test?

Any progress on this?

thanks,

greg k-h
