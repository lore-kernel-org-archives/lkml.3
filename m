Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaIHPAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaIHPAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:00:21 -0400
Date: Mon, 8 Sep 2014 16:31:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: Do not check PERF_EVENT_STATE_EXIT on syscall read path
Message-ID: <20140908143107.GG17728@krava.brq.redhat.com>
References: <CABPqkBRREcix0TtLLUgiq8uabUqG=m2un79WKLqPXF=LccSQbw@mail.gmail.com>
 <20140908124945.GD17728@krava.brq.redhat.com>
 <CABPqkBRPWh+=CfXBYaYW=P6FJke3KB-7y-U1ky8JAKjDY3JaEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRPWh+=CfXBYaYW=P6FJke3KB-7y-U1ky8JAKjDY3JaEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:21:12PM +0200, Stephane Eranian wrote:
> On Mon, Sep 8, 2014 at 2:49 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Sep 08, 2014 at 02:35:06PM +0200, Stephane Eranian wrote:
> > > Hi,
> > >
> > > It seems something is seriously broken with perf_events in
> > > 3.17-rcX. I have tried rc3, rc4. No way to get any counts
> > > out using perf stat in per-process mode. I am trying on Intel
> > > and the PMU is correctly detected:
> > >
> > > $ perf stat -e cycles ls
> > >       <not counted> cycles
> > >
> > > It is not a permission problem. It is a read problem!
> > > $ strace perf stat -e cycles ls
> > >
> > > perf_event_open(0x27d7e20, 2261, -1, -1, 0x8 /* PERF_FLAG_??? */) = 3
> > > write(6, "\0", 1)                       = 1
> > > close(6)                                = 0
> > > wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 2261
> > > --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=2261,
> > > si_status=0, si_utime=0, si_stime=0} ---
> > > rt_sigreturn()                          = 2261
> > > read(3, "", 24)                         = 0
> > >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > ouch thats me.. sry :-\
> >
> > the PERF_EVENT_STATE_EXIT check should not go to the
> > read path.. could you please test attached patch?
> >
> > jirka
> >
> Works for me again now. Thanks for the quick fix. Please push it upstream.
> 
> Acked-by: Stephane Eranian <eranian@google.com>

attached, thanks
jirka


---
Revert PERF_EVENT_STATE_EXIT check on read syscall path.
It breaks standard way to read counter, which is to open
the counter, wait for the monitored process to die and
read the counter.

Reported-by: Stephane Eranian <eranian@google.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8cb4d21a346..6d1c9ce1643e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3600,8 +3600,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	 * error state (i.e. because it was pinned but it couldn't be
 	 * scheduled on to the CPU at some point).
 	 */
-	if ((event->state == PERF_EVENT_STATE_ERROR) ||
-	    (event->state == PERF_EVENT_STATE_EXIT))
+	if (event->state == PERF_EVENT_STATE_ERROR)
 		return 0;
 
 	if (count < event->read_size)
-- 
1.8.3.1

