Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaIGT4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 15:56:43 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:33984 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaIGT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 15:56:41 -0400
X-Greylist: delayed 95070 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2014 15:56:41 EDT
Date: Sun, 7 Sep 2014 21:56:37 +0200
From: jurriaan@onderneming10.net
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ARM kirkwood: 1 Gb memory 25% unusable due to vmalloc region
 overlap
Message-ID: <20140907195637.GA5310@qnap.onderneming10.net>
References: <20140906173207.GA1046@qnap.onderneming10.net>
 <20140906182916.GA12361@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906182916.GA12361@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Sat, Sep 06, 2014 at 07:29:16PM +0100
> On Sat, Sep 06, 2014 at 07:32:07PM +0200, Jurriaan wrote:
> > I updated my Qnap TS-212 with 256 Mb memory to a new TS-221 with 1 Gb
> > memory.
> > 
> > On booting, I see that a large chunk of that new memory is not used by
> > linux:
> > 
> > [    0.000000] Booting Linux on physical CPU 0x0
> > [    0.000000] Initializing cgroup subsys cpuset
> > [    0.000000] Initializing cgroup subsys cpu
> > [    0.000000] Initializing cgroup subsys cpuacct
> > [    0.000000] Linux version 3.14-2-kirkwood (debian-kernel@lists.debian.org) (gcc version 4.8.3 (Debian 4.8.3-7) ) #1 Debian 3.14.15-2 (2014-08-09)
> > [    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
> > [    0.000000] CPU: VIVT data cache, VIVT instruction cache
> > [    0.000000] Machine: QNAP TS-119/TS-219
> > [    0.000000] Ignoring unrecognised tag 0x41000403
> > [    0.000000] Truncating RAM at 20000000-3fffffff to -2f7fffff (vmalloc region overlap).
> > 
> > Whoops!
> 
> You can either enable highmem (which has been available on ARM for
> ages now, there's little excuse not to use it) or reduce the available
> userspace virtual memory by enabling VMSPLIT_2G.
> 

Thanks, CONFIG_HIGHMEM=y did the trick:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14.15-kirkwood (root@qnap) (gcc version 4.9.1 (Debian 4.9.1-12) ) #1 Sun Sep 7 12:36:56 CEST 2014
[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: QNAP TS-119/TS-219
[    0.000000] Ignoring unrecognised tag 0x41000403
[    0.000000] Memory policy: Data cache writeback
[    0.000000] On node 0 totalpages: 262144
[    0.000000] free_area_init_node: node 0, pgdat c05a78b4, node_mem_map eeffa000
[    0.000000]   DMA zone: 1520 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260624
[    0.000000] Kernel command line: console=ttyS0,115200 root=/dev/ram initrd=0xa00000,0x900000 ramdisk=34816
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1024056K/1048576K available (3849K kernel code, 353K rwdata, 1396K rodata, 202K init, 428K bss, 24520K reserved, 270336K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc05278a4   (5247 kB)
[    0.000000]       .init : 0xc0528000 - 0xc055aa1c   ( 203 kB)
[    0.000000]       .data : 0xc055c000 - 0xc05b4448   ( 354 kB)
[    0.000000]        .bss : 0xc05b4448 - 0xc061f5e4   ( 429 kB)
[    0.000000] NR_IRQS:114

Kind regards,
Jurriaan
