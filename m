Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab3GZM2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:28:05 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47214 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GZM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130725211521.GE18254@gmail.com>
References: <9E84D12D-7389-4D9A-803A-91FD704A92FA@gustavus.edu>
 <20130725112123.GT27075@twins.programming.kicks-ass.net> <228E8D34-E1A9-4D82-B353-F095E473B8D7@gustavus.edu>
 <20130725164051.GZ27075@twins.programming.kicks-ass.net> <20130725211521.GE18254@gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 26 Jul 2013 05:27:27 -0700
Message-ID: <CAPM31RJNgDS+gCZobJCt138J6MfbYhwTuTH8MrhP7DEqHGqi5g@mail.gmail.com>
Subject: PROBLEM: Persistent unfair sharing of a processor by auto groups in
 3.11-rc2 (has twice regressed)
To: Max Hailperin <max@gustavus.edu>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Moving to LKML]

Max sent in the following (best ever) bug report:

On Wed, Jul 24, 2013 at 8:41 AM, Max Hailperin <max@gustavus.edu> wrote:
> [1.] One line summary of the problem:
> Persistent unfair sharing of a processor by auto groups in 3.11-rc2 (has
> twice regressed)
>
> [2.] Full description of the problem/report:
> Although I've used bisection to figure out where this problem originated and
> have a one-line patch that fixes it, I don't understand the root cause and
> don't have any reason to think my patch is the right one.
>
> If I run a single processor-hogging loop in each of two terminal windows (so
> one task in each of two auto groups) and use schedtool to pin each of them
> on processor 0, they ought to each get 50% of that processor's time.
> However, a substantial fraction of my trials of this experiment (detailed in
> section 7 below) produce a different result: the two tasks get persistently
> stuck in some ratio other than 50/50.  In the screenshot I have attached,
> they are running 55/45, but I have observed as extreme as 66/33. Whatever
> the ratio is, it remains fixed aside from minor fluctuations for as long as
> I let it run, which has been over an hour.  This phenomenon doesn't show up
> if I boot with nosmp rather than using schedtool or if I disable auto
> grouping.  The tasks really are getting disproportionate CPU rather than
> just looking that way due to some accounting malfunction; I've confirmed
> this by having each produce output every N iterations so that I can see they
> are running at different rates.
>
> Bisection reveals that this problem most recently was introduced by commit
> 17bc14b767cf0692420c43dbe5310ae98a5a7836 which reverted commit
> f269ae0469fc882332bdfb5db15d3c1315fe2a10 (sched: Update_cfs_shares at period
> edge). In between these two commits, I consistently get 50/50 sharing aside
> from  small fluctuations.
>
> As suggested by the problem having been (re-) introduced by a revert, it was
> also present as of the parent commit of the reverted commit (that is, as of
> 48a1675323fa1b7844e479ad2a4469f4558c0f79).  A second round of bisection
> looking backward from there identifies the problem as having initially been
> introduced in commit 82958366cfea1a50e7e90907b2d55ae29ed69974 (sched:
> Replace update_shares weight distribution with per-entity computation).
>
> I was able to make the problem go away by applying to 3.11-rc2 the one-line
> patch I have attached, which is a subset of the reverted commit.
>
> [3.] Keywords (i.e., modules, networking, kernel):
> sched
>
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> Linux version 3.11.0-rc2 (max@max-st1-Inspiron-5423) (gcc version 4.7.3
> (Ubuntu/Linaro 4.7.3-1ubuntu1) ) #1 SMP Tue Jul 23 13:09:32 CDT 2013
>
> [4.2.] Kernel .config file:
> See the attached config file.
>
> [5.] Most recent kernel version which did not have the bug:
> See bisection information above.
>
> [6.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> N/A
>
> [7.] A small shell script or example program which triggers the
>      problem (if possible)
> In each of two terminal windows give the command
>   schedtool -a 0 -e bash -c 'while ((1)); do :; done'
> while in a third terminal window running top to observe the result. See the
> attached screenshot for an example.  The results are not consistent, but in
> the buggy versions of the kernel, many of the attempts will show the tasks
> running in a non-50/50 ratio (persistently). It's never taken me more than a
> handful of tries to see the effect. Also, in the cases where the tasks are
> running in more or less 50/50, if I stop one with control-z and then restart
> it, sometimes that is enough to switch to disproportionate execution.
>
> [8.] Environment
> [8.1.] Software (add the output of the ver_linux script here)
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux max-st1-Inspiron-5423 3.11.0-rc2 #1 SMP Tue Jul 23 13:09:32 CDT 2013
> x86_64 x86_64 x86_64 GNU/Linux
>
> Gnu C                  4.7
> Gnu make               3.81
> binutils               2.23.2
> util-linux             2.20.1
> mount                  support
> module-init-tools      9
> e2fsprogs              1.42.5
> pcmciautils            018
> PPP                    2.4.5
> Linux C Library        2.17
> Dynamic linker (ldd)   2.17
> Procps                 3.3.3
> Net-tools              1.60
> Kbd                    1.15.5
> Sh-utils               8.20
> wireless-tools         30
> Modules Loaded         rfcomm parport_pc bnep ppdev arc4 iwldvm mac80211
> i915 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec
> iwlwifi drm_kms_helper drm uvcvideo btusb videobuf2_vmalloc videobuf2_memops
> snd_hwdep videobuf2_core bluetooth snd_pcm videodev joydev snd_page_alloc
> snd_seq_midi cfg80211 snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device
> snd_timer mei_me lp i2c_algo_bit psmouse snd mei video rts5139 dell_laptop
> dcdbas dell_wmi lpc_ich parport sparse_keymap mac_hid serio_raw soundcore
> wmi ahci libahci alx mdio
>
> [8.2.] Processor information (from /proc/cpuinfo):
> processor : 0
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i3-3217U CPU @ 1.80GHz
> stepping : 9
> microcode : 0x15
> cpu MHz : 864.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 0
> initial apicid : 0
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
> aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx
> f16c lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi
> flexpriority ept vpid fsgsbase smep erms
> bogomips : 3591.91
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 1
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i3-3217U CPU @ 1.80GHz
> stepping : 9
> microcode : 0x15
> cpu MHz : 990.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 1
> cpu cores : 2
> apicid : 2
> initial apicid : 2
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
> aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx
> f16c lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi
> flexpriority ept vpid fsgsbase smep erms
> bogomips : 3591.91
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 2
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i3-3217U CPU @ 1.80GHz
> stepping : 9
> microcode : 0x15
> cpu MHz : 792.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 1
> initial apicid : 1
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
> aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx
> f16c lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi
> flexpriority ept vpid fsgsbase smep erms
> bogomips : 3591.91
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> processor : 3
> vendor_id : GenuineIntel
> cpu family : 6
> model : 58
> model name : Intel(R) Core(TM) i3-3217U CPU @ 1.80GHz
> stepping : 9
> microcode : 0x15
> cpu MHz : 1116.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 1
> cpu cores : 2
> apicid : 3
> initial apicid : 3
> fpu : yes
> fpu_exception : yes
> cpuid level : 13
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
> aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx
> f16c lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi
> flexpriority ept vpid fsgsbase smep erms
> bogomips : 3591.91
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
>
> [8.3.] Module information (from /proc/modules):
> rfcomm 42539 12 - Live 0x0000000000000000
> parport_pc 32688 0 - Live 0x0000000000000000
> bnep 18036 2 - Live 0x0000000000000000
> ppdev 12934 0 - Live 0x0000000000000000
> arc4 12615 2 - Live 0x0000000000000000
> iwldvm 241420 0 - Live 0x0000000000000000
> mac80211 601324 1 iwldvm, Live 0x0000000000000000
> i915 659650 3 - Live 0x0000000000000000
> snd_hda_codec_hdmi 41176 1 - Live 0x0000000000000000
> snd_hda_codec_idt 50389 1 - Live 0x0000000000000000
> snd_hda_intel 47930 3 - Live 0x0000000000000000
> snd_hda_codec 188542 3 snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,
> Live 0x0000000000000000
> iwlwifi 166005 1 iwldvm, Live 0x0000000000000000
> drm_kms_helper 52880 1 i915, Live 0x0000000000000000
> drm 292458 4 i915,drm_kms_helper, Live 0x0000000000000000
> uvcvideo 80784 0 - Live 0x0000000000000000
> btusb 22517 0 - Live 0x0000000000000000
> videobuf2_vmalloc 13056 1 uvcvideo, Live 0x0000000000000000
> videobuf2_memops 13202 1 videobuf2_vmalloc, Live 0x0000000000000000
> snd_hwdep 13602 1 snd_hda_codec, Live 0x0000000000000000
> videobuf2_core 40513 1 uvcvideo, Live 0x0000000000000000
> bluetooth 234284 22 rfcomm,bnep,btusb, Live 0x0000000000000000
> snd_pcm 101975 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
> 0x0000000000000000
> videodev 133456 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
> joydev 17377 0 - Live 0x0000000000000000
> snd_page_alloc 18710 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
> snd_seq_midi 13324 0 - Live 0x0000000000000000
> cfg80211 488276 3 iwldvm,mac80211,iwlwifi, Live 0x0000000000000000
> snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
> snd_rawmidi 30180 1 snd_seq_midi, Live 0x0000000000000000
> snd_seq 65684 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
> snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
> 0x0000000000000000
> snd_timer 29370 2 snd_pcm,snd_seq, Live 0x0000000000000000
> mei_me 13684 0 - Live 0x0000000000000000
> lp 17759 0 - Live 0x0000000000000000
> i2c_algo_bit 13413 1 i915, Live 0x0000000000000000
> psmouse 95952 0 - Live 0x0000000000000000
> snd 69134 17
> snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
> Live 0x0000000000000000
> mei 54059 1 mei_me, Live 0x0000000000000000
> video 19327 1 i915, Live 0x0000000000000000
> rts5139 315256 0 - Live 0x0000000000000000 (C)
> dell_laptop 17369 0 - Live 0x0000000000000000
> dcdbas 14397 1 dell_laptop, Live 0x0000000000000000
> dell_wmi 12681 0 - Live 0x0000000000000000
> lpc_ich 21080 0 - Live 0x0000000000000000
> parport 42214 3 parport_pc,ppdev,lp, Live 0x0000000000000000
> sparse_keymap 13890 1 dell_wmi, Live 0x0000000000000000
> mac_hid 13205 0 - Live 0x0000000000000000
> serio_raw 13253 0 - Live 0x0000000000000000
> soundcore 12680 1 snd, Live 0x0000000000000000
> wmi 19070 1 dell_wmi, Live 0x0000000000000000
> ahci 29915 2 - Live 0x0000000000000000
> libahci 31885 1 ahci, Live 0x0000000000000000
> alx 32175 0 - Live 0x0000000000000000
> mdio 13807 1 alx, Live 0x0000000000000000
>
> [8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0064-0064 : keyboard
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>   0400-0403 : ACPI PM1a_EVT_BLK
>   0404-0405 : ACPI PM1a_CNT_BLK
>   0408-040b : ACPI PM_TMR
>   0410-0415 : ACPI CPU throttle
>   0420-042f : ACPI GPE0_BLK
>   0430-0433 : iTCO_wdt
>   0450-0450 : ACPI PM2_CNT_BLK
>   0454-0457 : pnp 00:05
>   0458-047f : pnp 00:03
>     0460-047f : iTCO_wdt
>   04d0-04d1 : pnp 00:07
>   0500-057f : pnp 00:03
>   0680-069f : pnp 00:03
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   1000-100f : pnp 00:03
>   164e-164f : pnp 00:03
>   e000-efff : PCI Bus 0000:09
>     e000-e07f : 0000:09:00.0
>   f000-f03f : 0000:00:02.0
>   f040-f05f : 0000:00:1f.3
>   f060-f07f : 0000:00:1f.2
>     f060-f07f : ahci
>   f080-f083 : 0000:00:1f.2
>     f080-f083 : ahci
>   f090-f097 : 0000:00:1f.2
>     f090-f097 : ahci
>   f0a0-f0a3 : 0000:00:1f.2
>     f0a0-f0a3 : ahci
>   f0b0-f0b7 : 0000:00:1f.2
>     f0b0-f0b7 : ahci
>   ffff-ffff : pnp 00:03
>     ffff-ffff : pnp 00:03
>
> 00000000-00000fff : reserved
> 00001000-000917ff : System RAM
> 00091800-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
> 000c0000-000cedff : Video ROM
> 000cf000-000d97ff : Adapter ROM
> 000d9800-000da7ff : Adapter ROM
> 000dc000-000dffff : PCI Bus 0000:00
> 000e0000-000fffff : reserved
>   000e0000-000e3fff : PCI Bus 0000:00
>   000e4000-000e7fff : PCI Bus 0000:00
>   000f0000-000fffff : System ROM
> 00100000-1fffffff : System RAM
>   01000000-016fae8a : Kernel code
>   016fae8b-01d008bf : Kernel data
>   01e5a000-01fccfff : Kernel bss
> 20000000-201fffff : reserved
>   20000000-201fffff : pnp 00:0b
> 20200000-40003fff : System RAM
> 40004000-40004fff : reserved
>   40004000-40004fff : pnp 00:0b
> 40005000-d82c7fff : System RAM
> d82c8000-d8d1cfff : reserved
> d8d1d000-d8d2dfff : ACPI Tables
> d8d2e000-d9bb7fff : ACPI Non-volatile Storage
> d9bb8000-da582fff : reserved
> da583000-da583fff : System RAM
> da584000-da5c6fff : ACPI Non-volatile Storage
> da5c7000-da9d7fff : System RAM
> da9d8000-daff3fff : reserved
> daff4000-daffffff : System RAM
> db000000-db7fffff : RAM buffer
> db800000-df9fffff : reserved
> dfa00000-feafffff : PCI Bus 0000:00
>   dfa00000-dfa00fff : pnp 00:0a
>   e0000000-efffffff : 0000:00:02.0
>   f7800000-f7bfffff : 0000:00:02.0
>   f7c00000-f7cfffff : PCI Bus 0000:09
>     f7c00000-f7c3ffff : 0000:09:00.0
>       f7c00000-f7c3ffff : alx
>   f7d00000-f7dfffff : PCI Bus 0000:07
>     f7d00000-f7d01fff : 0000:07:00.0
>       f7d00000-f7d01fff : iwlwifi
>   f7e00000-f7e0ffff : 0000:00:14.0
>     f7e00000-f7e0ffff : xhci_hcd
>   f7e10000-f7e13fff : 0000:00:1b.0
>     f7e10000-f7e13fff : ICH HD audio
>   f7e15000-f7e150ff : 0000:00:1f.3
>   f7e16000-f7e167ff : 0000:00:1f.2
>     f7e16000-f7e167ff : ahci
>   f7e17000-f7e173ff : 0000:00:1d.0
>     f7e17000-f7e173ff : ehci_hcd
>   f7e18000-f7e183ff : 0000:00:1a.0
>     f7e18000-f7e183ff : ehci_hcd
>   f7e1b000-f7e1b00f : 0000:00:16.0
>     f7e1b000-f7e1b00f : mei_me
>   f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
>     f8000000-fbffffff : reserved
>       f8000000-fbffffff : pnp 00:0a
>   fe800000-fe802fff : pnp 00:07
> fec00000-fec00fff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed03fff : reserved
>   fed00000-fed003ff : HPET 0
> fed10000-fed17fff : pnp 00:0a
> fed18000-fed18fff : pnp 00:0a
> fed19000-fed19fff : pnp 00:0a
> fed1c000-fed1ffff : reserved
>   fed1c000-fed1ffff : pnp 00:0a
>     fed1f410-fed1f414 : iTCO_wdt
> fed20000-fed3ffff : pnp 00:0a
> fed45000-fed8ffff : pnp 00:0a
> fed90000-fed93fff : pnp 00:0a
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ff000000-ffffffff : reserved
>   ff000000-ffffffff : pnp 00:0a
> 100000000-11f5fffff : System RAM
> 11f600000-11fffffff : RAM buffer
>
> [8.5.] PCI information ('lspci -vvv' as root)
> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
> Controller (rev 09)
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor
> Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> Subsystem: Dell Device 057e
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 45
> Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
> Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
> Region 4: I/O ports at f000 [size=64]
> Expansion ROM at <unassigned> [disabled]
> Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee0f00c  Data: 41e1
> Capabilities: [d0] Power Management version 2
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a4] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: i915
>
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 40
> Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=64K]
> Capabilities: [70] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 4181
> Kernel driver in use: xhci_hcd
>
> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series
> Chipset Family MEI Controller #1 (rev 04)
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 42
> Region 0: Memory at f7e1b000 (64-bit, non-prefetchable) [size=16]
> Capabilities: [50] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41a1
> Kernel driver in use: mei_me
>
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at f7e18000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
>
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family
> High Definition Audio Controller (rev 04)
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 44
> Region 0: Memory at f7e10000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0f00c  Data: 41d1
> Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> ExtTag- RBE- FLReset+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1
> <1us
> ClockPM- Surprise- LLActRep- BwNot-
> LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt-
> ABWMgmt-
> Capabilities: [100 v1] Virtual Channel
> Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
> Arb: Fixed- WRR32- WRR64- WRR128-
> Ctrl: ArbSelect=Fixed
> Status: InProgress-
> VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> Status: NegoPending- InProgress-
> VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
> Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22
> Status: NegoPending- InProgress-
> Capabilities: [130 v1] Root Complex Link
> Desc: PortNumber=0f ComponentID=00 EltType=Config
> Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped
> LinkValid+
> Addr: 00000000fed1c000
> Kernel driver in use: snd_hda_intel
>
> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family
> PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
> I/O behind bridge: 0000f000-00000fff
> Memory behind bridge: fff00000-000fffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> ExtTag- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1
> <16us
> ClockPM- Surprise- LLActRep+ BwNot-
> LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
> LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Dell Device 057e
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
>
> 00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family
> PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
> I/O behind bridge: 0000f000-00000fff
> Memory behind bridge: f7d00000-f7dfffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> ExtTag- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1
> <16us
> ClockPM- Surprise- LLActRep+ BwNot-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+
> ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
> LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Dell Device 057e
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
>
> 00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family
> PCI Express Root Port 6 (rev c4) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
> I/O behind bridge: 0000e000-0000efff
> Memory behind bridge: f7c00000-f7cfffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
> ExtTag- RBE+ FLReset-
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1
> <16us
> ClockPM- Surprise- LLActRep+ BwNot-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+
> ABWMgmt-
> SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
> SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> Changed: MRL- PresDet- LinkState-
> RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
> RootCap: CRSVisible-
> RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
> DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
> LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable
> De-emphasis: -6dB
> Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
> ComplianceSOS-
> Compliance De-emphasis: -6dB
> LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
> EqualizationPhase1-
> EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
> Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
> Address: 00000000  Data: 0000
> Capabilities: [90] Subsystem: Dell Device 057e
> Capabilities: [a0] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Kernel driver in use: pcieport
>
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
> Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
> Subsystem: Dell Device 057e
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at f7e17000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: [50] Power Management version 2
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Debug port: BAR=1 offset=00a0
> Capabilities: [98] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ehci-pci
>
> 00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller
> (rev 04)
> Subsystem: Dell Device 057e
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: [e0] Vendor Specific Information: Len=0c <?>
> Kernel driver in use: lpc_ich
>
> 00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller
> [RAID mode] (rev 04)
> Subsystem: Dell Device 057e
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin B routed to IRQ 41
> Region 0: I/O ports at f0b0 [size=8]
> Region 1: I/O ports at f0a0 [size=4]
> Region 2: I/O ports at f090 [size=8]
> Region 3: I/O ports at f080 [size=4]
> Region 4: I/O ports at f060 [size=32]
> Region 5: Memory at f7e16000 (32-bit, non-prefetchable) [size=2K]
> Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> Address: fee0500c  Data: 4191
> Capabilities: [70] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> Capabilities: [b0] PCI Advanced Features
> AFCap: TP+ FLR+
> AFCtrl: FLR-
> AFStatus: TP-
> Kernel driver in use: ahci
>
> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus
> Controller (rev 04)
> Subsystem: Dell Device 057e
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin C routed to IRQ 11
> Region 0: Memory at f7e15000 (64-bit, non-prefetchable) [size=256]
> Region 4: I/O ports at f040 [size=32]
>
> 07:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev
> c4)
> Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 43
> Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=8K]
> Capabilities: [c8] Power Management version 3
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> Address: 00000000fee0400c  Data: 41b1
> Capabilities: [e0] Express (v1) Endpoint, MSI 00
> DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
> ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
> DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
> MaxPayload 128 bytes, MaxReadReq 128 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1
> <32us
> ClockPM+ Surprise- LLActRep- BwNot-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
> ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
> ECRC- UnsupReq- ACSViol-
> UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
> ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
> Capabilities: [140 v1] Device Serial Number 60-36-dd-ff-ff-32-f8-6b
> Kernel driver in use: iwlwifi
>
> 09:00.0 Ethernet controller: Qualcomm Atheros AR8162 Fast Ethernet (rev 10)
> Subsystem: Dell Device 057e
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 46
> Region 0: Memory at f7c00000 (64-bit, non-prefetchable) [size=256K]
> Region 2: I/O ports at e000 [size=128]
> Capabilities: [40] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> Capabilities: [58] Express (v1) Endpoint, MSI 00
> DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s unlimited, L1
> unlimited
> ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
> DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> MaxPayload 128 bytes, MaxReadReq 512 bytes
> DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
> LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited,
> L1 unlimited
> ClockPM+ Surprise- LLActRep- BwNot-
> LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
> ABWMgmt-
> Capabilities: [c0] MSI: Enable+ Count=1/16 Maskable+ 64bit+
> Address: 00000000fee0f00c  Data: 4122
> Masking: 0000fffe  Pending: 00000000
> Capabilities: [d8] MSI-X: Enable- Count=16 Masked-
> Vector table: BAR=0 offset=00002000
> PBA: BAR=0 offset=00003000
> Capabilities: [100 v1] Advanced Error Reporting
> UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
> ECRC- UnsupReq- ACSViol-
> UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
> ECRC- UnsupReq- ACSViol-
> UESvrt: DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
> ECRC- UnsupReq- ACSViol-
> CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
> AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
> Capabilities: [180 v1] Device Serial Number ff-ba-e6-31-78-45-c4-ff
> Kernel driver in use: alx
>
> [8.6.] SCSI information (from /proc/scsi/scsi)
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST500LT012-9WS14 Rev: 0001
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: Micron C400 Real Rev: 01MG
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>   Vendor: HL-DT-ST Model: DVD+-RW GU70N    Rev: A102
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: Generic- Model: xD/SD/M.S.       Rev: 1.00
>   Type:   Direct-Access                    ANSI  SCSI revision: 02
>
> [8.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> N/A
>
> [X.] Other notes, patches, fixes, workarounds:
>
> The following one-line patch to 3.11-rc2 seems to make the problem go away:
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bb456f4..b2e659c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1531,6 +1531,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq
> *cfs_rq, int force_update)
>   }
>
>   __update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
> + update_cfs_shares(cfs_rq);
>  }
>
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>
>
>
>
>
>

Peter replied:

> Hi Max,
>
> Thanks for this elaborate bug report; I wish all of them were as
> thorough. However, is there a reason you omitted CC'ing LKML?
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index bb456f4..b2e659c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1531,6 +1531,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
> >       }
> >
> >       __update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
> > +     update_cfs_shares(cfs_rq);
> >  }
> >
> >  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>
> Ah I see what's happening. Currently we only call update_cfs_shares()
> from the enqueue/dequeue paths. However since your tasks never sleep and
> cannot migrate they never pass this code. This in turns means that the
> inter-cgroup relations (the shares) don't get updated.
>
> I think your patch would indeed be a correct minimal fix in that it adds
> a share update to the regular tick path ensuring it gets done even in
> the absence of enqueues/dequeues.
