Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3HXVDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:03:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49846 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3HXVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:03:43 -0400
Date: Sat, 24 Aug 2013 14:03:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tibor Billes <tbilles@gmx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unusually high system CPU usage with recent kernels
Message-ID: <20130824210336.GJ3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130824195945.44760@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130824195945.44760@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082421-1542-0000-0000-000000CA42A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 09:59:45PM +0200, Tibor Billes wrote:
> From: Paul E. McKenney Sent: 08/22/13 12:09 AM
> > On Wed, Aug 21, 2013 at 11:05:51PM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 08/21/13 09:12 PM
> > > > On Wed, Aug 21, 2013 at 08:14:46PM +0200, Tibor Billes wrote:
> > > > > > From: Paul E. McKenney Sent: 08/20/13 11:43 PM
> > > > > > On Tue, Aug 20, 2013 at 10:52:26PM +0200, Tibor Billes wrote:
> > > > > > > > From: Paul E. McKenney Sent: 08/20/13 04:53 PM
> > > > > > > > On Tue, Aug 20, 2013 at 08:01:28AM +0200, Tibor Billes wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
> > > > > > > > > The 3.10.x series was showing unusually high (>75%) system CPU usage in some
> > > > > > > > > situations, making things really slow. The latest stable I tried is 3.10.7.
> > > > > > > > > I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
> > > > > > > > > show up when the system is idling, only when doing some CPU intensive work,
> > > > > > > > > like compiling with multiple threads. Compiling with only one thread seems not
> > > > > > > > > to trigger this behaviour.
> > > > > > > > > 
> > > > > > > > > To be more precise I did a `perf record -a` while compiling a large C++ program
> > > > > > > > > with scons using 4 threads, the result is appended at the end of this email.
> > > > > > > > 
> > > > > > > > New one on me! You are running a mainstream system (x86_64), so I am
> > > > > > > > surprised no one else noticed.
> > > > > > > > 
> > > > > > > > Could you please send along your .config file?
> > > > > > > 
> > > > > > > Here it is
> > > > > > 
> > > > > > Interesting. I don't see RCU stuff all that high on the list, but
> > > > > > the items I do see lead me to suspect RCU_FAST_NO_HZ, which has some
> > > > > > relevance to the otherwise inexplicable group of commits you located
> > > > > > with your bisection. Could you please rerun with CONFIG_RCU_FAST_NO_HZ=n?
> > > > > > 
> > > > > > If that helps, there are some things I could try.
> > > > > 
> > > > > It did help. I didn't notice anything unusual when running with CONFIG_RCU_FAST_NO_HZ=n.
> > > > 
> > > > Interesting. Thank you for trying this -- and we at least have a
> > > > short-term workaround for this problem. I will put a patch together
> > > > for further investigation.
> > > 
> > > I don't specifically need this config option so I'm fine without it in
> > > the long term, but I guess it's not supposed to behave like that.
> > 
> > OK, good, we have a long-term workload for your specific case,
> > even better. ;-)
> > 
> > But yes, there are situations where RCU_FAST_NO_HZ needs to work
> > a bit better. I hope you will bear with me with a bit more
> > testing...
> >
> > > > In the meantime, could you please tell me how you were measuring
> > > > performance for your kernel builds? Wall-clock time required to complete
> > > > one build? Number of builds completed per unit time? Something else?
> > > 
> > > Actually, I wasn't all this sophisticated. I have a system monitor
> > > applet on my top panel (using MATE, Linux Mint), four little graphs,
> > > one of which shows CPU usage. Different colors indicate different kind
> > > of CPU usage. Blue shows user space usage, red shows system usage, and
> > > two more for nice and iowait. During a normal compile it's almost
> > > completely filled with blue user space CPU usage, only the top few
> > > pixels show some iowait and system usage. With CONFIG_RCU_FAST_NO_HZ
> > > set, about 3/4 of the graph was red system CPU usage, the rest was
> > > blue. So I just looked for a pile of red on my graphs when I tested
> > > different kernel builds. But also compile speed was horrible I couldn't
> > > wait for the build to finish. Even the UI got unresponsive.
> > 
> > We have been having problems with CPU accounting, but this one looks
> > quite real.
> > 
> > > Now I did some measuring. In the normal case a compile finished in 36
> > > seconds, compiled 315 object files. Here are some output lines from
> > > dstat -tasm --vm during compile:
> > > ----system---- ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- ----swap--- ------memory-usage----- -----virtual-memory----
> > >     time     |usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw | used  free| used  buff  cach  free|majpf minpf alloc  free
> > > 21-08 21:48:05| 91   8   2   0   0   0|   0  5852k|   0     0 |   0     0 |1413  1772 |   0  7934M| 581M 58.0M  602M 6553M|   0    71k   46k   54k
> > > 21-08 21:48:06| 93   6   1   0   0   0|   0  2064k| 137B  131B|   0     0 |1356  1650 |   0  7934M| 649M 58.0M  604M 6483M|   0    72k   47k   28k
> > > 21-08 21:48:07| 86  11   4   0   0   0|   0  5872k|   0     0 |   0     0 |2000  2991 |   0  7934M| 577M 58.0M  627M 6531M|   0    99k   67k   79k
> > > 21-08 21:48:08| 87   9   3   0   0   0|   0  2840k|   0     0 |   0     0 |2558  4164 |   0  7934M| 597M 58.0M  632M 6507M|   0    96k   57k   51k
> > > 21-08 21:48:09| 93   7   1   0   0   0|   0  3032k|   0     0 |   0     0 |1329  1512 |   0  7934M| 641M 58.0M  626M 6469M|   0    61k   48k   39k
> > > 21-08 21:48:10| 93   6   0   0   0   0|   0  4984k|   0     0 |   0     0 |1160  1146 |   0  7934M| 572M 58.0M  628M 6536M|   0    50k   40k   57k
> > > 21-08 21:48:11| 86   9   6   0   0   0|   0  2520k|   0     0 |   0     0 |2947  4760 |   0  7934M| 605M 58.0M  631M 6500M|   0   103k   55k   45k
> > > 21-08 21:48:12| 90   8   2   0   0   0|   0  2840k|   0     0 |   0     0 |2674  4179 |   0  7934M| 671M 58.0M  635M 6431M|   0    84k   59k   42k
> > > 21-08 21:48:13| 90   9   1   0   0   0|   0  4656k|   0     0 |   0     0 |1223  1410 |   0  7934M| 643M 58.0M  638M 6455M|   0    90k   62k   68k
> > > 21-08 21:48:14| 91   8   1   0   0   0|   0  3572k|   0     0 |   0     0 |1432  1828 |   0  7934M| 647M 58.0M  641M 6447M|   0    81k   59k   57k
> > > 21-08 21:48:15| 91   8   1   0   0   0|   0  5116k| 116B    0 |   0     0 |1194  1295 |   0  7934M| 605M 58.0M  644M 6487M|   0    69k   54k   64k
> > > 21-08 21:48:16| 87  10   3   0   0   0|   0  5140k|   0     0 |   0     0 |1761  2586 |   0  7934M| 584M 58.0M  650M 6502M|   0   105k   64k   68k
> > > 
> > > The abnormal case compiled only 182 object file in 6 and a half minutes,
> > > then I stopped it. The same dstat output for this case:
> > > ----system---- ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system-- ----swap--- ------memory-usage----- -----virtual-memory----
> > >     time     |usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw | used  free| used  buff  cach  free|majpf minpf alloc  free
> > > 21-08 22:10:49| 27  62   0   0  11   0|   0     0 | 210B    0 |   0     0 |1414  3137k|   0  7934M| 531M 57.6M  595M 6611M|   0  1628  1250   322 
> > > 21-08 22:10:50| 25  60   4   0  11   0|   0    88k| 126B    0 |   0     0 |1337  3110k|   0  7934M| 531M 57.6M  595M 6611M|   0    91   128   115 
> > > 21-08 22:10:51| 26  63   0   0  11   0|   0   184k| 294B    0 |   0     0 |1411  3147k|   0  7934M| 531M 57.6M  595M 6611M|   0  1485   814   815 
> > > 21-08 22:10:52| 26  63   0   0  11   0|   0     0 | 437B  239B|   0     0 |1355  3160k|   0  7934M| 531M 57.6M  595M 6611M|   0    24    94    97 
> > > 21-08 22:10:53| 26  63   0   0  11   0|   0     0 | 168B    0 |   0     0 |1397  3155k|   0  7934M| 531M 57.6M  595M 6611M|   0   479   285   273 
> > > 21-08 22:10:54| 26  63   0   0  11   0|   0  4096B| 396B  324B|   0     0 |1346  3154k|   0  7934M| 531M 57.6M  595M 6611M|   0    27   145   145 
> > > 21-08 22:10:55| 26  63   0   0  11   0|   0    60k|   0     0 |   0     0 |1353  3148k|   0  7934M| 531M 57.6M  595M 6610M|   0    93   117    36 
> > > 21-08 22:10:56| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1341  3172k|   0  7934M| 531M 57.6M  595M 6610M|   0   158    87    74 
> > > 21-08 22:10:57| 26  62   1   0  11   0|   0     0 |  42B   60B|   0     0 |1332  3162k|   0  7934M| 531M 57.6M  595M 6610M|   0    56    82    78 
> > > 21-08 22:10:58| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1334  3178k|   0  7934M| 531M 57.6M  595M 6610M|   0    26    56    56 
> > > 21-08 22:10:59| 26  63   0   0  11   0|   0     0 |   0     0 |   0     0 |1336  3179k|   0  7934M| 531M 57.6M  595M 6610M|   0     3    33    32 
> > > 21-08 22:11:00| 26  63   0   0  11   0|   0    24k|  90B  108B|   0     0 |1347  3172k|   0  7934M| 531M 57.6M  595M 6610M|   0    41    73    71
> > > 
> > > I have four logical cores so 25% makes up 1 core. I don't know if the ~26% user CPU usage has anthing to do with this fact or just coincidence. The rest is ~63% system and ~11% hardware interrupt. Do these support what you suspect?
> > 
> > The massive increase in context switches does come as a bit of a surprise!
> > It does rule out my initial suspicion of lock contention, but then again
> > the fact that you have only four CPUs made that pretty unlikely to begin
> > with.
> > 
> > 2.4k average context switches in the good case for the full run vs. 3,156k
> > for about half of a run in the bad case. That is an increase of more
> > than three orders of magnitude!
> > 
> > Yow!!!
> > 
> > Page faults are actually -higher- in the good case. You have about 6.5GB
> > free in both cases, so you are not running out of memory. Lots more disk
> > writes in the good case, perhaps consistent with its getting more done.
> > Networking is negligible in both cases.
> > 
> > Lots of hardware interrupts in the bad case as well. Would you be willing
> > to take a look at /proc/interrupts before and after to see which one you
> > are getting hit with? (Or whatever interrupt tracking tool you prefer.)
> 
> Here are the results.
> 
> Good case before:
>            CPU0       CPU1       CPU2       CPU3       
>   0:         17          0          0          0   IO-APIC-edge      timer
>   1:        356          1         68          4   IO-APIC-edge      i8042
>   8:          0          0          1          0   IO-APIC-edge      rtc0
>   9:        330         14        449         71   IO-APIC-fasteoi   acpi
>  12:         10        108        269       2696   IO-APIC-edge      i8042
>  16:         36         10        111          2   IO-APIC-fasteoi   ehci_hcd:usb1
>  17:         20          3         25          4   IO-APIC-fasteoi   mmc0
>  21:          3          0         34          0   IO-APIC-fasteoi   ehci_hcd:usb2
>  40:          0          1         12         11   PCI-MSI-edge      mei_me
>  41:      10617        173       9959        292   PCI-MSI-edge      ahci
>  42:        862         11        186         26   PCI-MSI-edge      xhci_hcd
>  43:        107         77         27        102   PCI-MSI-edge      i915
>  44:       5322         20        434         22   PCI-MSI-edge      iwlwifi
>  45:        180          0        183         86   PCI-MSI-edge      snd_hda_intel
>  46:          0          3          0          0   PCI-MSI-edge      eth0
> NMI:          1          0          0          0   Non-maskable interrupts
> LOC:      16312      15177      10840       8995   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          1          0          0          0   Performance monitoring interrupts
> IWI:       1160        523       1031        481   IRQ work interrupts
> RTR:          3          0          0          0   APIC ICR read retries
> RES:      14976      16135       9973      10784   Rescheduling interrupts
> CAL:        482        457        151        370   Function call interrupts
> TLB:         70        106        352        230   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          2          2          2          2   Machine check polls
> ERR:          0
> MIS:          0
> 
> Good case after:
>            CPU0       CPU1       CPU2       CPU3       
>   0:         17          0          0          0   IO-APIC-edge      timer
>   1:        367          1         81          4   IO-APIC-edge      i8042
>   8:          0          0          1          0   IO-APIC-edge      rtc0
>   9:        478         14        460         71   IO-APIC-fasteoi   acpi
>  12:         10        108        269       2696   IO-APIC-edge      i8042
>  16:         36         10        111          2   IO-APIC-fasteoi   ehci_hcd:usb1
>  17:         20          3         25          4   IO-APIC-fasteoi   mmc0
>  21:          3          0         34          0   IO-APIC-fasteoi   ehci_hcd:usb2
>  40:          0          1         12         11   PCI-MSI-edge      mei_me
>  41:      16888        173       9959        292   PCI-MSI-edge      ahci
>  42:       1102         11        186         26   PCI-MSI-edge      xhci_hcd
>  43:        107        132         27        136   PCI-MSI-edge      i915
>  44:       6943         20        434         22   PCI-MSI-edge      iwlwifi
>  45:        180          0        183         86   PCI-MSI-edge      snd_hda_intel
>  46:          0          3          0          0   PCI-MSI-edge      eth0
> NMI:          4          3          3          3   Non-maskable interrupts
> LOC:      26845      24780      19025      17746   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:          4          3          3          3   Performance monitoring interrupts
> IWI:       1637        751       1287        695   IRQ work interrupts
> RTR:          3          0          0          0   APIC ICR read retries
> RES:      26511      26673      18791      20194   Rescheduling interrupts
> CAL:        510        480        151        370   Function call interrupts
> TLB:        361        292        575        461   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          2          2          2          2   Machine check polls
> ERR:          0
> MIS:          0
> 
> Bad case before:
>            CPU0       CPU1       CPU2       CPU3       
>   0:         17          0          0          0   IO-APIC-edge      timer
>   1:        172          3         78          3   IO-APIC-edge      i8042
>   8:          0          1          0          0   IO-APIC-edge      rtc0
>   9:       1200        148        395         81   IO-APIC-fasteoi   acpi
>  12:       1625          2        348         10   IO-APIC-edge      i8042
>  16:         26         23        115          0   IO-APIC-fasteoi   ehci_hcd:usb1
>  17:         16          3         12         21   IO-APIC-fasteoi   mmc0
>  21:          2          2         33          0   IO-APIC-fasteoi   ehci_hcd:usb2
>  40:          0          0         14         10   PCI-MSI-edge      mei_me
>  41:      15776        374       8497        687   PCI-MSI-edge      ahci
>  42:       1297        829        115         24   PCI-MSI-edge      xhci_hcd
>  43:        103        149          9        212   PCI-MSI-edge      i915
>  44:      13151        101        511         91   PCI-MSI-edge      iwlwifi
>  45:        153        159          0        122   PCI-MSI-edge      snd_hda_intel
>  46:          0          1          1          0   PCI-MSI-edge      eth0
> NMI:         32         31         31         31   Non-maskable interrupts
> LOC:      82504      82732      74172      75985   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:         32         31         31         31   Performance monitoring interrupts
> IWI:      17816      16278      13833      13282   IRQ work interrupts
> RTR:          3          0          0          0   APIC ICR read retries
> RES:      18784      21084      13313      12946   Rescheduling interrupts
> CAL:        393        422        306        356   Function call interrupts
> TLB:        231        176        235        191   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          3          3          3          3   Machine check polls
> ERR:          0
> MIS:          0
> 
> Bad case after:
>            CPU0       CPU1       CPU2       CPU3       
>   0:         17          0          0          0   IO-APIC-edge      timer
>   1:        415          3         85          3   IO-APIC-edge      i8042
>   8:          0          1          0          0   IO-APIC-edge      rtc0
>   9:       1277        148        428         81   IO-APIC-fasteoi   acpi
>  12:       1625          2        348         10   IO-APIC-edge      i8042
>  16:         26         23        115          0   IO-APIC-fasteoi   ehci_hcd:usb1
>  17:         16          3         12         21   IO-APIC-fasteoi   mmc0
>  21:          2          2         33          0   IO-APIC-fasteoi   ehci_hcd:usb2
>  40:          0          0         14         10   PCI-MSI-edge      mei_me
>  41:      17814        374       8497        687   PCI-MSI-edge      ahci
>  42:       1567        829        115         24   PCI-MSI-edge      xhci_hcd
>  43:        103        177          9        242   PCI-MSI-edge      i915
>  44:      14956        101        511         91   PCI-MSI-edge      iwlwifi
>  45:        153        159          0        122   PCI-MSI-edge      snd_hda_intel
>  46:          0          1          1          0   PCI-MSI-edge      eth0
> NMI:         36         35         34         34   Non-maskable interrupts
> LOC:      92429      92708      81714      84071   Local timer interrupts
> SPU:          0          0          0          0   Spurious interrupts
> PMI:         36         35         34         34   Performance monitoring interrupts
> IWI:      22594      19658      17439      14257   IRQ work interrupts
> RTR:          3          0          0          0   APIC ICR read retries
> RES:      21491      24670      14618      14569   Rescheduling interrupts
> CAL:        441        439        306        356   Function call interrupts
> TLB:        232        181        274        465   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> MCE:          0          0          0          0   Machine check exceptions
> MCP:          3          3          3          3   Machine check polls
> ERR:          0
> MIS:          0

Lots more local timer interrupts, which is consistent with the higher
time in interrupt handlers for the bad case.

> > One hypothesis is that your workload and configuration are interacting
> > with RCU_FAST_NO_HZ to force very large numbers of RCU grace periods.
> > Could you please check for this by building with CONFIG_RCU_TRACE=y,
> > mounting debugfs somewhere and dumping rcu/rcu_sched/rcugp before and
> > after each run?
> 
> Good case before:
> completed=8756  gpnum=8757  age=0  max=21
> after:
> completed=14686  gpnum=14687  age=0  max=21
> 
> Bad case before:
> completed=22970  gpnum=22971  age=0  max=21
> after:
> completed=26110  gpnum=26111  age=0  max=21

In the good case, (14686-8756)/40=148.25 grace periods per second, which
is a fast but reasonable rate given your HZ=250.  Not a large difference
in the number of grace periods, but extrapolating for the longer runtime,
maybe ten times as much.  But not much change in grace-period rate per
unit time.

> The test scenario was the following in both cases (mixed english and pseudo-bash):
> reboot, login, start terminal
> cd project
> rm -r build
> cat /proc/interrupts >> somefile ; cat /sys/kernel/debug/rcu/rcu_sched/rcugp >> somefile
> scons -j4
> wait ~40 sec (good case finished, Ctrl-C in bad case)
> cat /proc/interrupts >> somefile ; cat /sys/kernel/debug/rcu/rcu_sched/rcugp >> somefile
> 
> I stopped the build in the bad case after about the same time the good
> case finished, so the extra interrupts and RCU grace periods because of the
> longer runtime don't fake the results.

That procedure works for me, thank you for laying it out carefully.

I believe I see what is going on and how to fix it, though it may take
me a bit to work things through and get a good patch.

Thank you very much for your testing efforts!

							Thanx, Paul

