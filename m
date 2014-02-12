Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBLRJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:09:22 -0500
Received: from ozlabs.org ([203.10.76.45]:45319 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaBLRJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:09:21 -0500
Date: Thu, 13 Feb 2014 04:09:13 +1100
From: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto
 alloc to symbol layer
Message-ID: <20140213040913.1c59cc45@kryten>
In-Reply-To: <20140213015017.12393bd4@kryten>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
	<1387566550-3524-7-git-send-email-acme@infradead.org>
	<20140212182316.44a10ca6@kryten>
	<20140212141837.GB7116@ghostprotocols.net>
	<20140213015017.12393bd4@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> > Can you try the following patch?
> > 
> > It should fix another problem, i.e. we were allocating, but
> > annotation would fail in the !TUI case, as it would return at
> > symbol__inc_addr_samples when use_browser != 1, now it will allocate
> > and mark the right bucket.
> > 
> > I'll have this in perf/urgent and will do the optimization of not
> > allocating those buckets in the report case when not doing
> > integrated annotation, i.e. report --stdio doesn't provide a way to
> > go to the annotation --stdio, so no point on allocating the
> > buckets. Just on 'annotate --stdio' we should allocate it, etc.
> 
> This fixes the issue, thanks!

After some more testing, perf report can SEGV with this patch:

Program received signal SIGSEGV, Segmentation fault.
__symbol__inc_addr_samples (addr=569128, evidx=0, notes=0x1023af80, map=0x10191ef0, sym=0x1023afb0) at util/annotate.c:477
477     util/annotate.c: No such file or directory.
(gdb) backtrace 
#0  __symbol__inc_addr_samples (addr=569128, evidx=0, notes=0x1023af80, map=0x10191ef0, sym=0x1023afb0) at util/annotate.c:477
#1  symbol__inc_addr_samples (addr=<optimised out>, evidx=<optimised out>, map=0x10191ef0, sym=0x1023afb0) at util/annotate.c:501
#2  hist_entry__inc_addr_samples (he=<optimised out>, evidx=<optimised out>, ip=569128) at util/annotate.c:511
#3  0x00000000100183b8 in report__add_hist_entry (sample=0x3fffffffd970, al=0x3fffffffd770, evsel=0x10190f10, tool=<optimised out>) at builtin-report.c:208
#4  process_sample_event (tool=<optimised out>, event=<optimised out>, sample=0x3fffffffd970, evsel=0x10190f10, machine=<optimised out>) at builtin-report.c:250
#5  0x000000001007eac8 in perf_session_deliver_event (session=0x10190330, event=<optimised out>, sample=<optimised out>, tool=<optimised out>, 
    file_offset=<optimised out>) at util/session.c:985
#6  0x000000001007f40c in flush_sample_queue (s=0x10190330, tool=0x3fffffffdf90) at util/session.c:505
#7  0x0000000010081064 in __perf_session__process_events (session=0x10190330, data_offset=<optimised out>, data_size=<optimised out>, file_size=331392, 
    tool=0x3fffffffdf90) at util/session.c:1355

(gdb) print notes->src
$3 = (struct annotated_source *) 0x51

Anton
