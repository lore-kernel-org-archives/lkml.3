Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3AZNcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:32:09 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:62928 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3AZNcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:32:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBADDaA1F8qkuu/2dsb2JhbAANOL58hBABPBYYAwIBAgFLDQEFAgEBsy6TJ5EaA5JajH+KBQ
X-IronPort-AV: E=Sophos;i="4.84,544,1355068800"; 
   d="scan'208";a="67154177"
Message-ID: <5103DAD3.1040503@uclinux.org>
Date: Sat, 26 Jan 2013 23:32:03 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: execve and kernel_thread unification problem on m68knommu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

As of commit fea82210 ("m68k: switch to saner kernel_execve()
semantics") I can't get non-mmu m68k targets to boot through to
user space. I don't think this commit itself is the problem, but
probably something in the generic execve changes.

What I see is that it boots up to trying to exec /bin/init and it
tries to return back through an address of 0. Running on QEMU I
see a final dump like this (full dump attached at end):

qemu: fatal: Trying to execute code outside RAM or ROM at 0x00000000

D0 = 00000000   A0 = 402e6090   F0 = 0000000000000000 (           0)
D1 = 00002000   A1 = 418bb400   F1 = 0000000000000000 (           0)
D2 = 418402f0   A2 = 4184c000   F2 = 0000000000000000 (           0)
D3 = 4184043a   A3 = 40185fbc   F3 = 0000000000000000 (           0)
D4 = 00000000   A4 = 00000000   F4 = 0000000000000000 (           0)
D5 = 00000000   A5 = 00000000   F5 = 0000000000000000 (           0)
D6 = 00000000   A6 = 00000000   F6 = 0000000000000000 (           0)
D7 = 00000000   A7 = 41837fc8   F7 = 0000000000000000 (           0)
PC = 00000000   SR = 2000 ----- FPRESULT =            0
Aborted

I haven't debugged this through yet. It was working back a few months
ago when I tried these patches. Any ideas on what might be going
wrong?

The little tracing I have done on it shows that we return back
from do_execve() in init/main.c and back through to kernel_init().
The return there is the one that tries to go back through 0.

If I put the m68k arch ret_from_kernel_execve code back in entry.S
and hack in a call to it from init/main.c run_init_process() then I can
get it to fully boot, as it used to.

Regards
Greg



Linux version 3.8.0-rc5 (gerg@gumby) (gcc version 4.5.1 (GCC) ) #1 Sat
Jan 26 22:42:45 EST 2013

uClinux/COLDFIRE(m520x)
COLDFIRE port done by Greg Ungerer, gerg@snapgear.com
Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne
Built 1 zonelists in Zone order, mobility grouping off.  Total pages: 4080
Kernel command line: root=/dev/mtdblock0
PID hash table entries: 128 (order: -4, 512 bytes)
Dentry cache hash table entries: 4096 (order: 1, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 0, 8192 bytes)
Memory: 29744k/29744k available (1448k kernel code, 1520k data, 56k init)
Virtual kernel memory layout:
    vector  : 0x40000000 - 0x40000400   (   1 KiB)
    kmap    : 0x00000000 - 0xffffffff   (4095 MiB)
    vmalloc : 0x00000000 - 0xffffffff   (4095 MiB)
    lowmem  : 0x40000000 - 0x42000000   (  32 MiB)
      .init : 0x401c8000 - 0x401d6000   (  56 KiB)
      .text : 0x40020000 - 0x401889a0   (1443 KiB)
      .data : 0x401889a0 - 0x401c7360   ( 251 KiB)
      .bss  : 0x401d6000 - 0x401e1a4c   (  47 KiB)
SLUB: Genslabs=15, HWalign=16, Order=0-3, MinObjects=0, CPUs=1, Nodes=8
NR_IRQS:256
Calibrating delay loop... 457.11 BogoMIPS (lpj=2285568)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource pit
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 0, 8192 bytes)
TCP bind hash table entries: 1024 (order: -1, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP: reno registered
UDP hash table entries: 512 (order: 0, 8192 bytes)
UDP-Lite hash table entries: 512 (order: 0, 8192 bytes)
NET: Registered protocol family 1
ROMFS MTD (C) 2007 Red Hat, Inc.
io scheduler noop registered (default)
ColdFire internal UART serial driver
ttyS0 at MMIO 0xfc060000 (irq = 90) is a ColdFire UART
console [ttyS0] enabled
ttyS1 at MMIO 0xfc064000 (irq = 91) is a ColdFire UART
ttyS2 at MMIO 0xfc068000 (irq = 92) is a ColdFire UART
brd: module loaded
uclinux[mtd]: RAM probe address=0x401e1a4c size=0xde000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000000de000 : "ROMfs"
FEC: MDIO read timeout
TCP: cubic registered
NET: Registered protocol family 17
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 56k freed (0x401c8000 - 0x401d6000)
qemu: fatal: Trying to execute code outside RAM or ROM at 0x00000000

D0 = 00000000   A0 = 402e6090   F0 = 0000000000000000 (           0)
D1 = 00002000   A1 = 418bb400   F1 = 0000000000000000 (           0)
D2 = 418402f0   A2 = 4184c000   F2 = 0000000000000000 (           0)
D3 = 4184043a   A3 = 40185fbc   F3 = 0000000000000000 (           0)
D4 = 00000000   A4 = 00000000   F4 = 0000000000000000 (           0)
D5 = 00000000   A5 = 00000000   F5 = 0000000000000000 (           0)
D6 = 00000000   A6 = 00000000   F6 = 0000000000000000 (           0)
D7 = 00000000   A7 = 41837fc8   F7 = 0000000000000000 (           0)
PC = 00000000   SR = 2000 ----- FPRESULT =            0
Aborted

