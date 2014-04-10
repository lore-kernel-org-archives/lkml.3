Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614AbaDJI04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965170AbaDJI0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:26:54 -0400
Date: Thu, 10 Apr 2014 10:26:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [BUG] perf: double free in perf test 21 (code-reading.c)
Message-ID: <20140410082648.GB1141@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
the alternative setup (when perf_evlist__open fails) calls
perf_evlist__delete which releases cpu_maps. And that is
not expected byt the test so it segfaults.

Using perf_event_max_sample_rate setup to hit the alternative setup.

thanks,
jirka

[root@krava perf]# echo 1000 > /proc/sys/kernel/perf_event_max_sample_rate
[root@krava perf]# ./perf test 21
21: Test object code reading                               :Segmentation fault
[root@krava perf]# gdb ./perf
GNU gdb (GDB) Fedora (7.3.1-47.fc15)
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i686-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /home/jolsa/linux-perf/tools/perf/perf...done.
(gdb) r test 21
Starting program: /home/jolsa/linux-perf/tools/perf/perf test 21
[Thread debugging using libthread_db enabled]
21: Test object code reading                               :
Program received signal SIGSEGV, Segmentation fault.
0x080907db in __perf_evlist__munmap (idx=14700, evlist=<optimized out>) at util/evlist.c:583
583                     evlist->mmap[idx].base = NULL;
Missing separate debuginfos, use: debuginfo-install bzip2-libs-1.0.6-3.fc15.i686 elfutils-libelf-0.152-1.fc15.i686 elfutils-libs-0.152-1.fc15.i686 glibc-2.14.1-6.i686 libgcc-4.6.3-2.fc15.i686 libunwind-0.99-0.16.20090430betagit4b8404d1.fc15.i686 python-libs-2.7.1-7.fc15.i686 slang-2.2.3-2.fc15.i686 xz-libs-5.0.3-1.fc15.i686 zlib-1.2.5-6.fc15.i686
(gdb) bt
#0  0x080907db in __perf_evlist__munmap (idx=14700, evlist=<optimized out>) at util/evlist.c:583
#1  perf_evlist__munmap (evlist=0x82e7c18) at util/evlist.c:595
#2  perf_evlist__delete (evlist=0x82e7c18) at util/evlist.c:110
#3  0x080f3909 in do_test_code_reading (try_kcore=false) at tests/code-reading.c:543
#4  0x080f3d46 in test__code_reading () at tests/code-reading.c:559
#5  0x08087232 in __cmd_test (skiplist=0x0, argv=0xbffff5f8, argc=1) at tests/builtin-test.c:187
#6  cmd_test (argc=1, argv=0xbffff5f8, prefix=0x0) at tests/builtin-test.c:252
#7  0x0805c8de in run_builtin (p=0x821bf10, argc=2, argv=0xbffff5f8) at perf.c:319
#8  0x0805c127 in handle_internal_command (argv=0xbffff5f8, argc=2) at perf.c:376
#9  run_argv (argv=0xbffff498, argcp=0xbffff49c) at perf.c:420
#10 main (argc=2, argv=0xbffff5f8) at perf.c:529
(gdb) 
