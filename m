Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaGVX3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:29:43 -0400
Received: from infernal.debian.net ([176.28.9.132]:33794 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaGVX3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:29:39 -0400
Date: Wed, 23 Jul 2014 01:29:32 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140722232932.GB3791@amos.fritz.box>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140714083527.GA30550@quack.suse.cz>
 <20140716213408.GA8749@amos.fritz.box>
 <20140717083137.GA1649@quack.suse.cz>
 <20140718225005.GA17140@amos.fritz.box>
 <20140721100434.GA26641@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721100434.GA26641@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 12:04:34PM +0200, Jan Kara wrote:
> On Sat 19-07-14 00:50:05, Andreas Bombe wrote:
> > I don't see anything in /sys/kernel/debug/tracing/trace_pipe or
> > .../trace (besides the header) with your patch applied. In case you
> > meant to test it with the problematic printk change, I also tried with
> > the revert reverted. That still hangs as before without any error report
> > to see.
>   Yes, I meant testing my lockdep patch with the problematic printk change.
> Thanks for having a look. I'm puzzled why it didn't help.
> 
> > I checked the kernel logs and there is also no lockdep report anywhere.
> > I get the "trace_printk() being used" notice but nothing else of
> > interest around there. Though the notice should mean trace_printk() was
> > used at least once?
>   Yes. Anyway, I'd be grateful if you could run one more test for me so
> that I can better understand what's going on. Can you take recent vanilla
> kernel (with the revert) and apply attached patch to it? It again enables
> interrupts when calling console_unlock() but keeps lockdep coverage
> unchanged. It helped Sasha so I want to see whether your case is similar or
> different. Thanks!

Applied on top of 15ba2236f, works fine. 

I still don't see what printing could have triggered the problem. The
only thing that is a warning is from the PCI code about some missing
pcie-to-pci bridge (which I really should report some time). That isn't
the culprit however since I tested a build with that WARN_ON_ONCE
removed and it still hung.

Okay, there's ACPI errors, but these seem to be rather late to matter, I
think? Anyway, here's the log of this working boot from the start to
just before initrd gets started:



[    0.000000] CPU0 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc6-00076-g6ffcc42 (andreas@amos) (gcc version 4.9.1 (Debian 4.9.1-1) ) #371 SMP PREEMPT Tue Jul 22 11:14:57 CEST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.16.0-rc6-00076-g6ffcc42 root=/dev/mapper/fastvg-root ro radeon.dpm=1 init=/bin/systemd earlyprintk=vga,keep
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ddeb2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddeb3000-0x00000000de1b5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de1b6000-0x00000000de1b6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000de1b7000-0x00000000de2e0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de2e1000-0x00000000dea2ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dea30000-0x00000000deaaffff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000deab0000-0x00000000deab0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000deab1000-0x00000000deaf3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000deaf4000-0x00000000df47cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df47d000-0x00000000df7d6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df7d7000-0x00000000df7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0xde2c1000  ACPI 2.0=0xde2c1000  SMBIOS=0xf04c0  MPS=0xfd450 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x0000000000058000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x0000000000058000-0x0000000000059000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000059000-0x000000000005f000) (0MB)
[    0.000000] efi: mem04: type=4, attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
[    0.000000] efi: mem05: type=3, attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
[    0.000000] efi: mem06: type=6, attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x0000000001000000-0x0000000003140000) (33MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000003140000-0x000000003743a000) (834MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x000000003743a000-0x0000000037a15000) (5MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x0000000037a15000-0x0000000099812000) (1565MB)
[    0.000000] efi: mem12: type=2, attr=0xf, range=[0x0000000099812000-0x00000000cde7e000) (838MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x00000000cde7e000-0x00000000cde84000) (0MB)
[    0.000000] efi: mem14: type=1, attr=0xf, range=[0x00000000cde84000-0x00000000cdea2000) (0MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x00000000cdea2000-0x00000000d0e68000) (47MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x00000000d0e68000-0x00000000d0e88000) (0MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x00000000d0e88000-0x00000000d0e8c000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000d0e8c000-0x00000000d0e9d000) (0MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x00000000d0e9d000-0x00000000d0ea1000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x00000000d0ea1000-0x00000000d0eb5000) (0MB)
[    0.000000] efi: mem21: type=7, attr=0xf, range=[0x00000000d0eb5000-0x00000000d0eba000) (0MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x00000000d0eba000-0x00000000d0ec3000) (0MB)
[    0.000000] efi: mem23: type=7, attr=0xf, range=[0x00000000d0ec3000-0x00000000d0ec7000) (0MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x00000000d0ec7000-0x00000000d0edd000) (0MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x00000000d0edd000-0x00000000d0ee7000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x00000000d0ee7000-0x00000000d0eee000) (0MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000d0eee000-0x00000000d0ef2000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x00000000d0ef2000-0x00000000d0f03000) (0MB)
[    0.000000] efi: mem29: type=7, attr=0xf, range=[0x00000000d0f03000-0x00000000d0f0d000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x00000000d0f0d000-0x00000000d0f43000) (0MB)
[    0.000000] efi: mem31: type=7, attr=0xf, range=[0x00000000d0f43000-0x00000000d0f87000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x00000000d0f87000-0x00000000d0f9c000) (0MB)
[    0.000000] efi: mem33: type=7, attr=0xf, range=[0x00000000d0f9c000-0x00000000d0fa3000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x00000000d0fa3000-0x00000000d0fa4000) (0MB)
[    0.000000] efi: mem35: type=7, attr=0xf, range=[0x00000000d0fa4000-0x00000000d0fec000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x00000000d0fec000-0x00000000d0fed000) (0MB)
[    0.000000] efi: mem37: type=7, attr=0xf, range=[0x00000000d0fed000-0x00000000d0fef000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x00000000d0fef000-0x00000000d0ff0000) (0MB)
[    0.000000] efi: mem39: type=7, attr=0xf, range=[0x00000000d0ff0000-0x00000000d100d000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x00000000d100d000-0x00000000d1012000) (0MB)
[    0.000000] efi: mem41: type=7, attr=0xf, range=[0x00000000d1012000-0x00000000d1065000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x00000000d1065000-0x00000000d1087000) (0MB)
[    0.000000] efi: mem43: type=7, attr=0xf, range=[0x00000000d1087000-0x00000000d10a7000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x00000000d10a7000-0x00000000d10be000) (0MB)
[    0.000000] efi: mem45: type=7, attr=0xf, range=[0x00000000d10be000-0x00000000d1132000) (0MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x00000000d1132000-0x00000000d1134000) (0MB)
[    0.000000] efi: mem47: type=7, attr=0xf, range=[0x00000000d1134000-0x00000000d1135000) (0MB)
[    0.000000] efi: mem48: type=4, attr=0xf, range=[0x00000000d1135000-0x00000000d1136000) (0MB)
[    0.000000] efi: mem49: type=7, attr=0xf, range=[0x00000000d1136000-0x00000000d115e000) (0MB)
[    0.000000] efi: mem50: type=4, attr=0xf, range=[0x00000000d115e000-0x00000000d11a2000) (0MB)
[    0.000000] efi: mem51: type=7, attr=0xf, range=[0x00000000d11a2000-0x00000000d11a3000) (0MB)
[    0.000000] efi: mem52: type=4, attr=0xf, range=[0x00000000d11a3000-0x00000000d11c4000) (0MB)
[    0.000000] efi: mem53: type=7, attr=0xf, range=[0x00000000d11c4000-0x00000000d11c6000) (0MB)
[    0.000000] efi: mem54: type=4, attr=0xf, range=[0x00000000d11c6000-0x00000000d11e6000) (0MB)
[    0.000000] efi: mem55: type=7, attr=0xf, range=[0x00000000d11e6000-0x00000000d11ea000) (0MB)
[    0.000000] efi: mem56: type=4, attr=0xf, range=[0x00000000d11ea000-0x00000000d11fc000) (0MB)
[    0.000000] efi: mem57: type=7, attr=0xf, range=[0x00000000d11fc000-0x00000000d1200000) (0MB)
[    0.000000] efi: mem58: type=4, attr=0xf, range=[0x00000000d1200000-0x00000000d1211000) (0MB)
[    0.000000] efi: mem59: type=7, attr=0xf, range=[0x00000000d1211000-0x00000000d1216000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x00000000d1216000-0x00000000d1222000) (0MB)
[    0.000000] efi: mem61: type=7, attr=0xf, range=[0x00000000d1222000-0x00000000d1226000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x00000000d1226000-0x00000000d123d000) (0MB)
[    0.000000] efi: mem63: type=7, attr=0xf, range=[0x00000000d123d000-0x00000000d1247000) (0MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x00000000d1247000-0x00000000d124f000) (0MB)
[    0.000000] efi: mem65: type=7, attr=0xf, range=[0x00000000d124f000-0x00000000d1253000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x00000000d1253000-0x00000000d1261000) (0MB)
[    0.000000] efi: mem67: type=7, attr=0xf, range=[0x00000000d1261000-0x00000000d126b000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x00000000d126b000-0x00000000d12a6000) (0MB)
[    0.000000] efi: mem69: type=7, attr=0xf, range=[0x00000000d12a6000-0x00000000d12a8000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x00000000d12a8000-0x00000000d130b000) (0MB)
[    0.000000] efi: mem71: type=7, attr=0xf, range=[0x00000000d130b000-0x00000000d130f000) (0MB)
[    0.000000] efi: mem72: type=4, attr=0xf, range=[0x00000000d130f000-0x00000000d1321000) (0MB)
[    0.000000] efi: mem73: type=7, attr=0xf, range=[0x00000000d1321000-0x00000000d1325000) (0MB)
[    0.000000] efi: mem74: type=4, attr=0xf, range=[0x00000000d1325000-0x00000000d1337000) (0MB)
[    0.000000] efi: mem75: type=7, attr=0xf, range=[0x00000000d1337000-0x00000000d133c000) (0MB)
[    0.000000] efi: mem76: type=4, attr=0xf, range=[0x00000000d133c000-0x00000000d1346000) (0MB)
[    0.000000] efi: mem77: type=7, attr=0xf, range=[0x00000000d1346000-0x00000000d134a000) (0MB)
[    0.000000] efi: mem78: type=4, attr=0xf, range=[0x00000000d134a000-0x00000000d135f000) (0MB)
[    0.000000] efi: mem79: type=7, attr=0xf, range=[0x00000000d135f000-0x00000000d1369000) (0MB)
[    0.000000] efi: mem80: type=4, attr=0xf, range=[0x00000000d1369000-0x00000000d1385000) (0MB)
[    0.000000] efi: mem81: type=7, attr=0xf, range=[0x00000000d1385000-0x00000000d138f000) (0MB)
[    0.000000] efi: mem82: type=4, attr=0xf, range=[0x00000000d138f000-0x00000000d13e8000) (0MB)
[    0.000000] efi: mem83: type=7, attr=0xf, range=[0x00000000d13e8000-0x00000000d13fd000) (0MB)
[    0.000000] efi: mem84: type=4, attr=0xf, range=[0x00000000d13fd000-0x00000000d142d000) (0MB)
[    0.000000] efi: mem85: type=7, attr=0xf, range=[0x00000000d142d000-0x00000000d1431000) (0MB)
[    0.000000] efi: mem86: type=4, attr=0xf, range=[0x00000000d1431000-0x00000000d1443000) (0MB)
[    0.000000] efi: mem87: type=7, attr=0xf, range=[0x00000000d1443000-0x00000000d1447000) (0MB)
[    0.000000] efi: mem88: type=4, attr=0xf, range=[0x00000000d1447000-0x00000000d1459000) (0MB)
[    0.000000] efi: mem89: type=7, attr=0xf, range=[0x00000000d1459000-0x00000000d145e000) (0MB)
[    0.000000] efi: mem90: type=4, attr=0xf, range=[0x00000000d145e000-0x00000000d1468000) (0MB)
[    0.000000] efi: mem91: type=7, attr=0xf, range=[0x00000000d1468000-0x00000000d146c000) (0MB)
[    0.000000] efi: mem92: type=4, attr=0xf, range=[0x00000000d146c000-0x00000000d15a5000) (1MB)
[    0.000000] efi: mem93: type=7, attr=0xf, range=[0x00000000d15a5000-0x00000000d15a7000) (0MB)
[    0.000000] efi: mem94: type=4, attr=0xf, range=[0x00000000d15a7000-0x00000000d161b000) (0MB)
[    0.000000] efi: mem95: type=7, attr=0xf, range=[0x00000000d161b000-0x00000000d161d000) (0MB)
[    0.000000] efi: mem96: type=4, attr=0xf, range=[0x00000000d161d000-0x00000000d1665000) (0MB)
[    0.000000] efi: mem97: type=7, attr=0xf, range=[0x00000000d1665000-0x00000000d1667000) (0MB)
[    0.000000] efi: mem98: type=4, attr=0xf, range=[0x00000000d1667000-0x00000000d16d5000) (0MB)
[    0.000000] efi: mem99: type=7, attr=0xf, range=[0x00000000d16d5000-0x00000000d16d6000) (0MB)
[    0.000000] efi: mem100: type=4, attr=0xf, range=[0x00000000d16d6000-0x00000000d1a9f000) (3MB)
[    0.000000] efi: mem101: type=7, attr=0xf, range=[0x00000000d1a9f000-0x00000000d1aa9000) (0MB)
[    0.000000] efi: mem102: type=4, attr=0xf, range=[0x00000000d1aa9000-0x00000000d1b30000) (0MB)
[    0.000000] efi: mem103: type=7, attr=0xf, range=[0x00000000d1b30000-0x00000000d1b32000) (0MB)
[    0.000000] efi: mem104: type=4, attr=0xf, range=[0x00000000d1b32000-0x00000000db686000) (155MB)
[    0.000000] efi: mem105: type=7, attr=0xf, range=[0x00000000db686000-0x00000000db689000) (0MB)
[    0.000000] efi: mem106: type=4, attr=0xf, range=[0x00000000db689000-0x00000000db740000) (0MB)
[    0.000000] efi: mem107: type=7, attr=0xf, range=[0x00000000db740000-0x00000000db741000) (0MB)
[    0.000000] efi: mem108: type=4, attr=0xf, range=[0x00000000db741000-0x00000000db74c000) (0MB)
[    0.000000] efi: mem109: type=7, attr=0xf, range=[0x00000000db74c000-0x00000000db74d000) (0MB)
[    0.000000] efi: mem110: type=4, attr=0xf, range=[0x00000000db74d000-0x00000000dd156000) (26MB)
[    0.000000] efi: mem111: type=7, attr=0xf, range=[0x00000000dd156000-0x00000000ddc3a000) (10MB)
[    0.000000] efi: mem112: type=2, attr=0xf, range=[0x00000000ddc3a000-0x00000000ddc46000) (0MB)
[    0.000000] efi: mem113: type=3, attr=0xf, range=[0x00000000ddc46000-0x00000000ddeb3000) (2MB)
[    0.000000] efi: mem114: type=0, attr=0xf, range=[0x00000000ddeb3000-0x00000000ddf4d000) (0MB)
[    0.000000] efi: mem115: type=0, attr=0xf, range=[0x00000000ddf4d000-0x00000000de1b6000) (2MB)
[    0.000000] efi: mem116: type=9, attr=0xf, range=[0x00000000de1b6000-0x00000000de1b7000) (0MB)
[    0.000000] efi: mem117: type=10, attr=0xf, range=[0x00000000de1b7000-0x00000000de22f000) (0MB)
[    0.000000] efi: mem118: type=10, attr=0xf, range=[0x00000000de22f000-0x00000000de2d3000) (0MB)
[    0.000000] efi: mem119: type=10, attr=0xf, range=[0x00000000de2d3000-0x00000000de2d9000) (0MB)
[    0.000000] efi: mem120: type=10, attr=0xf, range=[0x00000000de2d9000-0x00000000de2e1000) (0MB)
[    0.000000] efi: mem121: type=6, attr=0x800000000000000f, range=[0x00000000de2e1000-0x00000000de7ae000) (4MB)
[    0.000000] efi: mem122: type=6, attr=0x800000000000000f, range=[0x00000000de7ae000-0x00000000de97f000) (1MB)
[    0.000000] efi: mem123: type=6, attr=0x800000000000000f, range=[0x00000000de97f000-0x00000000de981000) (0MB)
[    0.000000] efi: mem124: type=6, attr=0x800000000000000f, range=[0x00000000de981000-0x00000000de990000) (0MB)
[    0.000000] efi: mem125: type=6, attr=0x800000000000000f, range=[0x00000000de990000-0x00000000de992000) (0MB)
[    0.000000] efi: mem126: type=6, attr=0x800000000000000f, range=[0x00000000de992000-0x00000000dea30000) (0MB)
[    0.000000] efi: mem127: type=5, attr=0x800000000000000f, range=[0x00000000dea30000-0x00000000dea49000) (0MB)
[    0.000000] efi: mem128: type=5, attr=0x800000000000000f, range=[0x00000000dea49000-0x00000000deab0000) (0MB)
[    0.000000] efi: mem129: type=4, attr=0xf, range=[0x00000000deab0000-0x00000000deab1000) (0MB)
[    0.000000] efi: mem130: type=10, attr=0xf, range=[0x00000000deab1000-0x00000000deaf4000) (0MB)
[    0.000000] efi: mem131: type=4, attr=0xf, range=[0x00000000deaf4000-0x00000000dec67000) (1MB)
[    0.000000] efi: mem132: type=3, attr=0xf, range=[0x00000000dec67000-0x00000000df44e000) (7MB)
[    0.000000] efi: mem133: type=4, attr=0xf, range=[0x00000000df44e000-0x00000000df451000) (0MB)
[    0.000000] efi: mem134: type=3, attr=0xf, range=[0x00000000df451000-0x00000000df453000) (0MB)
[    0.000000] efi: mem135: type=4, attr=0xf, range=[0x00000000df453000-0x00000000df460000) (0MB)
[    0.000000] efi: mem136: type=3, attr=0xf, range=[0x00000000df460000-0x00000000df472000) (0MB)
[    0.000000] efi: mem137: type=4, attr=0xf, range=[0x00000000df472000-0x00000000df473000) (0MB)
[    0.000000] efi: mem138: type=3, attr=0xf, range=[0x00000000df473000-0x00000000df475000) (0MB)
[    0.000000] efi: mem139: type=4, attr=0xf, range=[0x00000000df475000-0x00000000df47d000) (0MB)
[    0.000000] efi: mem140: type=6, attr=0x800000000000000f, range=[0x00000000df47d000-0x00000000df7d7000) (3MB)
[    0.000000] efi: mem141: type=4, attr=0xf, range=[0x00000000df7d7000-0x00000000df800000) (0MB)
[    0.000000] efi: mem142: type=7, attr=0xf, range=[0x0000000100000000-0x000000041f000000) (12784MB)
[    0.000000] efi: mem143: type=11, attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem144: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem145: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem146: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem147: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem148: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F17 08/22/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FF0000000 write-back
[    0.000000]   2 base 410000000 mask FF8000000 write-back
[    0.000000]   3 base 418000000 mask FFC000000 write-back
[    0.000000]   4 base 41C000000 mask FFE000000 write-back
[    0.000000]   5 base 41E000000 mask FFF000000 write-back
[    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0301b000, 0x0301bfff] PGTABLE
[    0.000000] BRK [0x0301c000, 0x0301cfff] PGTABLE
[    0.000000] BRK [0x0301d000, 0x0301dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41ee00000-0x41effffff]
[    0.000000]  [mem 0x41ee00000-0x41effffff] page 2M
[    0.000000] BRK [0x0301e000, 0x0301efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41edfffff]
[    0.000000]  [mem 0x41c000000-0x41edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xddeb2fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdddfffff] page 2M
[    0.000000]  [mem 0xdde00000-0xddeb2fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdeab0000-0xdeab0fff]
[    0.000000]  [mem 0xdeab0000-0xdeab0fff] page 4k
[    0.000000] BRK [0x0301f000, 0x0301ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdeaf4000-0xdf47cfff]
[    0.000000]  [mem 0xdeaf4000-0xdebfffff] page 4k
[    0.000000]  [mem 0xdec00000-0xdf3fffff] page 2M
[    0.000000]  [mem 0xdf400000-0xdf47cfff] page 4k
[    0.000000] BRK [0x03020000, 0x03020fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdf7d7000-0xdf7fffff]
[    0.000000]  [mem 0xdf7d7000-0xdf7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3743a000-0x37a14fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DE2C1000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DE2C1070 000064 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DE2CB900 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DE2C1170 00A789 (v02 ALASKA A M I    00000012 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DE2DFF80 000040
[    0.000000] ACPI: APIC 0x00000000DE2CB9F8 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000DE2CBA90 00003C (v01                 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DE2CBAD0 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DE2CBB08 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DE2CBE78 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DE2CC828 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: DMAR 0x00000000DE2CD2C0 000080 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41effffff]
[    0.000000]   NODE_DATA [mem 0x41efea000-0x41efeefff]
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040e600000-ffff88041e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xddeb2fff]
[    0.000000]   node   0: [mem 0xdeab0000-0xdeab0fff]
[    0.000000]   node   0: [mem 0xdeaf4000-0xdf47cfff]
[    0.000000]   node   0: [mem 0xdf7d7000-0xdf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x41effffff]
[    0.000000] On node 0 totalpages: 4184068
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 27 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14178 pages used for memmap
[    0.000000]   DMA32 zone: 907366 pages, LIFO batch:31
[    0.000000]   Normal zone: 51136 pages used for memmap
[    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xddeb3000-0xde1b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde1b6000-0xde1b6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde1b7000-0xde2e0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde2e1000-0xdea2ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdea30000-0xdeaaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdeab1000-0xdeaf3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf47d000-0xdf7d6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf800000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf800000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88041ec00000 s85056 r8192 d21440 u262144
[    0.000000] pcpu-alloc: s85056 r8192 d21440 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4118663
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.0-rc6-00076-g6ffcc42 root=/dev/mapper/fastvg-root ro radeon.dpm=1 init=/bin/systemd earlyprintk=vga,keep
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 16158068K/16736272K available (8028K kernel code, 1485K rwdata, 4632K rodata, 1308K init, 15716K bss, 578204K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3403.629 MHz processor
[    0.000031] Calibrating delay loop (skipped), value calculated using timer frequency.. 6807.25 BogoMIPS (lpj=3403629)
[    0.000038] pid_max: default: 32768 minimum: 301
[    0.000047] ACPI: Core revision 20140424
[    0.011699] ACPI: All ACPI Tables successfully acquired
[    0.019766] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.023334] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.024657] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.024693] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.025370] Initializing cgroup subsys devices
[    0.025395] Initializing cgroup subsys freezer
[    0.025414] Initializing cgroup subsys net_cls
[    0.025423] Initializing cgroup subsys blkio
[    0.025429] Initializing cgroup subsys net_prio
[    0.025459] CPU: Physical Processor ID: 0
[    0.025462] CPU: Processor Core ID: 0
[    0.025467] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.025467] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.025734] mce: CPU supports 9 MCE banks
[    0.025755] CPU0: Thermal monitoring enabled (TM1)
[    0.025769] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.025769] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.025769] tlb_flushall_shift: 2
[    0.025915] Freeing SMP alternatives memory: 16K (ffffffff820bc000 - ffffffff820c0000)
[    0.035038] ftrace: allocating 34692 entries in 136 pages
[    0.046079] dmar: Host address width 36
[    0.046083] dmar: DRHD base: 0x000000fed90000 flags: 0x1
[    0.046108] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.046112] dmar: RMRR base: 0x000000de11f000 end: 0x000000de149fff
[    0.046187] IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    0.046189] HPET id 0 under DRHD base 0xfed90000
[    0.046254] Enabled IRQ remapping in xapic mode
[    0.046739] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056751] smpboot: CPU0: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.056761] TSC deadline timer enabled
[    0.056786] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.056800] ... version:                3
[    0.056802] ... bit width:              48
[    0.056804] ... generic registers:      4
[    0.056807] ... value mask:             0000ffffffffffff
[    0.056809] ... max period:             0000ffffffffffff
[    0.056811] ... fixed-purpose events:   3
[    0.056813] ... event mask:             000000070000000f
[    0.068112] x86: Booting SMP configuration:
[    0.068115] .... node  #0, CPUs:      #1
[    0.078760] CPU1 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.081613] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.083618]  #2
[    0.094157] CPU2 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.099209]  #3<6>[    0.109736] CPU3 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.114809]  #4 #5 #6 #7
[    0.175017] x86: Booted up 1 node, 8 CPUs
[    0.175032] ----------------
[    0.175034] | NMI testsuite:
[    0.175036] --------------------
[    0.175038]   remote IPI:  ok  |
[    0.179045]    local IPI:  ok  |
[    0.187060] --------------------
[    0.187065] Good, all   2 testcases passed! |
[    0.187069] ---------------------------------
[    0.187075] smpboot: Total of 8 processors activated (54458.06 BogoMIPS)
[    0.193240] devtmpfs: initialized
[    0.193761] PM: Registering ACPI NVS region [mem 0xde1b7000-0xde2e0fff] (1220608 bytes)
[    0.193790] PM: Registering ACPI NVS region [mem 0xdeab1000-0xdeaf3fff] (274432 bytes)
[    0.194925] prandom: seed boundary self test passed
[    0.195271] prandom: 100 self tests passed
[    0.195276] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.195414] NET: Registered protocol family 16
[    0.195854] cpuidle: using governor ladder
[    0.195858] cpuidle: using governor menu
[    0.195951] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.195964] ACPI: bus type PCI registered
[    0.196067] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.196072] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.196128] PCI: Using configuration type 1 for base access
[    0.207402] ACPI: Added _OSI(Module Device)
[    0.207406] ACPI: Added _OSI(Processor Device)
[    0.207409] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.207412] ACPI: Added _OSI(Processor Aggregator Device)
[    0.216512] ACPI: Executed 1 blocks of module-level executable AML code
[    0.226252] ACPI: Dynamic OEM Table Load:
[    0.226265] ACPI: SSDT 0xFFFF88040C170000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.233104] ACPI: Dynamic OEM Table Load:
[    0.233116] ACPI: SSDT 0xFFFF88040BD18C00 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.238963] ACPI: Dynamic OEM Table Load:
[    0.238974] ACPI: SSDT 0xFFFF88040C204000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.246544] ACPI: Interpreter enabled
[    0.246553] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.246561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.246594] ACPI: (supports S0 S3 S4 S5)
[    0.246597] ACPI: Using IOAPIC for interrupt routing
[    0.246638] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.259361] ACPI: Power Resource [FN00] (off)
[    0.259573] ACPI: Power Resource [FN01] (off)
[    0.259723] ACPI: Power Resource [FN02] (off)
[    0.259876] ACPI: Power Resource [FN03] (off)
[    0.260024] ACPI: Power Resource [FN04] (off)
[    0.261332] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.261339] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.261712] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.261938] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.262863] PCI host bridge to bus 0000:00
[    0.262867] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.262872] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.262877] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.262885] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.262888] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.262891] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.262895] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.262898] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.262901] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff]
[    0.262936] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.263151] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.263197] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.263354] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.263461] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.263487] pci 0000:00:14.0: reg 0x10: [mem 0xf7f00000-0xf7f0ffff 64bit]
[    0.263569] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.263657] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.263734] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.263759] pci 0000:00:16.0: reg 0x10: [mem 0xf7f1a000-0xf7f1a00f 64bit]
[    0.263845] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.264018] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.264041] pci 0000:00:1a.0: reg 0x10: [mem 0xf7f18000-0xf7f183ff]
[    0.264146] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.264262] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.264340] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.264357] pci 0000:00:1b.0: reg 0x10: [mem 0xf7f10000-0xf7f13fff 64bit]
[    0.264435] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.264529] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.264605] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.264701] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.264739] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.264743] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    0.264822] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.264905] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.265002] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.265027] pci 0000:00:1c.1: Enabling MPC IRBNCE
[    0.265031] pci 0000:00:1c.1: Intel PCH root port ACS workaround enabled
[    0.265111] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.265190] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.265286] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.265312] pci 0000:00:1c.4: Enabling MPC IRBNCE
[    0.265316] pci 0000:00:1c.4: Intel PCH root port ACS workaround enabled
[    0.265396] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.265471] pci 0000:00:1c.5: [8086:244e] type 01 class 0x060401
[    0.265567] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.265660] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.265734] pci 0000:00:1c.6: [8086:1e1c] type 01 class 0x060400
[    0.265830] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.265855] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.265859] pci 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[    0.265945] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.266020] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.266117] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.266141] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    0.266145] pci 0000:00:1c.7: Intel PCH root port ACS workaround enabled
[    0.266224] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.266302] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.266326] pci 0000:00:1d.0: reg 0x10: [mem 0xf7f17000-0xf7f173ff]
[    0.266430] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.266538] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.266615] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
[    0.266873] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.266899] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.266907] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.266916] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.266924] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.266932] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.266941] pci 0000:00:1f.2: reg 0x24: [mem 0xf7f16000-0xf7f167ff]
[    0.266995] pci 0000:00:1f.2: PME# supported from D3hot
[    0.267147] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.267163] pci 0000:00:1f.3: reg 0x10: [mem 0xf7f15000-0xf7f150ff 64bit]
[    0.267187] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.267403] pci 0000:01:00.0: [1002:6719] type 00 class 0x030000
[    0.267418] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.267428] pci 0000:01:00.0: reg 0x18: [mem 0xf7e20000-0xf7e3ffff 64bit]
[    0.267435] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.267448] pci 0000:01:00.0: reg 0x30: [mem 0xf7e00000-0xf7e1ffff pref]
[    0.267486] pci 0000:01:00.0: supports D1 D2
[    0.267559] pci 0000:01:00.1: [1002:aa80] type 00 class 0x040300
[    0.267572] pci 0000:01:00.1: reg 0x10: [mem 0xf7e40000-0xf7e43fff 64bit]
[    0.267630] pci 0000:01:00.1: supports D1 D2
[    0.268948] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.268958] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.268963] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.268971] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.269073] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.269197] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.269232] pci 0000:03:00.0: reg 0x10: [mem 0xf7dc0000-0xf7ddffff]
[    0.269252] pci 0000:03:00.0: reg 0x14: [mem 0xf7d00000-0xf7d7ffff]
[    0.269273] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.269293] pci 0000:03:00.0: reg 0x1c: [mem 0xf7de0000-0xf7de3fff]
[    0.269351] pci 0000:03:00.0: reg 0x30: [mem 0xf7d80000-0xf7dbffff pref]
[    0.269481] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.269542] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.270955] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.270967] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.270973] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.271107] pci 0000:04:00.0: [1106:3432] type 00 class 0x0c0330
[    0.271129] pci 0000:04:00.0: reg 0x10: [mem 0xf7c00000-0xf7c00fff]
[    0.271273] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.271319] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.272967] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.272982] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.273115] pci 0000:05:00.0: [8086:244e] type 01 class 0x060401
[    0.273281] pci 0000:05:00.0: supports D1 D2
[    0.273282] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.273321] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.273388] pci 0000:00:1c.5: PCI bridge to [bus 05-06] (subtractive decode)
[    0.273402] pci 0000:00:1c.5:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.273403] pci 0000:00:1c.5:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.273405] pci 0000:00:1c.5:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.273407] pci 0000:00:1c.5:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.273408] pci 0000:00:1c.5:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.273409] pci 0000:00:1c.5:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.273411] pci 0000:00:1c.5:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.273412] pci 0000:00:1c.5:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.273590] pci 0000:05:00.0: PCI bridge to [bus 06] (subtractive decode)
[    0.273619] pci 0000:05:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.273620] pci 0000:05:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.273622] pci 0000:05:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.273623] pci 0000:05:00.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.273625] pci 0000:05:00.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.273626] pci 0000:05:00.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.273628] pci 0000:05:00.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.273629] pci 0000:05:00.0:   bridge window [mem 0xe0000000-0xfeafffff] (subtractive decode)
[    0.273745] pci 0000:07:00.0: [1969:1091] type 00 class 0x020000
[    0.273778] pci 0000:07:00.0: reg 0x10: [mem 0xf7b00000-0xf7b3ffff 64bit]
[    0.273794] pci 0000:07:00.0: reg 0x18: [io  0xc000-0xc07f]
[    0.273952] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.274002] pci 0000:07:00.0: System wakeup disabled by ACPI
[    0.275987] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.275997] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.276004] pci 0000:00:1c.6:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.276130] pci 0000:08:00.0: [1b4b:9172] type 00 class 0x010601
[    0.276152] pci 0000:08:00.0: reg 0x10: [io  0xb040-0xb047]
[    0.276165] pci 0000:08:00.0: reg 0x14: [io  0xb030-0xb033]
[    0.276179] pci 0000:08:00.0: reg 0x18: [io  0xb020-0xb027]
[    0.276192] pci 0000:08:00.0: reg 0x1c: [io  0xb010-0xb013]
[    0.276206] pci 0000:08:00.0: reg 0x20: [io  0xb000-0xb00f]
[    0.276219] pci 0000:08:00.0: reg 0x24: [mem 0xf7a10000-0xf7a101ff]
[    0.276233] pci 0000:08:00.0: reg 0x30: [mem 0xf7a00000-0xf7a0ffff pref]
[    0.276303] pci 0000:08:00.0: PME# supported from D3hot
[    0.276342] pci 0000:08:00.0: System wakeup disabled by ACPI
[    0.277997] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.278007] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.278014] pci 0000:00:1c.7:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.278096] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.278892] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.278978] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.279057] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.279133] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.279208] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279284] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.279360] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.279435] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.279807] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.280146] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.280152] vgaarb: loaded
[    0.280154] vgaarb: bridge control possible 0000:01:00.0
[    0.280231] SCSI subsystem initialized
[    0.280258] libata version 3.00 loaded.
[    0.280302] ACPI: bus type USB registered
[    0.280335] usbcore: registered new interface driver usbfs
[    0.280353] usbcore: registered new interface driver hub
[    0.280386] usbcore: registered new device driver usb
[    0.280432] media: Linux media interface: v0.10
[    0.280447] Linux video capture interface: v2.00
[    0.280480] pps_core: LinuxPPS API ver. 1 registered
[    0.280482] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.280491] PTP clock support registered
[    0.280709] Advanced Linux Sound Architecture Driver Initialized.
[    0.280728] PCI: Using ACPI for IRQ routing
[    0.282269] PCI: pci_cache_line_size set to 64 bytes
[    0.282344] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.282349] e820: reserve RAM buffer [mem 0xddeb3000-0xdfffffff]
[    0.282351] e820: reserve RAM buffer [mem 0xdeab1000-0xdfffffff]
[    0.282353] e820: reserve RAM buffer [mem 0xdf47d000-0xdfffffff]
[    0.282354] e820: reserve RAM buffer [mem 0xdf800000-0xdfffffff]
[    0.282355] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
[    0.282788] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.282796] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.284858] Switched to clocksource hpet
[    0.314827] pnp: PnP ACPI init
[    0.314870] ACPI: bus type PNP registered
[    0.314995] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.315040] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.315154] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.315158] system 00:01: [io  0x0200-0x020f] has been reserved
[    0.315162] system 00:01: [io  0xffff] has been reserved
[    0.315165] system 00:01: [io  0xffff] has been reserved
[    0.315169] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.315173] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.315176] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.315182] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.315237] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.315320] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.315326] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.315492] system 00:04: [io  0x0a00-0x0a0f] has been reserved
[    0.315496] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    0.315500] system 00:04: [io  0x0a20-0x0a2f] has been reserved
[    0.315505] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.315582] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.315681] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.315686] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316118] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.316123] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.316127] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.316131] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.316135] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.316138] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.316142] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.316146] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.316150] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.316154] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.316158] system 00:07: [mem 0xf0000000-0xf0000fff] has been reserved
[    0.316163] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316336] pnp: PnP ACPI: found 8 devices
[    0.316338] ACPI: bus type PNP unregistered
[    0.324165] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.324170] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.324176] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.324180] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.324186] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.324200] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.324204] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.324211] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.324221] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.324228] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.324238] pci 0000:05:00.0: PCI bridge to [bus 06]
[    0.324264] pci 0000:00:1c.5: PCI bridge to [bus 05-06]
[    0.324277] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.324281] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.324288] pci 0000:00:1c.6:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.324298] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.324302] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.324309] pci 0000:00:1c.7:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.324320] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.324321] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.324323] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.324324] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.324326] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.324327] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.324329] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.324330] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xfeafffff]
[    0.324331] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.324333] pci_bus 0000:01: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.324334] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.324336] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.324337] pci_bus 0000:03: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.324339] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.324340] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.324342] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.324343] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.324345] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.324346] pci_bus 0000:05: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.324347] pci_bus 0000:05: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.324349] pci_bus 0000:05: resource 10 [mem 0x000dc000-0x000dffff]
[    0.324350] pci_bus 0000:05: resource 11 [mem 0xe0000000-0xfeafffff]
[    0.324351] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.324353] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.324354] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.324355] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.324357] pci_bus 0000:06: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.324358] pci_bus 0000:06: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.324360] pci_bus 0000:06: resource 10 [mem 0x000dc000-0x000dffff]
[    0.324361] pci_bus 0000:06: resource 11 [mem 0xe0000000-0xfeafffff]
[    0.324362] pci_bus 0000:07: resource 0 [io  0xc000-0xcfff]
[    0.324364] pci_bus 0000:07: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.324365] pci_bus 0000:08: resource 0 [io  0xb000-0xbfff]
[    0.324367] pci_bus 0000:08: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.324410] NET: Registered protocol family 2
[    0.324921] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.325564] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.328250] TCP: Hash tables configured (established 131072 bind 65536)
[    0.328282] TCP: reno registered
[    0.328446] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    0.329278] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    0.330085] NET: Registered protocol family 1
[    0.361099] pci 0000:01:00.0: Boot video device
[    0.361350] pci 0000:07:00.0: set MSI_INTX_DISABLE_BUG flag
[    0.361359] PCI: CLS 64 bytes, default 64
[    0.361504] Unpacking initramfs...
[    0.442271] Freeing initrd memory: 5996K (ffff88003743a000 - ffff880037a15000)
[    0.442321] DMAR: No ATSR found
[    0.442378] IOMMU 0 0xfed90000: using Queued invalidation
[    0.442384] IOMMU: Setting RMRR:
[    0.442415] IOMMU: Setting identity map for device 0000:00:14.0 [0xde11f000 - 0xde149fff]
[    0.442454] IOMMU: Setting identity map for device 0000:00:1a.0 [0xde11f000 - 0xde149fff]
[    0.442474] IOMMU: Setting identity map for device 0000:00:1d.0 [0xde11f000 - 0xde149fff]
[    0.442488] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.442499] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.442591] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.442827] ------------[ cut here ]------------
[    0.442833] WARNING: CPU: 5 PID: 1 at drivers/pci/search.c:131 pci_find_upstream_pcie_bridge+0x59/0x66()
[    0.442837] Modules linked in:
[    0.442841] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc6-00076-g6ffcc42 #371
[    0.442845] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F17 08/22/2012
[    0.442849]  0000000000000000 ffff88040c567d30 ffffffff817c4a4e 0000000000000000
[    0.442854]  ffff88040c567d68 ffffffff8109d5c4 ffffffff8134a681 0000000000000000
[    0.442859]  00000000ffffffed ffff88040be3c098 ffff88040be3c000 ffff88040c567d78
[    0.442864] Call Trace:
[    0.442869]  [<ffffffff817c4a4e>] dump_stack+0x4e/0x7a
[    0.442874]  [<ffffffff8109d5c4>] warn_slowpath_common+0x7f/0x98
[    0.442877]  [<ffffffff8134a681>] ? pci_find_upstream_pcie_bridge+0x59/0x66
[    0.442881]  [<ffffffff8109d690>] warn_slowpath_null+0x1a/0x1c
[    0.442885]  [<ffffffff8134a681>] pci_find_upstream_pcie_bridge+0x59/0x66
[    0.442889]  [<ffffffff81649e00>] intel_iommu_add_device+0x41/0x1af
[    0.442894]  [<ffffffff81646234>] ? bus_set_iommu+0x4f/0x4f
[    0.442898]  [<ffffffff81646273>] add_iommu_group+0x3f/0x46
[    0.442902]  [<ffffffff8146c3a4>] bus_for_each_dev+0x6f/0x87
[    0.442906]  [<ffffffff8164622d>] bus_set_iommu+0x48/0x4f
[    0.442911]  [<ffffffff81fd66ce>] intel_iommu_init+0x4c4/0x521
[    0.442922]  [<ffffffff81f9208f>] pci_iommu_init+0x12/0x3c
[    0.442926]  [<ffffffff81f9207d>] ? memblock_find_dma_reserve+0x13d/0x13d
[    0.442932]  [<ffffffff810003ca>] do_one_initcall+0x19d/0x1b2
[    0.442936]  [<ffffffff810b84f8>] ? parse_args+0x22e/0x35f
[    0.442940]  [<ffffffff81f8b04e>] kernel_init_freeable+0x1cc/0x254
[    0.442943]  [<ffffffff817be48f>] ? rest_init+0xc3/0xc3
[    0.442947]  [<ffffffff817be49d>] kernel_init+0xe/0xdf
[    0.442951]  [<ffffffff817d0aac>] ret_from_fork+0x7c/0xb0
[    0.442955]  [<ffffffff817be48f>] ? rest_init+0xc3/0xc3
[    0.442961] ---[ end trace 3341110207367e93 ]---
[    0.446823] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.446964] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x1b
[    0.446977] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x1b
[    0.446993] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447005] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447017] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447027] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447038] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447049] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x1b
[    0.447126] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.448347] AVX version of gcm_enc/dec engaged.
[    0.449438] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.450105] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.455490] fuse init (API version 7.23)
[    0.455769] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    0.456472] msgmni has been set to 32108
[    0.457308] bounce: pool size: 64 pages
[    0.457378] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.457482] io scheduler noop registered
[    0.457486] io scheduler deadline registered
[    0.457588] io scheduler cfq registered (default)
[    0.457592] start plist test
[    0.459055] end plist test
[    0.459057] list_sort_test: start testing list_sort()
[    0.459587] pcieport 0000:00:01.0: irq 41 for MSI/MSI-X
[    0.460770] simple-framebuffer simple-framebuffer.0: framebuffer at 0xe0000000, 0x1d5000 bytes, mapped to 0xffffc90006100000
[    0.460776] simple-framebuffer simple-framebuffer.0: format=a8r8g8b8, mode=800x600x32, linelength=3200
[    0.462083] Console: switching to colour frame buffer device 100x37
[    0.463013] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    0.463048] intel_idle: MWAIT substates: 0x1120
[    0.463049] intel_idle: v0.4 model 0x3A
[    0.463050] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.463871] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.463933] ACPI: Power Button [PWRB]
[    0.464020] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.464046] ACPI: Power Button [PWRF]
[    0.464195] ACPI: Fan [FAN0] (off)
[    0.464256] ACPI: Fan [FAN1] (off)
[    0.464317] ACPI: Fan [FAN2] (off)
[    0.464376] ACPI: Fan [FAN3] (off)
[    0.464438] ACPI: Fan [FAN4] (off)
[    0.472690] thermal LNXTHERM:00: registered as thermal_zone0
[    0.472712] ACPI: Thermal Zone [TZ00] (28 C)
[    0.473624] thermal LNXTHERM:01: registered as thermal_zone1
[    0.474123] ACPI: Thermal Zone [TZ01] (30 C)
[    0.474701] GHES: HEST is not enabled!
[    0.475298] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.476721] Linux agpgart interface v0.103
[    0.477274] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.478337] Hangcheck: Using getrawmonotonic().
[    0.478899] [drm] Initialized drm 1.1.0 20060810
[    0.481263] loop: module loaded
[    0.482045] nbd: registered device at major 43
[    0.485539]  nullb0: unknown partition table
[    0.486336]  nullb1: unknown partition table
[    0.486980] null: module loaded
[    0.487479] Loading iSCSI transport class v2.0-870.
[    0.488121] iscsi: registered transport (tcp)
[    0.488698] ahci 0000:00:1f.2: version 3.0
[    0.488894] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    0.499976] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x37 impl SATA mode
[    0.500487] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.510214] scsi0 : ahci
[    0.511023] scsi1 : ahci
[    0.511714] scsi2 : ahci
[    0.512395] scsi3 : ahci
[    0.513057] scsi4 : ahci
[    0.513695] scsi5 : ahci
[    0.514215] ata1: SATA max UDMA/133 abar m2048@0xf7f16000 port 0xf7f16100 irq 42
[    0.514665] ata2: SATA max UDMA/133 abar m2048@0xf7f16000 port 0xf7f16180 irq 42
[    0.515103] ata3: SATA max UDMA/133 abar m2048@0xf7f16000 port 0xf7f16200 irq 42
[    0.515518] ata4: DUMMY
[    0.515918] ata5: SATA max UDMA/133 abar m2048@0xf7f16000 port 0xf7f16300 irq 42
[    0.516339] ata6: SATA max UDMA/133 abar m2048@0xf7f16000 port 0xf7f16380 irq 42
[    0.516888] ahci 0000:08:00.0: irq 43 for MSI/MSI-X
[    0.516955] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    0.517403] ahci 0000:08:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    0.518369] scsi6 : ahci
[    0.519027] scsi7 : ahci
[    0.519558] ata7: SATA max UDMA/133 abar m512@0xf7a10000 port 0xf7a10100 irq 43
[    0.520032] ata8: SATA max UDMA/133 abar m512@0xf7a10000 port 0xf7a10180 irq 43
[    0.520539] tun: Universal TUN/TAP device driver, 1.6
[    0.521010] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.524490] alx 0000:07:00.0 eth0: Qualcomm Atheros AR816x/AR817x Ethernet [90:2b:34:5f:ae:0c]
[    0.524988] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.525460] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    0.526129] e1000e 0000:03:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.527083] e1000e 0000:03:00.0: irq 44 for MSI/MSI-X
[    0.527090] e1000e 0000:03:00.0: irq 45 for MSI/MSI-X
[    0.527096] e1000e 0000:03:00.0: irq 46 for MSI/MSI-X
[    0.629416] e1000e 0000:03:00.0 eth1: registered PHC clock
[    0.629888] e1000e 0000:03:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 68:05:ca:16:d3:77
[    0.630375] e1000e 0000:03:00.0 eth1: Intel(R) PRO/1000 Network Connection
[    0.630866] e1000e 0000:03:00.0 eth1: MAC: 3, PHY: 8, PBA No: E46981-008
[    0.631373] PPP generic driver version 2.4.2
[    0.632017] PPP BSD Compression module registered
[    0.632506] PPP Deflate Compression module registered
[    0.633001] PPP MPPE Compression module registered
[    0.633490] NET: Registered protocol family 24
[    0.634009] usbcore: registered new interface driver asix
[    0.634502] usbcore: registered new interface driver ax88179_178a
[    0.634981] usbcore: registered new interface driver cdc_ether
[    0.635451] usbcore: registered new interface driver cdc_eem
[    0.635919] usbcore: registered new interface driver CoreChips
[    0.636393] usbcore: registered new interface driver rndis_host
[    0.636861] usbcore: registered new interface driver cdc_subset
[    0.637345] usbcore: registered new interface driver cdc_ncm
[    0.637817] usbcore: registered new interface driver cdc_mbim
[    0.638424] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.638892] ehci-pci: EHCI PCI platform driver
[    0.639591] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.640389] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.640897] ehci-pci 0000:00:1a.0: debug port 2
[    0.645304] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.645341] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7f18000
[    0.651080] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.651769] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.652221] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.652675] usb usb1: Product: EHCI Host Controller
[    0.653124] usb usb1: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 ehci_hcd
[    0.653586] usb usb1: SerialNumber: 0000:00:1a.0
[    0.654568] hub 1-0:1.0: USB hub found
[    0.655041] hub 1-0:1.0: 2 ports detected
[    0.656241] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.656792] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.657248] ehci-pci 0000:00:1d.0: debug port 2
[    0.661577] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.661596] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7f17000
[    0.668022] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.668497] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.668901] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.669310] usb usb2: Product: EHCI Host Controller
[    0.669711] usb usb2: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 ehci_hcd
[    0.670120] usb usb2: SerialNumber: 0000:00:1d.0
[    0.670760] hub 2-0:1.0: USB hub found
[    0.671173] hub 2-0:1.0: 2 ports detected
[    0.671812] uhci_hcd: USB Universal Host Controller Interface driver
[    0.672456] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.672962] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.673496] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.673549] xhci_hcd 0000:00:14.0: irq 47 for MSI/MSI-X
[    0.673631] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.674067] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.674507] usb usb3: Product: xHCI Host Controller
[    0.674951] usb usb3: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 xhci_hcd
[    0.675414] usb usb3: SerialNumber: 0000:00:14.0
[    0.676114] hub 3-0:1.0: USB hub found
[    0.676610] hub 3-0:1.0: 4 ports detected
[    0.677763] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.678373] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.678916] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.679401] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.679882] usb usb4: Product: xHCI Host Controller
[    0.680361] usb usb4: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 xhci_hcd
[    0.680848] usb usb4: SerialNumber: 0000:00:14.0
[    0.681623] hub 4-0:1.0: USB hub found
[    0.682126] hub 4-0:1.0: 4 ports detected
[    0.683388] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    0.683963] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 5
[    0.684729] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    0.684817] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    0.685306] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.685789] usb usb5: Product: xHCI Host Controller
[    0.686278] usb usb5: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 xhci_hcd
[    0.686772] usb usb5: SerialNumber: 0000:04:00.0
[    0.687486] hub 5-0:1.0: USB hub found
[    0.687981] hub 5-0:1.0: 1 port detected
[    0.688688] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    0.689274] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 6
[    0.689839] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[    0.690343] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.690837] usb usb6: Product: xHCI Host Controller
[    0.691329] usb usb6: Manufacturer: Linux 3.16.0-rc6-00076-g6ffcc42 xhci_hcd
[    0.691824] usb usb6: SerialNumber: 0000:04:00.0
[    0.692559] hub 6-0:1.0: USB hub found
[    0.693073] hub 6-0:1.0: 4 ports detected
[    0.693863] usbcore: registered new interface driver cdc_acm
[    0.694359] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    0.694894] usbcore: registered new interface driver usblp
[    0.695415] usbcore: registered new interface driver cdc_wdm
[    0.695937] usbcore: registered new interface driver usb-storage
[    0.696456] usbcore: registered new interface driver usbserial
[    0.696941] usbcore: registered new interface driver usbserial_generic
[    0.697462] usbserial: USB Serial support registered for generic
[    0.697947] usbcore: registered new interface driver ftdi_sio
[    0.698435] usbserial: USB Serial support registered for FTDI USB Serial Device
[    0.698981] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.699470] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.700656] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.701493] mousedev: PS/2 mouse device common for all mice
[    0.702541] usbcore: registered new interface driver wacom
[    0.703123] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    0.703797] rtc_cmos 00:02: RTC can wake from S4
[    0.704545] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.705119] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.705666] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    0.706351] ACPI Warning: SystemIO range 0x000000000000f000-0x000000000000f01f conflicts with OpRegion 0x000000000000f000-0x000000000000f00f (\_SB_.PCI0.SBUS.SMBI) (20140424/utaddress-258)
[    0.707440] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.708786] lirc_dev: IR Remote Control driver registered, major 247 
[    0.709365] IR NEC protocol handler initialized
[    0.709945] IR RC5(x) protocol handler initialized
[    0.710513] IR RC6 protocol handler initialized
[    0.711075] IR JVC protocol handler initialized
[    0.711618] IR Sony protocol handler initialized
[    0.712164] IR RC5 (streamzap) protocol handler initialized
[    0.712719] IR SANYO protocol handler initialized
[    0.713260] IR Sharp protocol handler initialized
[    0.713787] IR MCE Keyboard/mouse protocol handler initialized
[    0.714322] IR LIRC bridge handler initialized
[    0.714887] usbcore: registered new interface driver uvcvideo
[    0.715444] USB Video Class driver (1.1.1)
[    0.716080] usbcore: registered new interface driver pvrusb2
[    0.716605] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
[    0.717156] pvrusb2: Debug mask is 31 (0x1f)
[    0.718419] device-mapper: uevent: version 1.0.3
[    0.719155] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.720793] EFI Variables Facility v0.08 2004-May-17
[    0.722591] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.728289] pstore: Registered efi as persistent store backend
[    0.728906] hidraw: raw HID events driver (C) Jiri Kosina
[    0.729696] usbcore: registered new interface driver usbhid
[    0.730282] usbhid: USB HID core driver
[    0.730971] intel_rapl: RAPL domain uncore detection failed
[    0.731568] intel_rapl: RAPL domain dram detection failed
[    0.733541] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    0.734327] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    0.735082] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    0.735262] snd_hda_intel 0000:01:00.1: irq 50 for MSI/MSI-X
[    0.735425] TCP: cubic registered
[    0.735979] Initializing XFRM netlink socket
[    0.736835] NET: Registered protocol family 10
[    0.738115] sit: IPv6 over IPv4 tunneling driver
[    0.739398] NET: Registered protocol family 17
[    0.739738] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input4
[    0.741393] NET: Registered protocol family 15
[    0.744282] sound hdaudioC0D2: autoconfig: line_outs=4 (0x24/0x25/0x26/0x27/0x0) type:line
[    0.744809] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.745335] sound hdaudioC0D2:    hp_outs=1 (0x28/0x0/0x0/0x0/0x0)
[    0.745850] sound hdaudioC0D2:    mono: mono_out=0x0
[    0.746366] sound hdaudioC0D2:    dig-out=0x2d/0x2e
[    0.746879] sound hdaudioC0D2:    inputs:
[    0.747392] sound hdaudioC0D2:      Front Mic=0x29
[    0.747494] sctp: Hash tables configured (established 65536 bind 65536)
[    0.747772] Key type dns_resolver registered
[    0.748595] registered taskstats version 1
[    0.749538] sound hdaudioC0D2:      Rear Mic=0x2b
[    0.750058] sound hdaudioC0D2:      Line=0x2a
[    0.750675] console [netcon0] enabled
[    0.751233] netconsole: network logging started
[    0.751840] rtc_cmos 00:02: setting system clock to 2014-07-22 20:50:21 UTC (1406062221)
[    0.755155] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.755625] EDD information not available.
[    0.756234] ALSA device list:
[    0.756680]   #1: HDA ATI HDMI at 0xf7e40000 irq 50
[    0.758593] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    0.759186] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    0.759737] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    0.760309] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    0.761312] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    0.762380] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    0.763501] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    0.764617] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    0.822168] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.823547] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.824872] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.825140] ata7: SATA link down (SStatus 0 SControl 300)
[    0.825198] ata8: SATA link down (SStatus 0 SControl 300)
[    0.828640] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.829880] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.831179] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.832431] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88040e049f00), AE_NOT_FOUND (20140424/psparse-536)
[    0.835002] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.836346] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88040e05f000), AE_NOT_FOUND (20140424/psparse-536)
[    0.839129] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.840501] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff88040e05f0f0), AE_NOT_FOUND (20140424/psparse-536)
[    0.843297] ata5.00: ATAPI: IMATION RDX-SATA, 0044, max UDMA/66
[    0.844867] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.846354] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff88040e05f168), AE_NOT_FOUND (20140424/psparse-536)
[    0.849234] ata6.00: ATAPI: TSSTcorpDVD-ROM SH-D163A, SB00, max UDMA/33
[    0.850731] ata3.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
[    0.852234] ata3.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.853812] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.855324] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88040e049f78), AE_NOT_FOUND (20140424/psparse-536)
[    0.858327] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
[    0.859853] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.861709] ata2.00: ATA-8: SanDisk SDSSDX240GG25, R201, max UDMA/133
[    0.863237] ata2.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.864760] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.866232] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88040e05f000), AE_NOT_FOUND (20140424/psparse-536)
[    0.869204] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.869846] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff88040e05f0f0), AE_NOT_FOUND (20140424/psparse-536)
[    0.871870] ata5.00: configured for UDMA/66
[    0.873346] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.874865] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88040e049f00), AE_NOT_FOUND (20140424/psparse-536)
[    0.877953] ata3.00: configured for UDMA/133
[    0.879631] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.881276] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff88040e05f168), AE_NOT_FOUND (20140424/psparse-536)
[    0.882667] ata6.00: configured for UDMA/33
[    0.883530] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    0.885132] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88040e049f78), AE_NOT_FOUND (20140424/psparse-536)
[    0.888270] ata1.00: configured for UDMA/133
[    0.889164] ata2.00: configured for UDMA/133
[    0.890169] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
[    0.891013] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    0.891334] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.891398] sd 0:0:0:0: [sda] Write Protect is off
[    0.891402] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.891575] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.899853] scsi 1:0:0:0: Direct-Access     ATA      SanDisk SDSSDX24 R201 PQ: 0 ANSI: 5
[    0.901595] sd 1:0:0:0: [sdb] 468862128 512-byte logical blocks: (240 GB/223 GiB)
[    0.901743] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    0.902325] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 3B01 PQ: 0 ANSI: 5
[    0.903093] sd 2:0:0:0: [sdc] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    0.903216] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    0.903469] sd 2:0:0:0: [sdc] Write Protect is off
[    0.903472] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    0.903634] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.904585] scsi 4:0:0:0: Direct-Access     IMATION  RDX-SATA         0044 PQ: 0 ANSI: 3
[    0.906365] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    0.907245] scsi 5:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D163A SB00 PQ: 0 ANSI: 5
[    0.917648] sd 1:0:0:0: [sdb] Write Protect is off
[    0.918319] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.918344] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.921173]  sdb: sdb1 sdb2 sdb3
[    0.923996] sd 1:0:0:0: [sdb] Attached SCSI disk
[    0.927626] sd 4:0:0:0: [sdd] Attached SCSI removable disk
[    0.928016]  sda: sda1 sda2 sda3
[    0.928772] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.929962] sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
[    0.931327] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.933151] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    0.933361] sr 5:0:0:0: Attached scsi generic sg4 type 5
[    0.957294] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.971666]  sdc: sdc1
[    0.973385] sd 2:0:0:0: [sdc] Attached SCSI disk
[    0.975821] Freeing unused kernel memory: 1308K (ffffffff81f75000 - ffffffff820bc000)
[    0.976617] Write protecting the kernel read-only data: 14336k
[    0.978395] Freeing unused kernel memory: 152K (ffff8800017da000 - ffff880001800000)
[    0.983141] Freeing unused kernel memory: 1512K (ffff880001c86000 - ffff880001e00000)
