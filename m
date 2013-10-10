Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3JJWNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3JJWNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:13:37 -0400
Date: Fri, 11 Oct 2013 00:13:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131010221322.GA1067@krava.redhat.com>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131010192608.GI28369@ghostprotocols.net>
 <20131010195014.GJ28369@ghostprotocols.net>
 <20131010200627.GK28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010200627.GK28369@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo, David,
wrt to our IRC discussion..

attached patch fixies the static build David is using:
make O=/tmp/perf LDFLAGS=-static DEBUG=1 -j 4

I still got some warning though:
  LINK     /tmp/perf/perf
/tmp/perf/libperf.a(target.o): In function `perf_target__parse_uid':
/home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:72: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/home/jolsa/kernel.org/linux-perf/tools/perf/util/target.c:84: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-redhat-linux/4.7.2/../../../../lib64/libpthread.a(libpthread.o): In function `sem_open':
(.text+0x67f8): warning: the use of `mktemp' is dangerous, better use `mkstemp'

but I guess it's ok ;-) feel free to melt the
change into the original patch

This change is on top of the NO_DEMANGLE fix in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  acme_test

jirka

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 233dd36..9680424 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -504,7 +504,7 @@ else
   endif
 endif
 
-ifndef ($(filter -lbfd,$(EXTLIBS)),)
+ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
