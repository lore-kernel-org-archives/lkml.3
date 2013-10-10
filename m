Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3JJFnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:43:11 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:53284 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3JJFnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:43:00 -0400
Date: Thu, 10 Oct 2013 07:42:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools/perf/build: Fix redirection printouts
Message-ID: <20131010054256.GA23716@gmail.com>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131009191626.GD28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009191626.GD28369@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> So while merging what I have in my perf/core branch I got to Vitillo's, as
> peterz called it, "inlining" of addr2line, i.e. using libbfd to do that work,
> it will look if lbfd is in EXTLIBS and if so, use it, otherwise we continue
> exec'in the addr2line tool.
> 
> Since this appears when doing the feature check:
> 
> ...                        libbfd: [ on  ]
> 
> I wanted to build just one object file that is related to this:
> 
> [acme@sandy linux]$ ls -la /tmp/build/perf/util/util/srcline.o
> ls: cannot access /tmp/build/perf/util/util/srcline.o: No such file or directory
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.c 
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.*
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$ make V=1 O=/tmp/build/perf -C tools/perf/ util/srcline.o
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
>     # Redirected target util/srcline.o => /tmp/build/perf/util/util/srcline.o
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$ 
> [acme@sandy linux]$ ls -la /tmp/build/perf/util/util/srcline.o
> ls: cannot access /tmp/build/perf/util/util/srcline.o: No such file or directory
> [acme@sandy linux]$ make V=1 O=/tmp/build/perf -C tools/perf/ /tmp/build/perf/util/util/srcline.o
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
> make[1]: *** No rule to make target `/tmp/build/perf/util/util/srcline.o'.  Stop.
> make: *** [/tmp/build/perf/util/util/srcline.o] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@sandy linux]$ ls -la tools/perf/util/srcline.*
> -rw-rw-r--. 1 acme acme 1777 Oct  9 16:06 tools/perf/util/srcline.c
> [acme@sandy linux]$
> 
> 	What am I doing wrong here while trying to build just one .o file?
> 
> 	Back to checking why it is not using the 'inline' addr2line...
> 
> - Arnaldo

There's two things that I can see here.

1)

The printout is a bit off, duplicating util/util. The fix below should 
help with that.

2)

This issue is more difficult: if tools/perf/util/srcline.o exists, then 
the redirection will not happen and make just says:

 comet:~/tip/tools/perf> rm -f /tmp/build/perf/util/pager.o
 comet:~/tip/tools/perf> make O=/tmp/build/perf/ util/pager.o
 make: `util/pager.o' is up to date.

 comet:~/tip/tools/perf> ll /tmp/build/perf/util/pager.o
 ls: cannot access /tmp/build/perf/util/pager.o: No such file or directory
 comet:~/tip/tools/perf> ll util/pager.o
 -rw-rw-r-- 1 mingo mingo 297488 Oct 10 07:34 util/pager.o

So the redirection quirks will only work in a clean tree. I think that 
should be fine - people who build via O= generally do it to keep their 
source trees clean.

Thanks,

	Ingo

======================>
>From 881641d16f8445d8796c3b437cb33d6467af98b7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 10 Oct 2013 07:36:52 +0200
Subject: [PATCH] tools/perf/bench: Fix redirection printouts

Fix the duplicate util/util printout Arnaldo reported:

       $ make V=1 O=/tmp/build/perf -C tools/perf/ util/srcline.o
   ...
       # Redirected target util/srcline.o =>     /tmp/build/perf/util/util/srcline.o

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ee97778..2d55480 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -585,11 +585,11 @@ ifneq ($(OUTPUT),)
 %.o: $(OUTPUT)%.o
 	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 util/%.o: $(OUTPUT)util/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 bench/%.o: $(OUTPUT)bench/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 tests/%.o: $(OUTPUT)tests/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 endif
 
 # These two need to be here so that when O= is not used they take precedence
