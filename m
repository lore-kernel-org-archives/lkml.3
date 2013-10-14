Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab3JNU0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 055/161] perf trace: Allow passing parms to arg formatters
Date: Mon, 14 Oct 2013 17:00:44 -0300
Message-Id: <1381780950-25642-56-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can have generic formatters that act upon specific
parameters.

Start using them with a simple string table that assumes entries
will be indexes to a string table, like with the 'which' parm
for the set and getitimer syscalls

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r0dqhapr8j6150v1wctgg340@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 939426c7dbde..386ca2058ee7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -35,10 +35,35 @@
 
 struct syscall_arg {
 	unsigned long val;
+	void	      *parm;
 	u8	      idx;
 	u8	      mask;
 };
 
+struct strarray {
+	int	    nr_entries;
+	const char **entries;
+};
+
+#define DEFINE_STRARRAY(array) struct strarray strarray__##array = { \
+	.nr_entries = ARRAY_SIZE(array), \
+	.entries = array, \
+}
+
+static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
+					      struct syscall_arg *arg)
+{
+	int idx = arg->val;
+	struct strarray *sa = arg->parm;
+
+	if (idx < 0 || idx >= sa->nr_entries)
+		return scnprintf(bf, size, "%d", idx);
+
+	return scnprintf(bf, size, "%s", sa->entries[idx]);
+}
+
+#define SCA_STRARRAY syscall_arg__scnprintf_strarray
+
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 					 struct syscall_arg *arg)
 {
@@ -229,6 +254,9 @@ static size_t syscall_arg__scnprintf_futex_op(char *bf, size_t size, struct sysc
 	return printed;
 }
 
+static const char *itimers[] = { "REAL", "VIRTUAL", "PROF", };
+static DEFINE_STRARRAY(itimers);
+
 #define SCA_FUTEX_OP  syscall_arg__scnprintf_futex_op
 
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
@@ -291,6 +319,7 @@ static struct syscall_fmt {
 	const char *name;
 	const char *alias;
 	size_t	   (*arg_scnprintf[6])(char *bf, size_t size, struct syscall_arg *arg);
+	void	   *arg_parm[6];
 	bool	   errmsg;
 	bool	   timeout;
 	bool	   hexret;
@@ -305,6 +334,9 @@ static struct syscall_fmt {
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_FUTEX_OP, /* op */ }, },
+	{ .name	    = "getitimer",  .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
+	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_HEX, /* arg */ }, },
 	{ .name	    = "lseek",	    .errmsg = true,
@@ -338,6 +370,9 @@ static struct syscall_fmt {
 	{ .name	    = "read",	    .errmsg = true, },
 	{ .name	    = "recvfrom",   .errmsg = true, },
 	{ .name	    = "select",	    .errmsg = true, .timeout = true, },
+	{ .name	    = "setitimer",  .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
+	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
 	{ .name	    = "socket",	    .errmsg = true, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "uname",	    .errmsg = true, .alias = "newuname", },
@@ -361,6 +396,7 @@ struct syscall {
 	bool		    filtered;
 	struct syscall_fmt  *fmt;
 	size_t		    (**arg_scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
+	void		    **arg_parm;
 };
 
 static size_t fprintf_duration(unsigned long t, FILE *fp)
@@ -528,6 +564,9 @@ static int syscall__set_arg_fmts(struct syscall *sc)
 	if (sc->arg_scnprintf == NULL)
 		return -1;
 
+	if (sc->fmt)
+		sc->arg_parm = sc->fmt->arg_parm;
+
 	for (field = sc->tp_format->format.fields->next; field; field = field->next) {
 		if (sc->fmt && sc->fmt->arg_scnprintf[idx])
 			sc->arg_scnprintf[idx] = sc->fmt->arg_scnprintf[idx];
@@ -619,6 +658,8 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 					     "%s%s: ", printed ? ", " : "", field->name);
 			if (sc->arg_scnprintf && sc->arg_scnprintf[arg.idx]) {
 				arg.val = args[arg.idx];
+				if (sc->arg_parm)
+					arg.parm = sc->arg_parm[arg.idx];
 				printed += sc->arg_scnprintf[arg.idx](bf + printed,
 								      size - printed, &arg);
 			} else {
-- 
1.8.1.4

