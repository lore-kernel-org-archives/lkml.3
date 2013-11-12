Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3KLL5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:57:09 -0500
Received: from mail-gg0-f177.google.com ([209.85.161.177]:54662 "EHLO
	mail-gg0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3KLL5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:57:06 -0500
Date: Tue, 12 Nov 2013 08:57:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf trace: Fix segfault on perf trace -i perf.data
Message-ID: <20131112115700.GC4053@ghostprotocols.net>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
 <1384237500-22991-2-git-send-email-namhyung@kernel.org>
 <20131112114609.GB4053@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112114609.GB4053@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 12, 2013 at 08:46:09AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 12, 2013 at 03:25:00PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>

> > When replaying a previous record session, it'll get a segfault since
> > it doesn't initialize evsel->priv for finding syscall id.  So fix it
> > by initialize sys_enter/exit evsel manually.

> > While at it, factor out perf_evsel__init_syscall_tp() to init a
> > syscall evsel and remove unused perf_session__has_tp().

> Try to avoid these "while at it" to combine multiple patches into one
> :-)

> I'll try to do it for you this time as it fixes a real problem, thanks
> for fixing it!

So this becomes the first part of this patch, split from yours and
massaged a bit so that by looking at the patch it becomes quickly clear
what it is doing, please let me now if I can keep this as-is (with your
authorship, etc).

I'll test this all out after finishing the next part of the split up.

commit 296f6ce34590099740bfe03ced37f6f53a0133f8
Author: Namhyung Kim <namhyung@kernel.org>
Date:   Tue Nov 12 08:51:45 2013 -0300

    perf trace: Separate tp syscall field caching into init routine to be reused
    
    We need to set this in evsels coming out of a perf.data file header, not
    just for new ones created for live sessions.

    So separate the code that caches the syscall entry/exit tracepoint
    format fields into a new function that will be used in the next
    changeset.
    
    Signed-off-by: Namhyung Kim <namhyung@kernel.org>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Link: http://lkml.kernel.org/n/tip-iv4vbx2064hc2drv38egqzee@git.kernel.org
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index aeb6296a76bd..3fa1dce6d43e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -149,20 +149,32 @@ static void perf_evsel__delete_priv(struct perf_evsel *evsel)
 	perf_evsel__delete(evsel);
 }
 
+static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
+{
+	evsel->priv = malloc(sizeof(struct syscall_tp));
+	if (evsel->priv != NULL) {
+		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
+			goto out_delete;
+
+		evsel->handler = handler;
+		return 0;
+	}
+
+	return -ENOMEM;
+
+out_delete:
+	free(evsel->priv);
+	evsel->priv = NULL;
+	return -ENOENT;
+}
+
 static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
 {
 	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
 
 	if (evsel) {
-		evsel->priv = malloc(sizeof(struct syscall_tp));
-
-		if (evsel->priv == NULL)
+		if (perf_evsel__init_syscall_tp(evsel, handler))
 			goto out_delete;
-
-		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
-			goto out_delete;
-
-		evsel->handler = handler;
 	}
 
 	return evsel;
