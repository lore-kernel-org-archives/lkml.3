Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaJIGyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:54:32 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:59821 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbaJIGyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:54:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Thu, 9 Oct 2014 07:53:31 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141009065331.GG12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
 <20141008051059.65566251@as>
 <20141008194955.GF12897@nuc-i3427.alporthouse.com>
 <5435AE71.60304@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5435AE71.60304@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 02:36:49PM -0700, H. Peter Anvin wrote:
> On 10/08/2014 12:49 PM, Chris Wilson wrote:
> > 
> > Indeed, this appears to be the explanation. (And here I thought PAT
> > superseded mtrrs - i915.ko stopped trying to use assign an mtrr for its
> > GTT quite a while ago.)
> > 
> > Replacing the stop_machine there with on_each_cpu does the trick:
> > 
> 
> It should, but there seem to be quite a few drivers which still muck
> with MTRRs.  However, i915 is not one of them, it calls
> io_mapping_create_wc() followed by arch_phys_wc_add(), so I'm wondering
> what the heck is going on here.

This system also have a radeon GPU. Disabling it (not building in the
module) makes no difference to the wc speed.
 
> > Naively I would say that we lost the wc on our ioremap.
> > /sys/kernel/debug/x86/pat_memtype_list remained the same across repeated
> > runs.
> 
> Could you tell me what the above looks like?

# cat /sys/kernel/debug/x86/pat_memtype_list
PAT memtype list:
write-back @ 0x8cf34000-0x8cf43000
write-back @ 0x8cf4d000-0x8cf4e000
write-back @ 0x8cf4d000-0x8cf50000
write-back @ 0x8cf50000-0x8cf51000
write-back @ 0x8cf51000-0x8cf52000
write-back @ 0x8cf52000-0x8cf53000
write-back @ 0x8cf53000-0x8cf55000
write-back @ 0x8cf55000-0x8cf56000
write-back @ 0x8cf9d000-0x8cf9e000
write-back @ 0x8cf9f000-0x8cfa0000
write-back @ 0x8cffc000-0x8cffd000
uncached-minus @ 0x8fc00000-0x8fe00000
write-combining @ 0x8fe00000-0x90000000
uncached-minus @ 0x90220000-0x90240000
uncached-minus @ 0x90300000-0x90320000
uncached-minus @ 0x90340000-0x90341000
uncached-minus @ 0x90380000-0x90381000
write-combining @ 0xa0000000-0xc0000000
write-combining @ 0xa0139000-0xa0159000
write-combining @ 0xa0159000-0xa0179000
write-combining @ 0xa0179000-0xa0199000
write-combining @ 0xc0040000-0xc025e000
write-combining @ 0xc025e000-0xc045e000
write-combining @ 0xc045e000-0xc045f000
write-combining @ 0xc045f000-0xc075f000
uncached-minus @ 0xf8000000-0xfc000000
uncached-minus @ 0xfed00000-0xfed01000
uncached-minus @ 0xfed10000-0xfed16000
uncached-minus @ 0xfed1f000-0xfed20000

(identical for good/bad runs)

# cat /proc/mtrr 
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size=  256MB, count=1: write-back
reg02: base=0x08e000000 ( 2272MB), size=   32MB, count=1: uncachable
reg03: base=0x08d000000 ( 2256MB), size=   16MB, count=1: uncachable
reg04: base=0x100000000 ( 4096MB), size= 2048MB, count=1: write-back
reg05: base=0x170000000 ( 5888MB), size=  256MB, count=1: uncachable
reg06: base=0x16f000000 ( 5872MB), size=   16MB, count=1: uncachable
reg07: base=0x16e800000 ( 5864MB), size=    8MB, count=1: uncachable
reg08: base=0x16e600000 ( 5862MB), size=    2MB, count=1: uncachable

# cat /proc/iomem:
00000000-00000fff : reserved
00001000-0009bbff : System RAM
0009bc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cdfff : Video ROM
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000e0000-000e3fff : PCI Bus 0000:00
  000e4000-000e7fff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  01000000-0161981b : Kernel code
  0161981c-01ca20ff : Kernel data
  01dac000-01e2dfff : Kernel bss
20000000-201fffff : reserved
  20000000-201fffff : pnp 00:05
20200000-3fffffff : System RAM
40000000-401fffff : reserved
  40000000-401fffff : pnp 00:05
40200000-8ccd2fff : System RAM
8ccd3000-8cd66fff : reserved
8cd67000-8cfe6fff : ACPI Non-volatile Storage
8cfe7000-8cffefff : ACPI Tables
8cfff000-8cffffff : System RAM
8d000000-8f9fffff : reserved
  8da00000-8f9fffff : Graphics Stolen Memory
8fa00000-feafffff : PCI Bus 0000:00
  8fa00000-8fa00fff : pnp 00:03
  8fc00000-8fffffff : 0000:00:02.0
  90000000-900fffff : PCI Bus 0000:04
    90000000-900fffff : PCI Bus 0000:05
      90000000-90003fff : 0000:05:00.0
      90010000-900107ff : 0000:05:00.0
  90100000-901fffff : PCI Bus 0000:03
    90100000-90101fff : 0000:03:00.0
  90200000-902fffff : PCI Bus 0000:01
    90200000-9021ffff : 0000:01:00.0
    90220000-9023ffff : 0000:01:00.0
    90240000-90243fff : 0000:01:00.1
  90300000-9031ffff : 0000:00:19.0
    90300000-9031ffff : e1000e
  90330000-903300ff : 0000:00:1f.3
  90340000-903407ff : 0000:00:1f.2
    90340000-903407ff : ahci
  90350000-903503ff : 0000:00:1d.0
  90360000-90363fff : 0000:00:1b.0
  90370000-903703ff : 0000:00:1a.0
  90380000-90380fff : 0000:00:19.0
    90380000-90380fff : e1000e
  90390000-90390fff : 0000:00:16.3
  903a0000-903a000f : 0000:00:16.0
  a0000000-bfffffff : 0000:00:02.0
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:03
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : PNP0103:00
fed10000-fed13fff : reserved
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:03
  fed19000-fed19fff : pnp 00:03
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:03
fed20000-fed3ffff : pnp 00:03
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:03
fed90000-fed93fff : pnp 00:03
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : INT0800:00
  ff980000-ffbfffff : reserved
  ffd80000-ffffffff : reserved
100000000-16e5fffff : System RAM
16e600000-16fffffff : RAM buffer

# lspci -vv -s 0:0:2
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 2210
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        Region 0: Memory at 8fc00000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at a0000000 (64-bit, prefetchable) [size=512M]
        Region 4: I/O ports at 3000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0f00c  Data: 41b1
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915

-- 
Chris Wilson, Intel Open Source Technology Centre
