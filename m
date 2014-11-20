Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbaKTUgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:36:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:56980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbaKTUgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:36:31 -0500
Date: Thu, 20 Nov 2014 17:36:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141120203624.GM3790@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
 <20141119092323.GC2592@krava.brq.redhat.com>
 <20141119105450.GA22132@krava.brq.redhat.com>
 <20141119141027.GF3790@kernel.org>
 <20141119215041.GN12538@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119215041.GN12538@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 19, 2014 at 10:50:41PM +0100, Andi Kleen escreveu:
> > Segmentation fault (core dumped)
> > [root@zoo ~]#
> > 
> > Rebuilding with DEBUG=1 I get this backtrace:
> 
> Ok it crashes inside libbfd while resolving the line. 
> Not much I can do about it. 

> Could file a bug with the binutils people, if you have a test case?

The file I have is:

  [root@zoo ~]# perf report --stdio --header-only
  # ========
  # captured on: Tue Nov 18 17:42:26 2014
  # hostname : zoo.ghostprotocols.net
  # os release : 3.17.2-200.fc20.x86_64
  # perf version : 3.18.rc1.g5a0227
  # arch : x86_64
  # nrcpus online : 4
  # nrcpus avail : 4
  # cpudesc : Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz
  # cpuid : GenuineIntel,6,58,9
  # total memory : 8080676 kB
  # cmdline : /home/acme/bin/perf record -a -g 
  # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 1, attr_mmap  = 1, attr_mmap_data = 0
  # HEADER_CPU_TOPOLOGY info available, use -I to display
  # HEADER_NUMA_TOPOLOGY info available, use -I to display
  # pmu mappings: cpu = 4, software = 1, power = 9, uncore_imc = 8, tracepoint = 2, uncore_cbox_0 = 6, uncore_cbox_1 = 7, breakpoint = 5
  # ========
  #
  [root@zoo ~]#

So the command line used was:

  perf record -a -g

And the perf tool was one built when HEAD was:

  [acme@zoo linux]$ git show 5a0227
   commit 5a0227c085cbee8af4ce228da80a99cdc124329e
  Author: Andi Kleen <ak@linux.intel.com>
  Date:   Mon Nov 17 17:58:54 2014 -0800

      perf report: In branch stack mode use address history sorting

  Which, due to rebases, in my perf/branch-history is:

  commit aef48d981d85f996a47715d44111220843999a4e
  Author: Andi Kleen <ak@linux.intel.com>
  Date:   Mon Nov 17 17:58:54 2014 -0800

      perf report: In branch stack mode use address history sorting

So let me try to reproduce it again...

Yeah, reproduced, so, what lead me to send this report to you was:

1. yes, it has -g in the 'perf record' command line generating the perf.data file
   that when fed to perf report --branch-history causes a segfault
2. no, it doesn't have -b, so, it ends up with PERF_SAMPLE_BRANCH_STACK:

   [root@zoo ~]# perf evlist -v
   cycles: sample_freq=4000, size: 104,
   sample_type: IP|TID|TIME|CALLCHAIN|CPU|PERIOD, disabled: 1,
   inherit: 1, mmap: 1, mmap2: 1, comm: 1, comm_exec: 1,
   freq: 1, sample_id_all: 1, exclude_guest: 1
   [root@zoo ~]#

3. When I then pass it to 'perf report' telling that I want --branch-history,
   it segfaults

What I thought this patch should do is to check if the perf.data sample_type has
PERF_SAMPLE_BRANCH_STACK and if not, tell the user that such mode can't be chosen
since there is no branch stack.

This is all without looking at the code to see what kind of data is being fed to
libbfd, I fear it is bogus data that will then cause that segfault, no?

If I add that '-b' to the 'perf record -a -g'  command line, I get:

  [root@zoo ~]# perf record -a -g -b
  ^C[ perf record: Woken up 3 times to write data ]
  [ perf record: Captured and wrote 2.422 MB perf.data (~105832 samples) ]

  [root@zoo ~]# perf evlist -v
  cycles: sample_freq=4000, size: 104,
  sample_type: IP|TID|TIME|CALLCHAIN|CPU|PERIOD|BRANCH_STACK, disabled: 1,
  inherit: 1, mmap: 1, mmap2: 1, comm: 1, comm_exec: 1, freq: 1,
  sample_id_all: 1, exclude_guest: 1, branch_sample_type: 8
  [root@zoo ~]#

And then, specifying --branch-history to perf report is no problem it is happy
finding whatever info it needs to properly spoon into libbfd...

No, that is not the case, when I passed the above perf.data to 'perf report
--stdio --branch-history' it happily exploded with double frees and segfaults...

So please try, as root:

  perf record -a -g -b

then interrupt with control+C and try:

  perf report --stdio --branch-history

On my perf/branch-history branch.

- Arnaldo
 
> > 
> > Using host libthread_db library "/lib64/libthread_db.so.1".
> > Core was generated by `perf report --stdio --no-children --branch-history'.
> > Program terminated with signal SIGSEGV, Segmentation fault.
> > #0  0x000000000053ab10 in read_unsigned_leb128 ()
> > Missing separate debuginfos, use: debuginfo-install bzip2-libs-1.0.6-9.fc20.x86_64 elfutils-libelf-0.160-1.fc20.x86_64 elfutils-libs-0.160-1.fc20.x86_64 libunwind-1.1-3.fc20.x86_64 nss-softokn-freebl-3.17.2-1.fc20.x86_64 numactl-libs-2.0.9-2.fc20.x86_64 slang-2.2.4-11.fc20.x86_64 xz-libs-5.1.2-12alpha.fc20.x86_64
> > (gdb) bt
> > #0  0x000000000053ab10 in read_unsigned_leb128 ()
> > #1  0x00000000005485d7 in find_abstract_instance_name.isra ()
> > #2  0x0000000000548756 in find_abstract_instance_name.isra ()
> > #3  0x0000000000548756 in find_abstract_instance_name.isra ()
> > #4  0x0000000000548d31 in scan_unit_for_symbols ()
> > #5  0x00000000005496c9 in comp_unit_find_nearest_line ()
> > #6  0x000000000054a6ca in find_line.part ()
> > #7  0x00000000005606ca in _bfd_elf_find_nearest_line_discriminator ()
> > #8  0x00000000005607db in _bfd_elf_find_nearest_line ()
> > #9  0x00000000004dabf1 in find_address_in_section (abfd=0xfd522f0, section=0xe8be528, data=0xfa50c30) at util/srcline.c:100
> > #10 0x000000000053cbdc in bfd_map_over_sections ()
> > #11 0x00000000004dae84 in addr2line (dso_name=0xe89fe70 "/usr/lib/debug/usr/lib64/firefox/libxul.so.debug", addr=24667432, file=0x7fff3981f9c0, line=0x7fff3981f9bc, dso=0x22a0b50) at util/srcline.c:168
> > #12 0x00000000004db017 in get_srcline (dso=0x22a0b50, addr=24667432, sym=0xf6b93f0, show_sym=true) at util/srcline.c:276
