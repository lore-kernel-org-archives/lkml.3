Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3K0PLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:11:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3K0PLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:11:13 -0500
Date: Wed, 27 Nov 2013 16:10:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 21/22] perf tools: Add trace-event global object for
 tracepoint interface
Message-ID: <20131127151045.GE1208@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-22-git-send-email-jolsa@redhat.com>
 <1385135234.1747.122.camel@leonhard>
 <20131125160345.GJ3161@krava.brq.redhat.com>
 <1385559960.1685.2.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385559960.1685.2.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:46:00PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2013-11-25 (월), 17:03 +0100, Jiri Olsa:
> > On Sat, Nov 23, 2013 at 12:47:14AM +0900, Namhyung Kim wrote:
> > > 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> > > > In order to get the proper plugins processing we need to
> > > > use full trace-event interface when creating tracepoint
> > > > events. So far we were using shortcut to get the parsed
> > > > format.
> > > > 
> > > > Moving current 'event_format__new' function into trace-event
> > > > object as 'trace_event__tp_format'.
> > > > 
> > > > This function uses properly initialized global trace-event
> > > > object, ensuring proper plugins processing.
> > > 
> > > I see this when I compile it on my old ubuntu 10.04 box (with gcc 4.4.3)
> > > 
> > >   CC       util/trace-event.o
> > > cc1: warnings being treated as errors
> > > util/trace-event.c: In function 'trace_event__tp_format':
> > > util/trace-event.c:63: error: not protecting function: no buffer at
> > > least 8 bytes long
> > > make[1]: *** [util/trace-event.o] Error 1
> > 
> > hum, what was the stackprotector status?
> > 
> > ...                stackprotector: [ on  ]
> > ...            stackprotector-all: [ on  ]
> 
> Right. Both of them were turned on.
> 
> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ on  ]
> ...                fortify-source: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                  gtk2-infobar: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...             libelf-getphdrnum: [ OFF ]
> ...                   libelf-mmap: [ on  ]
> ...                       libnuma: [ OFF ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...             libpython-version: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ OFF ]
> ...                       on-exit: [ on  ]
> ...                stackprotector: [ on  ]
> ...            stackprotector-all: [ on  ]
> ...                       timerfd: [ on  ]

I found that -fstack-protector might not always work:
https://bugs.launchpad.net/ubuntu/+source/gcc-4.5/+bug/691722

they say it was fixed in gcc 4.5.0 which I was not
able to prove in gcc release notes..

we could disable the warning like in the below
for gcc < 4.5.0, could you please test?

any other idea? ;-)

thanks,
jirka

---
diff --git a/tools/perf/config/feature-checks/test-stackprotector.c b/tools/perf/config/feature-checks/test-stackprotector.c
index c9f398d..c0ace8b 100644
--- a/tools/perf/config/feature-checks/test-stackprotector.c
+++ b/tools/perf/config/feature-checks/test-stackprotector.c
@@ -1,5 +1,13 @@
 #include <stdio.h>
 
+#define GCC_VERSION (__GNUC__ * 10000 \
+		+ __GNUC_MINOR__ * 100 \
+		+ __GNUC_PATCHLEVEL__)
+
+#if GCC_VERSION < 40500
+#error "failed"
+#endif
+
 int main(void)
 {
 	return puts("hi");
