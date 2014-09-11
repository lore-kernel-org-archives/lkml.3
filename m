Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaIKLtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbaIKLtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:49:08 -0400
Date: Thu, 11 Sep 2014 13:48:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf pollfd v3
Message-ID: <20140911114825.GC13634@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <20140911113336.GB13634@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911113336.GB13634@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:33:36PM +0200, Jiri Olsa wrote:

SNIP

> #20 0x0000000000465e72 in perf_evsel__free_fd (evsel=0x20af190) at util/evsel.c:786
> #21 perf_evsel__close (evsel=evsel@entry=0x20af190, ncpus=<optimized out>, nthreads=nthreads@entry=1) at util/evsel.c:1139
> #22 0x000000000045f77d in perf_evlist__close (evlist=0x20ae8b0) at util/evlist.c:1148
> #23 perf_evlist__delete (evlist=0x20ae8b0) at util/evlist.c:114
> #24 0x000000000042b878 in cmd_record (argc=<optimized out>, argv=<optimized out>, prefix=<optimized out>) at builtin-record.c:967
> #25 0x000000000041c455 in run_builtin (p=p@entry=0x815e70 <commands+144>, argc=argc@entry=2, argv=argv@entry=0x7fff5c077c50) at perf.c:331
> #26 0x000000000041bc70 in handle_internal_command (argv=0x7fff5c077c50, argc=2) at perf.c:390
> #27 run_argv (argv=0x7fff5c0779d0, argcp=0x7fff5c0779dc) at perf.c:434
> #28 main (argc=2, argv=0x7fff5c077c50) at perf.c:549

so the reason was that my fd lib stuff did not get rebuilt..

you probably want to add attached change, before there's the
fix for the apik library

jirka


---
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9ce194fc00a0..726a31a18125 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -769,7 +769,7 @@ $(LIBTRACEEVENT)-clean:
 install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
-LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch])
+LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch] $(LIB_PATH)fd/*.[ch])
 
 # if subdir is set, we've been called from above so target has been built
 # already
