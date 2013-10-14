Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab3JNUGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:06:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39142 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3JNUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 131/161] perf trace: Initial beautifier for ioctl's 'cmd' arg
Date: Mon, 14 Oct 2013 17:02:00 -0300
Message-Id: <1381780950-25642-132-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

 [root@zoo linux]# trace -e ioctl | grep -v "cmd: 0x" | head -10
      0.386 ( 0.001 ms): trace/1602 ioctl(fd: 1<pipe:[127057]>, cmd: TCGETS, arg: 0x7fff59fcb4d0          ) = -1 ENOTTY Inappropriate ioctl for device
   1459.368 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   1463.586 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   1463.611 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   3740.526 ( 0.002 ms): awk/1612 ioctl(fd: 1<pipe:[128265]>, cmd: TCGETS, arg: 0x7fff4d166b90          ) = -1 ENOTTY Inappropriate ioctl for device
   3740.704 ( 0.001 ms): awk/1612 ioctl(fd: 3</proc/meminfo>, cmd: TCGETS, arg: 0x7fff4d1669a0          ) = -1 ENOTTY Inappropriate ioctl for device
   3742.550 ( 0.002 ms): ps/1614 ioctl(fd: 1<pipe:[128266]>, cmd: TIOCGWINSZ, arg: 0x7fff591762b0      ) = -1 ENOTTY Inappropriate ioctl for device
   3742.555 ( 0.003 ms): ps/1614 ioctl(fd: 2<socket:[19550]>, cmd: TIOCGWINSZ, arg: 0x7fff591762b0     ) = -1 ENOTTY Inappropriate ioctl for device
   3742.558 ( 0.002 ms): ps/1614 ioctl(cmd: TIOCGWINSZ, arg: 0x7fff591762b0                            ) = -1 ENOTTY Inappropriate ioctl for device
   3742.572 ( 0.002 ms): ps/1614 ioctl(fd: 1<pipe:[128266]>, cmd: TCGETS, arg: 0x7fff59176220          ) = -1 ENOTTY Inappropriate ioctl for device
 [root@zoo linux]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-afajwap3mr60dfl4qpdl1pxn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0d4af1d7e55c..19ddcabc73d2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -81,6 +81,14 @@ static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
+						 struct syscall_arg *arg)
+{
+	return __syscall_arg__scnprintf_strarray(bf, size, "%#x", arg);
+}
+
+#define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
 
@@ -633,6 +641,28 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#define TCGETS		0x5401
+
+static const char *tioctls[] = {
+	"TCGETS", "TCSETS", "TCSETSW", "TCSETSF", "TCGETA", "TCSETA", "TCSETAW",
+	"TCSETAF", "TCSBRK", "TCXONC", "TCFLSH", "TIOCEXCL", "TIOCNXCL",
+	"TIOCSCTTY", "TIOCGPGRP", "TIOCSPGRP", "TIOCOUTQ", "TIOCSTI",
+	"TIOCGWINSZ", "TIOCSWINSZ", "TIOCMGET", "TIOCMBIS", "TIOCMBIC",
+	"TIOCMSET", "TIOCGSOFTCAR", "TIOCSSOFTCAR", "FIONREAD", "TIOCLINUX",
+	"TIOCCONS", "TIOCGSERIAL", "TIOCSSERIAL", "TIOCPKT", "FIONBIO",
+	"TIOCNOTTY", "TIOCSETD", "TIOCGETD", "TCSBRKP", [0x27] = "TIOCSBRK",
+	"TIOCCBRK", "TIOCGSID", "TCGETS2", "TCSETS2", "TCSETSW2", "TCSETSF2",
+	"TIOCGRS485", "TIOCSRS485", "TIOCGPTN", "TIOCSPTLCK",
+	"TIOCGDEV||TCGETX", "TCSETX", "TCSETXF", "TCSETXW", "TIOCSIG",
+	"TIOCVHANGUP", "TIOCGPKT", "TIOCGPTLCK", "TIOCGEXCL",
+	[0x50] = "FIONCLEX", "FIOCLEX", "FIOASYNC", "TIOCSERCONFIG",
+	"TIOCSERGWILD", "TIOCSERSWILD", "TIOCGLCKTRMIOS", "TIOCSLCKTRMIOS",
+	"TIOCSERGSTRUCT", "TIOCSERGETLSR", "TIOCSERGETMULTI", "TIOCSERSETMULTI",
+	"TIOCMIWAIT", "TIOCGICOUNT", [0x60] = "FIOQSIZE",
+};
+
+static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
 	  .arg_parm	 = { [arg] = &strarray__##array, }
@@ -713,7 +743,9 @@ static struct syscall_fmt {
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
-			     [2] = SCA_HEX, /* arg */ }, },
+			     [1] = SCA_STRHEXARRAY, /* cmd */
+			     [2] = SCA_HEX, /* arg */ },
+	  .arg_parm	 = { [1] = &strarray__tioctls, /* cmd */ }, },
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,
-- 
1.8.1.4

