Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3IKP2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:28:49 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:51254 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3IKP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:28:48 -0400
Date: Wed, 11 Sep 2013 12:28:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130911152841.GA1860@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
 <20130910130002.GD28428@ghostprotocols.net>
 <CABPqkBRgj71D8FkWtR-4K8g5ErWMt8YsV7FcmxQ3Uouj640Z0A@mail.gmail.com>
 <20130910131728.GE28428@ghostprotocols.net>
 <20130910195847.GA1866@ghostprotocols.net>
 <20130910201637.GB1866@ghostprotocols.net>
 <CABPqkBQvo9r5ArPKFBOyMap2LK+8mR5anMiCtvjL-WUmxJ3qgg@mail.gmail.com>
 <20130911145341.GF1866@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911145341.GF1866@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 11, 2013 at 11:53:41AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Sep 11, 2013 at 04:42:57PM +0200, Stephane Eranian escreveu:
> > Do you have all those changes in a git tree somewhere.
> > I want to help test and debug this part too.
> > Thanks.
 
> Right now its all in my perf/urgent branch at:
 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git

And these are the results on a kernel that has the PERF_RECORD_MMAP2
functionality, for a workload started from 'perf record' and for an
existing process, so that we can check the synthesizing code:

[root@zoo ~]# perf record usleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.014 MB perf.data (~615 samples) ]

Now lets check the events details, just cycles, in this case, use more
if you want to check that just the first one has mmap2 set:

[root@zoo ~]# perf evlist -v
cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|PERIOD,
disabled: 1, inherit: 1, mmap: 1, mmap2: 1, comm: 1, freq: 1,
enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
[root@zoo ~]# 

Now lets see if MMAP2 records were produced:

[root@zoo ~]# perf report -D | grep PERF_RECORD_MMAP2
776650444880 0x3838 [0x60]: PERF_RECORD_MMAP2 2918/2918: [0x400000(0x2000) @ 0 08:07 655426 1850659034]: /usr/bin/usleep
776650454592 0x3898 [0x68]: PERF_RECORD_MMAP2 2918/2918: [0x33c1200000(0x223000) @ 0 08:07 656485 1850658205]: /usr/lib64/ld-2.16.so
776650465705 0x3900 [0x58]: PERF_RECORD_MMAP2 2918/2918: [0x7fffbc72d000(0x1000) @ 0x7fffbc72d000 00:00 0 0]: [vdso]
776650549828 0x3980 [0x70]: PERF_RECORD_MMAP2 2918/2918: [0x33d2a00000(0x20a000) @ 0 08:07 655569 1850658370]: /usr/lib64/libpopt.so.0.0.0
776650577550 0x39f0 [0x68]: PERF_RECORD_MMAP2 2918/2918: [0x33c1600000(0x3b8000) @ 0 08:07 661541 1850658206]: /usr/lib64/libc-2.16.so
[root@zoo ~]# 

Yeah, for all the userspace DSOs, the kernel modules and vmlinux
remained as MMAP records:

[root@zoo ~]# perf report -D | grep -w PERF_RECORD_MMAP | head -4
0 0xd8 [0x50]: PERF_RECORD_MMAP -1/0: [0(0xffffffff9fffffff) @ 0xffffffff81000000]: [kernel.kallsyms]_text
0 0x128 [0x70]: PERF_RECORD_MMAP -1/0: [0xffffffffa0000000(0x5fff) @ 0]: /lib/modules/3.11.0+/kernel/drivers/acpi/video.ko
0 0x198 [0x70]: PERF_RECORD_MMAP -1/0: [0xffffffffa0006000(0x5fff) @ 0]: /lib/modules/3.11.0+/kernel/fs/efivarfs/efivarfs.ko
0 0x208 [0x70]: PERF_RECORD_MMAP -1/0: [0xffffffffa000c000(0xafff) @ 0]: /lib/modules/3.11.0+/kernel/drivers/i2c/i2c-core.ko
[root@zoo ~]# 

[root@zoo ~]# perf report -D | grep PERF_RECORD_MMAP | cut -f 4 -d' ' | sort | uniq -c
    119 PERF_RECORD_MMAP
      5 PERF_RECORD_MMAP2
[root@zoo ~]

[root@zoo ~]# lsmod | grep -v '^Module.*Size.*Used by$' | wc -l
118
[root@zoo ~]# 

I.e. 118 (yeah, distros load a lot of those these days!) plus vmlinux.

And if we observe an existing thread, say the current shell interpreter:

[acme@zoo linux]$ perf record -e instructions,cycles -p 1878 usleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.014 MB perf.data (~615 samples) ]
[acme@zoo linux]$ perf evlist -v
instructions: sample_freq=4000, config: 1, size: 96, sample_type: IP|TID|ID|PERIOD, read_format: ID, disabled: 1, mmap: 1, mmap2: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
cycles: sample_freq=4000, size: 96, sample_type: IP|TID|ID|PERIOD, read_format: ID, disabled: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
[acme@zoo linux]$ 

Used two to check that the second event has no mmap2 bit set, just like for
mmap, comm, etc.

[acme@zoo linux]$ perf report -D | grep PERF_RECORD_MMAP2
0x37c8 [0x60]: PERF_RECORD_MMAP2 1878/1878: [0x400000(0xda000) @ 0 08:07 662168 0]: /usr/bin/bash
0x3828 [0x68]: PERF_RECORD_MMAP2 1878/1878: [0x33c1200000(0x20000) @ 0 08:07 656485 0]: /usr/lib64/ld-2.16.so
0x3890 [0x68]: PERF_RECORD_MMAP2 1878/1878: [0x33c1600000(0x1ad000) @ 0 08:07 661541 0]: /usr/lib64/libc-2.16.so
0x38f8 [0x70]: PERF_RECORD_MMAP2 1878/1878: [0x33c1e00000(0x3000) @ 0 08:07 671656 0]: /usr/lib64/libdl-2.16.so
0x3968 [0x70]: PERF_RECORD_MMAP2 1878/1878: [0x33d9200000(0x25000) @ 0 08:07 675312 0]: /usr/lib64/libtinfo.so.5.9
0x39d8 [0x70]: PERF_RECORD_MMAP2 1878/1878: [0x7f2f70bb9000(0xc000) @ 0 08:07 662885 0]: /usr/lib64/libnss_files-2.16.so
0x3a48 [0x58]: PERF_RECORD_MMAP2 1878/1878: [0x7fffdb5ff000(0x1000) @ 0 00:00 0 0]: [vdso]
0x3aa0 [0x60]: PERF_RECORD_MMAP2 1878/1878: [0xffffffffff600000(0x1000) @ 0 00:00 0 0]: [vsyscall]
[acme@zoo linux]$

Now lets look at the exec maps for this existing thread, to check that
we rightly synthesized them:

[acme@zoo linux]$ grep xp /proc/1878/maps
00400000-004da000 r-xp 00000000 08:07 662168                             /usr/bin/bash
33c1200000-33c1220000 r-xp 00000000 08:07 656485                         /usr/lib64/ld-2.16.so
33c1600000-33c17ad000 r-xp 00000000 08:07 661541                         /usr/lib64/libc-2.16.so
33c1e00000-33c1e03000 r-xp 00000000 08:07 671656                         /usr/lib64/libdl-2.16.so
33d9200000-33d9225000 r-xp 00000000 08:07 675312                         /usr/lib64/libtinfo.so.5.9
7f2f70bb9000-7f2f70bc5000 r-xp 00000000 08:07 662885                     /usr/lib64/libnss_files-2.16.so
7fffdb5ff000-7fffdb600000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
[acme@zoo linux]$

Yeah, maj, min, inode seems all ok, i_generation is zero, as expected.

Now its just a matter of using this extra info in a tool! 8-)

I haven't performed all these tests when running on an older kernel, just checked that
PERF_RECORD_MMAP was present, PERF_RECORD_MMAP2, as expected, were not, probably they
will be present only for the synthesized events, right? The ones coming from the kernel
were all PERF_RECORD_MMAP, as expected.

- Arnaldo
