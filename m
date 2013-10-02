Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3JBNkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:40:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3JBNkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:40:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="404229055"
Message-ID: <524C23D3.6020300@intel.com>
Date: Wed, 02 Oct 2013 16:46:59 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
References: <20131002132308.GB20396@krava.brq.redhat.com>
In-Reply-To: <20131002132308.GB20396@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/13 16:23, Jiri Olsa wrote:
> hi,
> got a segfault in the tsc test on latest acme's tree.
> 
> I'm dealing with some other issues right now, so just reporting ;-)

The capability bits have changed positions.  You need to have:

commit fa7315871046b9a4c48627905691dbde57e51033
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Sep 19 10:16:42 2013 +0200

    perf: Fix capabilities bitfield compatibility in 'struct
perf_event_mmap_page'

in both (or neither) of your kernel and perf tools.

> 
> thanks,
> jirka
> 
> (gdb) r test 20
> Starting program: /home/jolsa/linux-perf/tools/perf/perf test 20
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> 20: Test converting perf time to TSC                       :
> Program received signal SIGFPE, Arithmetic exception.
> 0x00000000004cee73 in perf_time_to_tsc (ns=1460625577603, tc=0x7fffffffdf50) at arch/x86/util/tsc.c:16
> 16              quot = t / tc->time_mult;
> Missing separate debuginfos, use: debuginfo-install audit-libs-2.2.1-1.fc16.x86_64 elfutils-libelf-0.154-2.fc16.x86_64 elfutils-libs-0.154-2.fc16.x86_64 glibc-2.14.90-24.fc16.9.x86_64 nss-softokn-freebl-3.14.1-3.fc16.x86_64 numactl-2.0.7-2.fc16.x86_64 perl-libs-5.14.3-205.fc16.x86_64 python-libs-2.7.3-4.fc16.x86_64 slang-2.2.4-1.fc16.x86_64 xz-libs-5.1.1-1alpha.fc16.x86_64 zlib-1.2.5-7.fc16.x86_64
> (gdb) bt
> #0  0x00000000004cee73 in perf_time_to_tsc (ns=1460625577603, tc=0x7fffffffdf50) at arch/x86/util/tsc.c:16
> #1  0x00000000004cbdb8 in test__perf_time_to_tsc () at tests/perf-time-to-tsc.c:144
> #2  0x00000000004491b7 in __cmd_test (argc=1, argv=0x7fffffffe400, skiplist=0x0) at tests/builtin-test.c:175
> #3  0x0000000000449512 in cmd_test (argc=1, argv=0x7fffffffe400, prefix=0x0) at tests/builtin-test.c:240
> #4  0x0000000000418dfd in run_builtin (p=0x802500, argc=2, argv=0x7fffffffe400) at perf.c:319
> #5  0x0000000000419035 in handle_internal_command (argc=2, argv=0x7fffffffe400) at perf.c:376
> #6  0x0000000000419181 in run_argv (argcp=0x7fffffffe2dc, argv=0x7fffffffe2d0) at perf.c:420
> #7  0x0000000000419468 in main (argc=2, argv=0x7fffffffe400) at perf.c:529
> (gdb) p tc->time_mult
> $1 = 0
> 
> 

