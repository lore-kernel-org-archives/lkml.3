Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3JWH7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:59:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3JWHxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:32 -0400
Date: Wed, 23 Oct 2013 00:52:52 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-di28olfwd28rvkox7v3hqhu1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Improve messages related to /proc/sys
 /kernel/perf_event_paranoid
Git-Commit-ID: a8f23d8f8af43d49cd3331681913b76e4951e1a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:52:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8f23d8f8af43d49cd3331681913b76e4951e1a4
Gitweb:     http://git.kernel.org/tip/a8f23d8f8af43d49cd3331681913b76e4951e1a4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Oct 2013 17:38:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Oct 2013 17:38:29 -0300

perf trace: Improve messages related to /proc/sys/kernel/perf_event_paranoid

kernel/events/core.c has:

  /*
   * perf event paranoia level:
   *  -1 - not paranoid at all
   *   0 - disallow raw tracepoint access for unpriv
   *   1 - disallow cpu events for unpriv
   *   2 - disallow kernel profiling for unpriv
   */
  int sysctl_perf_event_paranoid __read_mostly = 1;

So, with the default being 1, a non-root user can trace his stuff:

  [acme@zoo ~]$ cat /proc/sys/kernel/perf_event_paranoid
  1
  [acme@zoo ~]$ yes > /dev/null &
  [1] 15338
  [acme@zoo ~]$ trace -p 15338 | head -5
       0.005 ( 0.005 ms): write(fd: 1</dev/null>, buf: 0x7fe6db765000, count: 4096 ) = 4096
       0.045 ( 0.001 ms): write(fd: 1</dev/null>, buf: 0x7fe6db765000, count: 4096 ) = 4096
       0.085 ( 0.001 ms): write(fd: 1</dev/null>, buf: 0x7fe6db765000, count: 4096 ) = 4096
       0.125 ( 0.001 ms): write(fd: 1</dev/null>, buf: 0x7fe6db765000, count: 4096 ) = 4096
       0.165 ( 0.001 ms): write(fd: 1</dev/null>, buf: 0x7fe6db765000, count: 4096 ) = 4096
  [acme@zoo ~]$
  [acme@zoo ~]$ trace --duration 1 sleep 1
    1002.148 (1001.218 ms): nanosleep(rqtp: 0x7fff46c79250                           ) = 0
  [acme@zoo ~]$
  [acme@zoo ~]$ trace -- usleep 1 | tail -5
       0.905 ( 0.002 ms): brk(                                                     ) = 0x1c82000
       0.910 ( 0.003 ms): brk(brk: 0x1ca3000                                       ) = 0x1ca3000
       0.913 ( 0.001 ms): brk(                                                     ) = 0x1ca3000
       0.990 ( 0.059 ms): nanosleep(rqtp: 0x7fffe31a3280                           ) = 0
       0.995 ( 0.000 ms): exit_group(
  [acme@zoo ~]$

But can't do system wide tracing:

  [acme@zoo ~]$ trace
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_paranoid setting.
  Hint:	For system wide tracing it needs to be set to -1.
  Hint:	The current value is 1.
  [acme@zoo ~]$

  [acme@zoo ~]$ trace --cpu 0
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_paranoid setting.
  Hint:	For system wide tracing it needs to be set to -1.
  Hint:	The current value is 1.
  [acme@zoo ~]$

If the paranoid level is >= 2, i.e. turn this perf stuff off for !root users:

  [acme@zoo ~]$ sudo sh -c 'echo 2 > /proc/sys/kernel/perf_event_paranoid'
  [acme@zoo ~]$ cat /proc/sys/kernel/perf_event_paranoid
  2
  [acme@zoo ~]$
  [acme@zoo ~]$ trace usleep 1
  Error:	Permission denied.
  Hint:	Check /proc/sys/kernel/perf_event_paranoid setting.
  Hint:	For your workloads it needs to be <= 1
  Hint:	For system wide tracing it needs to be set to -1.
  Hint:	The current value is 2.
  [acme@zoo ~]$
  [acme@zoo ~]$ trace
  Error:	Permission denied.
  Hint:	Check /proc/sys/kernel/perf_event_paranoid setting.
  Hint:	For your workloads it needs to be <= 1
  Hint:	For system wide tracing it needs to be set to -1.
  Hint:	The current value is 2.
  [acme@zoo ~]$
  [acme@zoo ~]$ trace --cpu 1
  Error:	Permission denied.
  Hint:	Check /proc/sys/kernel/perf_event_paranoid setting.
  Hint:	For your workloads it needs to be <= 1
  Hint:	For system wide tracing it needs to be set to -1.
  Hint:	The current value is 2.
  [acme@zoo ~]$

If the user manages to get what he/she wants, convincing root not
to be paranoid at all...

  [root@zoo ~]# echo -1 > /proc/sys/kernel/perf_event_paranoid
  [root@zoo ~]# cat /proc/sys/kernel/perf_event_paranoid
  -1
  [root@zoo ~]#

  [acme@zoo ~]$ ps -eo user,pid,comm | grep Xorg
  root       729 Xorg
  [acme@zoo ~]$
  [acme@zoo ~]$ trace -a --duration 0.001 -e \!select,ioctl,writev | grep Xorg  | head -5
      23.143 ( 0.003 ms): Xorg/729 setitimer(which: REAL, value: 0x7fffaadf16e0 ) = 0
      23.152 ( 0.004 ms): Xorg/729 read(fd: 31, buf: 0x2544af0, count: 4096     ) = 8
      23.161 ( 0.002 ms): Xorg/729 read(fd: 31, buf: 0x2544af0, count: 4096     ) = -1 EAGAIN Resource temporarily unavailable
      23.175 ( 0.002 ms): Xorg/729 setitimer(which: REAL, value: 0x7fffaadf16e0 ) = 0
      23.235 ( 0.002 ms): Xorg/729 setitimer(which: REAL, value: 0x7fffaadf16e0 ) = 0
  [acme@zoo ~]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-di28olfwd28rvkox7v3hqhu1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 17 +++++++++++------
 tools/perf/util/evlist.c   | 36 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h   |  1 +
 3 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 78b0d6a..db959ac 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1713,10 +1713,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	}
 
 	err = perf_evlist__open(evlist);
-	if (err < 0) {
-		fprintf(trace->output, "Couldn't create the events: %s\n", strerror(errno));
-		goto out_delete_maps;
-	}
+	if (err < 0)
+		goto out_error_open;
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
@@ -1813,14 +1811,21 @@ out_delete_evlist:
 out:
 	trace->live = false;
 	return err;
-out_error_tp:
 {
 	char errbuf[BUFSIZ];
+
+out_error_tp:
 	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
+	goto out_error;
+
+out_error_open:
+	perf_evlist__strerror_open(evlist, errno, errbuf, sizeof(errbuf));
+
+out_error:
 	fprintf(trace->output, "%s\n", errbuf);
-}
 	goto out_delete_evlist;
 }
+}
 
 static int trace__replay(struct trace *trace)
 {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6737420..0b5425b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1153,3 +1153,39 @@ int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
 
 	return 0;
 }
+
+int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
+			       int err, char *buf, size_t size)
+{
+	int printed, value;
+	char sbuf[128], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
+
+	switch (err) {
+	case EACCES:
+	case EPERM:
+		printed = scnprintf(buf, size,
+				    "Error:\t%s.\n"
+				    "Hint:\tCheck /proc/sys/kernel/perf_event_paranoid setting.", emsg);
+
+		if (filename__read_int("/proc/sys/kernel/perf_event_paranoid", &value))
+			break;
+
+		printed += scnprintf(buf + printed, size - printed, "\nHint:\t");
+
+		if (value >= 2) {
+			printed += scnprintf(buf + printed, size - printed,
+					     "For your workloads it needs to be <= 1\nHint:\t");
+		}
+		printed += scnprintf(buf + printed, size - printed,
+				     "For system wide tracing it needs to be set to -1");
+
+		printed += scnprintf(buf + printed, size - printed,
+				    ".\nHint:\tThe current value is %d.", value);
+		break;
+	default:
+		scnprintf(buf, size, "%s", emsg);
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 386de10..7f8f1ae 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -169,6 +169,7 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
+int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
