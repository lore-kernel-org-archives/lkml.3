Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaBZRsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:48:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaBZRsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:48:07 -0500
Date: Wed, 26 Feb 2014 18:47:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: Do not compile with -fstrict-aliasing
Message-ID: <20140226174725.GB14467@krava.brq.redhat.com>
References: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
 <20140226171805.GC22802@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140226171805.GC22802@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:18:05PM +0100, Peter Zijlstra wrote:
> On Wed, Feb 26, 2014 at 06:14:26PM +0100, Jiri Olsa wrote:
> > hi,
> > got issue below when compiling perf tool on i686 with gcc 4.4,
> > but not sure the patch is correct workaround here.
> > 
> > thanks for comments,
> > jirka
> > 
> > 
> > ---
> > When compiling perf tool code with gcc 4.4.7 I'm getting
> > following error:
> > 
> >   CC       util/session.o
> > cc1: warnings being treated as errors
> > util/session.c: In function ‘perf_session_deliver_event’:
> > /root/linux/tools/perf/util/include/linux/bitops.h:109: error: dereferencing pointer ‘p’ does break strict-aliasing rules
> > /root/linux/tools/perf/util/include/linux/bitops.h:101: error: dereferencing pointer ‘p’ does break strict-aliasing rules
> > util/session.c:697: note: initialized from here
> > /root/linux/tools/perf/util/include/linux/bitops.h:101: note: initialized from here
> > make[1]: *** [util/session.o] Error 1
> > make: *** [util/session.o] Error 2
> > 
> > The aliased types here are u64 and unsigned long pointers,
> > which is safe for the find_first_bit processing.
> > 
> > This error shows up for me only for gcc 4.4 on 32bit x86,
> > even for -Wstrict-aliasing=3, while newer gcc are quiet
> > and scream here for -Wstrict-aliasing={2,1}. Looks like
> > newer gcc changed the rules for strict alias warnings.
> > 
> > The gcc documentation offers workaround for valid
> > aliasing by using __may_alias__ attribute:
> >   http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html
> > 
> 
> The kernel builds with -fno-strict-aliasing because the C aliasing rules
> are a bunch of monkey poo. Perf tool should probably do the same.

my pleasure ;-)

thanks,
jirka


---
Switching off the strict aliasing for perf tool compilation,
because it causes compilation issues/errors for older gcc,
and to quote Peter:
  "C aliasing rules are a bunch of monkey poo"

We don't enable strict aliasing actively, it is forced by
-Ox option. Using -fno-strict-aliasing option at the same
time we use -O.

Removing -Wstrict-aliasing=3 option as well.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/Makefile     | 2 +-
 tools/scripts/Makefile.include | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f7c81d3..e7786c7 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -94,7 +94,7 @@ ifndef DEBUG
 endif
 
 ifeq ($(DEBUG),0)
-  CFLAGS += -O6
+  CFLAGS += -O6 -fno-strict-aliasing
 endif
 
 ifdef PARSER_DEBUG
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 8abbef1..3667b5b 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wold-style-definition
 EXTRA_WARNINGS += -Wpacked
 EXTRA_WARNINGS += -Wredundant-decls
 EXTRA_WARNINGS += -Wshadow
-EXTRA_WARNINGS += -Wstrict-aliasing=3
 EXTRA_WARNINGS += -Wstrict-prototypes
 EXTRA_WARNINGS += -Wswitch-default
 EXTRA_WARNINGS += -Wswitch-enum
-- 
1.8.3.1
