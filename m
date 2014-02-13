Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaBMVQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:16:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaBMVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, <stable@vger.kernel.org>
Subject: [PATCH 5/5] perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches
Date: Thu, 13 Feb 2014 18:16:01 -0300
Message-Id: <1392326161-30579-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392326161-30579-1-git-send-email-acme@infradead.org>
References: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Supporting decoding the ioctl 'request' parameter needs more work to
properly support more architectures, the current approach doesn't work
on at least powerpc and sparc, as reported by Ben Hutchings in
http://lkml.kernel.org/r/1391593985.3003.48.camel@deadeye.wl.decadent.org.uk .

Work around that by making it to be ifdefed for the architectures known
to work with the current, limited approach, i386 and x86_64 till better
code is written.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@vger.kernel.org> # 3.13 Fixes: 78645cf3ed32 ("perf trace: Initial beautifier for ioctl's 'cmd' arg")
Link: http://lkml.kernel.org/n/tip-ss04k11insqlu329xh5g02q0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 619d11c47a91..6aa6fb6f7bd9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -283,6 +283,11 @@ static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches as soon as the ioctl beautifier
+ * 	  gets rewritten to support all arches.
+ */
 static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 						 struct syscall_arg *arg)
 {
@@ -290,6 +295,7 @@ static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 }
 
 #define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
@@ -843,6 +849,10 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 #define TCGETS		0x5401
 
 static const char *tioctls[] = {
@@ -864,6 +874,7 @@ static const char *tioctls[] = {
 };
 
 static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
@@ -945,9 +956,16 @@ static struct syscall_fmt {
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 			     [1] = SCA_STRHEXARRAY, /* cmd */
 			     [2] = SCA_HEX, /* arg */ },
 	  .arg_parm	 = { [1] = &strarray__tioctls, /* cmd */ }, },
+#else
+			     [2] = SCA_HEX, /* arg */ }, },
+#endif
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,
-- 
1.8.1.4

