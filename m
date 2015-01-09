Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbbAIMOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:14:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57095 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484AbbAIMOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:14:35 -0500
Date: Fri, 9 Jan 2015 12:13:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Langsdorf <mlangsdo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150109121348.GD12942@leverpostej>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
 <54AE7D53.2020305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE7D53.2020305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
> On 01/05/2015 07:46 PM, Linus Torvalds wrote:
> > It's a day delayed - not because of any particular development issues,
> > but simply because I was tiling a bathroom yesterday. But rc3 is out
> > there now, and things have stayed reasonably calm. I really hope that
> > implies that 3.19 is looking good, but it's equally likely that it's
> > just that people are still recovering from the holiday season.
> 
> I'm consistently getting an out of memory killer triggered when
> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
> with 16 GB of memory. This doesn't happen when running a 3.18
> kernel.
> 
> I'm going to start bisecting the failure now, but here's the crash
> log in case someone can see something obvious in it.

FWIW I've just reproduced this with v3.19-rc3 defconfig +
CONFIG_ARM64_64K_PAGES=y by attempting a git clone of mainline. My
system has 16GB of RAM and 6 CPUs.

I have a similarly dodgy looking number of pages reserved
(18446744073709544451 A.K.A. -7165). Log below.

Thanks,
Mark.

git invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
CPU: 2 PID: 9777 Comm: git Not tainted 3.19.0-rc3+ #37
Call trace:
[<fffffe0000096b4c>] dump_backtrace+0x0/0x124
[<fffffe0000096c80>] show_stack+0x10/0x1c
[<fffffe0000552f40>] dump_stack+0x80/0xc4
[<fffffe000013c148>] dump_header.isra.9+0x80/0x1c4
[<fffffe000013c868>] oom_kill_process+0x390/0x3f0
[<fffffe000013cdb0>] out_of_memory+0x2f0/0x324
[<fffffe0000141178>] __alloc_pages_nodemask+0x860/0x874
[<fffffe0000161ae4>] handle_mm_fault+0x7c0/0xe7c
[<fffffe000009f8d0>] do_page_fault+0x188/0x2f8
[<fffffe0000090230>] do_mem_abort+0x38/0x9c
Exception stack(0xfffffe03bf877e30 to 0xfffffe03bf877f50)
7e20:                                     00000000 00000000 84000078 000003ff
7e40: ffffffff ffffffff abc27210 000003ff 00000006 00000000 001971a4 fffffe00
7e60: bf877ec0 fffffe03 0019725c fffffe00 00000000 00000000 00000028 00000000
7e80: ffffffff ffffffff abc6c718 000003ff 00000000 00000000 00000015 00000000
7ea0: 0000011a 00000000 00024800 00000000 00000024 00000100 00000003 fffffe03
7ec0: 93f7d6c0 000003ff 000939b0 fffffe00 85879770 000003ff 858817b0 000003ff
7ee0: 0000e851 00000000 00008045 00000000 00008041 00000000 04b10000 00000000
7f00: 00008060 00000000 85890000 000003ff 00000038 00000000 6f6c72ff 62606f5e
7f20: 00000040 00000000 01010101 01010101 00000076 00000000 00040000 00000000
7f40: 09fecda5 00000000 ec5a90c4 00000000
Mem-Info:
DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   2
Normal per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   4
CPU    5: hi:    6, btch:   1 usd:   5
active_anon:241994 inactive_anon:226 isolated_anon:0
 active_file:1063 inactive_file:1075 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:13439 slab_reclaimable:363 slab_unreclaimable:1137
 mapped:188 shmem:146 pagetables:94 bounce:0
 free_cma:2401
DMA free:243840kB min:208000kB low:259968kB high:312000kB active_anon:3800448kB inactive_anon:2624kB active_file:8576kB inactive_file:9344kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4177920kB managed:4166464kB mlocked:0kB dirty:0kB writeback:0kB mapped:1152kB shmem:2304kB slab_reclaimable:4480kB slab_unreclaimable:16576kB kernel_stack:128kB pagetables:2688kB unstable:0kB bounce:0kB free_cma:153664kB writeback_tmp:0kB pages_scanned:201984 all_unreclaimable? yes
lowmem_reserve[]: 0 764 764
Normal free:616256kB min:625472kB low:781824kB high:938176kB active_anon:11687168kB inactive_anon:11840kB active_file:59456kB inactive_file:59456kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:12582912kB managed:12528640kB mlocked:0kB dirty:0kB writeback:0kB mapped:10880kB shmem:7040kB slab_reclaimable:18752kB slab_unreclaimable:56192kB kernel_stack:2032kB pagetables:3328kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:2989056 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
DMA: 1563*64kB (URC) 527*128kB (UC) 0*256kB 1*512kB (R) 0*1024kB 1*2048kB (R) 0*4096kB 1*8192kB (R) 0*16384kB 0*32768kB 1*65536kB (R) 0*131072kB 0*262144kB 0*524288kB = 243776kB
Normal: 5*64kB (MR) 4*128kB (MR) 4*256kB (R) 2*512kB (MR) 3*1024kB (MR) 2*2048kB (MR) 4*4096kB (MR) 2*8192kB (MR) 3*16384kB (MR) 4*32768kB (MR) 0*65536kB 1*131072kB (R) 1*262144kB (R) 0*524288kB = 616256kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=524288kB
1266 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
261888 pages RAM
0 pages HighMem/MovableOnly
18446744073709544451 pages reserved
8192 pages cma reserved
[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[  930]     0   930       57       13       2        0             0 upstart-udev-br
[  935]     0   935      195       60       4        0         -1000 systemd-udevd
[ 1252]     0  1252       51       11       2        0             0 upstart-file-br
[ 1254]   101  1254     3538       56       3        0             0 rsyslogd
[ 1278]   104  1278       88       49       4        0             0 dbus-daemon
[ 1338]     0  1338       96       52       4        0             0 systemd-logind
[ 1376]     0  1376       50       11       2        0             0 upstart-socket-
[ 1416]     0  1416     3682      144       3        0             0 ModemManager
[ 1527]     0  1527       74       34       4        0             0 getty
[ 1528]     0  1528     3872      145       5        0             0 NetworkManager
[ 1529]     0  1529       74       35       4        0             0 getty
[ 1534]     0  1534       74       34       4        0             0 getty
[ 1535]     0  1535       74       34       3        0             0 getty
[ 1537]     0  1537       74       34       3        0             0 getty
[ 1552]     0  1552      151       92       3        0         -1000 sshd
[ 1561]     0  1561       63       38       3        0             0 cron
[ 1565]     0  1565     3602       89       4        0             0 polkitd
[ 1604]     0  1604      126       72       4        0             0 login
[ 1606]     0  1606       74       34       3        0             0 getty
[ 1621]     0  1621       99       68       3        0             0 dhclient
[ 1626] 65534  1626       67       48       4        0             0 dnsmasq
[ 1716]  1000  1716       72       45       4        0             0 bash
[ 1730]     0  1730      238      120       2        0             0 sshd
[ 1743]  1000  1743      238       94       2        0             0 sshd
[ 1744]  1000  1744       96       50       4        0             0 bash
[ 9767]  1000  9767      240       58       3        0             0 git
[ 9773]  1000  9773    11894     9252       6        0             0 git
Out of memory: Kill process 9773 (git) score 35 or sacrifice child
Killed process 9773 (git) total-vm:761216kB, anon-rss:589376kB, file-rss:2752kB

