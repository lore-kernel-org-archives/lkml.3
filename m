Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbaCDVEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:04:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbaCDUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.13 106/172] perf trace: Fix ioctl request beautifier build problems on !(i386 || x86_64) arches
Date: Tue,  4 Mar 2014 12:03:10 -0800
Message-Id: <20140304200303.102444372@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 844ae5b46c08dbc7ba695b543c023f9cf3bbf9ff upstream.

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
Link: http://lkml.kernel.org/n/tip-ss04k11insqlu329xh5g02q0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-trace.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -275,6 +275,11 @@ static size_t syscall_arg__scnprintf_str
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches as soon as the ioctl beautifier
+ * 	  gets rewritten to support all arches.
+ */
 static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 						 struct syscall_arg *arg)
 {
@@ -282,6 +287,7 @@ static size_t syscall_arg__scnprintf_str
 }
 
 #define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
@@ -835,6 +841,10 @@ static size_t syscall_arg__scnprintf_sig
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 #define TCGETS		0x5401
 
 static const char *tioctls[] = {
@@ -856,6 +866,7 @@ static const char *tioctls[] = {
 };
 
 static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
@@ -937,9 +948,16 @@ static struct syscall_fmt {
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


