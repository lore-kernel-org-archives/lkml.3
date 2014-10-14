Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaJNJKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaJNJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:10:35 -0400
Date: Tue, 14 Oct 2014 11:09:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>, Douglas Hatch <doug.hatch@hp.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 6/8] perf symbols: Improve DSO long names lookup speed
 with rbtree
Message-ID: <20141014090958.GC5459@krava.redhat.com>
References: <1412193043-15493-1-git-send-email-acme@kernel.org>
 <1412193043-15493-7-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412193043-15493-7-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 04:50:41PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Waiman Long <Waiman.Long@hp.com>
> 
> With workload that spawns and destroys many threads and processes, it
> was found that perf-mem could took a long time to post-process the perf
> data after the target workload had completed its operation.
> 
> The performance bottleneck was found to be the lookup and insertion of
> the new DSO structures (thousands of them in this case).

this change segfaults (below) some tests, but only if I compiled
without DEBUG when I revert this commit, I can no longer reproduce..

jirka

(gdb) set follow-fork-mode child
(gdb) r test 31
Starting program: /home/jolsa/kernel.org/linux-perf/tools/perf/perf test 31
warning: section  not found in /usr/lib/debug/lib/modules/3.16.3-200.fc20.x86_64/vdso/vdso64.so.debug
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
31: Test output sorting of hist entries                    :[New process 15477]
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff7b9d7c0 (LWP 15477)]
__strcmp_ssse3 () at ../sysdeps/x86_64/strcmp.S:210
210             movlpd  (%rsi), %xmm2
(gdb) bt
#0  __strcmp_ssse3 () at ../sysdeps/x86_64/strcmp.S:210
#1  0x0000000000477967 in dso__findlink_by_longname (name=<optimized out>, dso=0x0, root=0x7fffffffdbf0)
    at util/dso.c:674
#2  dso__find_by_longname (name=0x7fffffffcae8 "perf", root=0x7fffffffdbf0) at util/dso.c:712
#3  dsos__find (cmp_short=false, name=0x7fffffffcae8 "perf", dsos=0x7fffffffdbe0) at util/dso.c:935
#4  __dsos__findnew (dsos=dsos@entry=0x7fffffffdbe0, name=name@entry=0x7fffffffcae8 "perf") at util/dso.c:940
#5  0x00000000004915d9 in map__new (machine=machine@entry=0x7fffffffdb90, start=4194304, len=1048576, pgoff=0, 
    pid=<optimized out>, d_maj=d_maj@entry=0, d_min=d_min@entry=0, ino=ino@entry=0, ino_gen=ino_gen@entry=0, 
    prot=prot@entry=0, flags=flags@entry=0, filename=filename@entry=0x7fffffffcae8 "perf", type=MAP__FUNCTION, 
    thread=thread@entry=0x90d1f0) at util/map.c:180
#6  0x00000000004900f4 in machine__process_mmap_event (machine=machine@entry=0x7fffffffdb90, 
    event=event@entry=0x7fffffffcac0, sample=sample@entry=0x0) at util/machine.c:1182
#7  0x00000000004d12bb in setup_fake_machine (machines=machines@entry=0x7fffffffdb90)
    at tests/hists_common.c:116
#8  0x00000000004d4478 in test__hists_output () at tests/hists_output.c:600
#9  0x0000000000448fe4 in run_test (test=0x8166a0 <tests+480>) at tests/builtin-test.c:210
#10 __cmd_test (skiplist=0x0, argv=0x7fffffffe2d0, argc=1) at tests/builtin-test.c:255
#11 cmd_test (argc=1, argv=0x7fffffffe2d0, prefix=<optimized out>) at tests/builtin-test.c:320
#12 0x000000000041c8f5 in run_builtin (p=p@entry=0x814fc0 <commands+480>, argc=argc@entry=2, 
    argv=argv@entry=0x7fffffffe2d0) at perf.c:331
#13 0x000000000041c110 in handle_internal_command (argv=0x7fffffffe2d0, argc=2) at perf.c:390
#14 run_argv (argv=0x7fffffffe050, argcp=0x7fffffffe05c) at perf.c:434
#15 main (argc=2, argv=0x7fffffffe2d0) at perf.c:549
(gdb) 
