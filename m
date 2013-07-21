Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3GULwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 07:52:49 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:33404 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3GULwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 07:52:46 -0400
Date: Sun, 21 Jul 2013 13:53:00 +0200
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jacob Shin <jacob.shin@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>
Subject: Re: early microcode on amd is broken when no initramfs provided
Message-ID: <20130721135301.44bed2ac@fem.tu-ilmenau.de>
In-Reply-To: <20130720225911.GC13731@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
	<20130710073049.GA15525@pd.tnic>
	<20130711230525.40bc6491@fem.tu-ilmenau.de>
	<20130716170055.GG4402@pd.tnic>
	<CAPVoSvQuzUQUgRgk6fhsxEhjWS8oPreo00u_urntaCzmERpOtg@mail.gmail.com>
	<20130720225911.GC13731@pd.tnic>
X-Mailer: Claws Mail 3.9.2-dirty (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013 00:59:11 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Jul 20, 2013 at 09:01:33PM +0200, Torsten Kaiser wrote:
> > On Tue, Jul 16, 2013 at 7:00 PM, Borislav Petkov <bp@alien8.de>
> > wrote:
> > > On Thu, Jul 11, 2013 at 11:05:25PM +0200, Johannes Hirte wrote:
> > >> config is attached
> > >
> > > Ok, I can reproduce the hang with your config but even with:
> > >
> > > $ grep MICROCODE .config
> > > # CONFIG_MICROCODE is not set
> > > # CONFIG_MICROCODE_INTEL_EARLY is not set
> > > # CONFIG_MICROCODE_AMD_EARLY is not set
> > >
> > > which means, it cannot be microcode-related.
> > >
> > > And I'd bet if you wait a minute (yep, it should be exactly 60
> > > seconds) the boot would probably continue. And if so, this is
> > > that 60 sec delay where the kernel tries to find firmware.
> > >
> > > Hmm...
> > 
> > I have the same problem: Booting 3.11-rc1 hangs after the line:
> > ACPI: Executed 3 blocks of module-level executable AML code
> > 
> > I bisected it down to the early microcode changes:
> > 757885e94a22bcc82beb9b1445c95218cb20ceab (the new early loading
> > implementation) and 6b3389ac21b5e557b957f1497d0ff22bf733e8c3 (small
> > fixup) completely fail to boot (No output beyond "Booting kernel") ,
> > from 275bbe2e299f1820ec8faa443d689469a9e6ecc5 ("Make
> > find_ucode_in_initrd() __init") I'm seeing this hang.
> > 
> > Just turning CONFIG_MICROCODE_EARLY off solves the problem: The
> > system now sucessfully boots 3.11-rc1.
> 
> Ok, I need to be able to reproduce that first - I wasn't that
> successful with Johannes' setup.

Strange, I've bisected to the same commit with the config I've send you.

> So, can you please send .config and how you're loading your microcode?
> Is it in the initrd or are you doing that later, how? Grub entry
> please.
> 
> Also, is it just plain v3.11-rc1 or with patches ontop?
> 
> Also, /proc/cpuinfo please.
>
> Thanks.

/proc/cpuinfo:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 6
model name      : AMD Athlon(tm) II P320 Dual-Core Processor
stepping        : 3
microcode       : 0x10000b6
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt
nodeid_msr hw_pstate npt lbrv svm_lock nrip_save bogomips        :
4189.33 TLB size        : 1024 4K pages clflush size    : 64
cache_alignment : 64 address sizes   : 48 bits physical, 48 bits
virtual power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 6
model name      : AMD Athlon(tm) II P320 Dual-Core Processor
stepping        : 3
microcode       : 0x10000b6
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt
nodeid_msr hw_pstate npt lbrv svm_lock nrip_save bogomips        :
4189.33 TLB size        : 1024 4K pages clflush size    : 64
cache_alignment : 64 address sizes   : 48 bits physical, 48 bits
virtual power management: ts ttp tm stc 100mhzsteps hwpstate

