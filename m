Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbbAIR54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:57:56 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59104 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbbAIR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:57:24 -0500
Date: Fri, 9 Jan 2015 17:57:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Langsdorf <mlangsdo@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150109175702.GA27787@leverpostej>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
 <54AE7D53.2020305@redhat.com>
 <20150109121348.GD12942@leverpostej>
 <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
 <54AFE53A.4020004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFE53A.4020004@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:27:06PM +0000, Mark Langsdorf wrote:
> On 01/09/2015 08:19 AM, Steve Capper wrote:
> > On 9 January 2015 at 12:13, Mark Rutland <mark.rutland@arm.com> wrote:
> >> On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
> >>> I'm consistently getting an out of memory killer triggered when
> >>> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
> >>> with 16 GB of memory. This doesn't happen when running a 3.18
> >>> kernel.
> >>>
> >>> I'm going to start bisecting the failure now, but here's the crash
> >>> log in case someone can see something obvious in it.
> >>
> >> FWIW I've just reproduced this with v3.19-rc3 defconfig +
> >> CONFIG_ARM64_64K_PAGES=y by attempting a git clone of mainline. My
> >> system has 16GB of RAM and 6 CPUs.
> >>
> >> I have a similarly dodgy looking number of pages reserved
> >> (18446744073709544451 A.K.A. -7165). Log below.
> >>
> >
> > I think the negative page reserved count is a consequence of another bug.
> >
> > We have the following reporting code in lib/show_mem.c:
> > #ifdef CONFIG_CMA
> >          printk("%lu pages reserved\n", (reserved - totalcma_pages));
> >          printk("%lu pages cma reserved\n", totalcma_pages);
> > #else
> >
> > With totalcma_pages being reported as 8192, that would account for the
> > -7000ish values reported.
> >
> > That change appears to have come from:
> > 49abd8c lib/show_mem.c: add cma reserved information
> >
> > Is the quickest way to exacerbate this OOM a kernel compile?
> 
> I haven't really tried to characterize this. Compiling a kernel
> on a 64K page machine causes a failure reasonably quickly and
> doesn't require a lot of thought. I think that time spent finding
> a faster reproducer wouldn't pay off.

I wasn't able to trigger the issue again with git, and the only way I've
managed to trigger the issue is repeatedly building the kernel in a
loop:

while true; do
	git clean -fdx > /dev/null 2>&1;
	make defconfig > /dev/null 2>&1;
	make > /dev/null > 2>&1;
done

Which after a while died:

-bash: fork: Cannot allocate memory

I didn't see anything interesting in dmesg, but I was able to get at
/proc/meminfo:

MemTotal:       16695168 kB
MemFree:          998336 kB
MemAvailable:     325568 kB
Buffers:           51200 kB
Cached:           236224 kB
SwapCached:            0 kB
Active:         14970880 kB
Inactive:         580288 kB
Active(anon):   14834496 kB
Inactive(anon):     5760 kB
Active(file):     136384 kB
Inactive(file):   574528 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               448 kB
Writeback:             0 kB
AnonPages:         22400 kB
Mapped:            10240 kB
Shmem:              8768 kB
Slab:              63744 kB
SReclaimable:      27072 kB
SUnreclaim:        36672 kB
KernelStack:        1824 kB
PageTables:         3776 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     8347584 kB
Committed_AS:      50368 kB
VmallocTotal:   2142764992 kB
VmallocUsed:      283264 kB
VmallocChunk:   2142387200 kB
AnonHugePages:         0 kB
CmaTotal:         524288 kB
CmaFree:             128 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:     524288 kB

And also magic-sysrq m:

SysRq : Show Memory
Mem-Info:
DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   3
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   5
Normal per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   5
active_anon:231780 inactive_anon:90 isolated_anon:0
 active_file:2131 inactive_file:8977 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:15601 slab_reclaimable:423 slab_unreclaimable:573
 mapped:160 shmem:137 pagetables:59 bounce:0
 free_cma:2
DMA free:302336kB min:208000kB low:259968kB high:312000kB active_anon:3618432kB inactive_anon:768kB active_file:34432kB inactive_file:131584kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4177920kB managed:4166528kB mlocked:0kB dirty:192kB writeback:0kB mapped:4736kB shmem:1024kB slab_reclaimable:5184kB slab_unreclaimable:3328kB kernel_stack:0kB pagetables:1600kB unstable:0kB bounce:0kB free_cma:128kB writeback_tmp:0kB pages_scanned:1208448 all_unreclaimable? yes
lowmem_reserve[]: 0 764 764
Normal free:696128kB min:625472kB low:781824kB high:938176kB active_anon:11215488kB inactive_anon:4992kB active_file:101952kB inactive_file:442944kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:12582912kB managed:12528640kB mlocked:0kB dirty:320kB writeback:0kB mapped:5504kB shmem:7744kB slab_reclaimable:21888kB slab_unreclaimable:33344kB kernel_stack:1840kB pagetables:2176kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:3331648 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0
DMA: 42*64kB (MRC) 37*128kB (R) 6*256kB (R) 5*512kB (R) 2*1024kB (R) 3*2048kB (R) 1*4096kB (R) 0*8192kB 1*16384kB (R) 0*32768kB 0*65536kB 0*131072kB 1*262144kB (R) 0*524288kB = 302336kB
Normal: 280*64kB (MR) 40*128kB (R) 5*256kB (R) 4*512kB (R) 6*1024kB (R) 4*2048kB (R) 1*4096kB (R) 1*8192kB (R) 1*16384kB (R) 1*32768kB (R) 1*65536kB (R) 0*131072kB 0*262144kB 1*524288kB (R) = 691968kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=524288kB
4492 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
261888 pages RAM
0 pages HighMem/MovableOnly
18446744073709544450 pages reserved
8192 pages cma reserved

I also ran ps aux, but I didn't see any stale tasks lying around, nor
did any remaining tasks seem to account for all that active anonymous
memory.

I'll see if I can reproduce on x86.

Thanks,
Mark.
