Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3JWHxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3JWHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:20 -0400
Date: Wed, 23 Oct 2013 00:52:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-669q04c5tou5pnt8jtiz6y2r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce filename__read_int helper
Git-Commit-ID: 97a07f10c38064dea492794c99445f6260afcdc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:52:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97a07f10c38064dea492794c99445f6260afcdc1
Gitweb:     http://git.kernel.org/tip/97a07f10c38064dea492794c99445f6260afcdc1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Oct 2013 16:33:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Oct 2013 16:33:43 -0300

perf tools: Introduce filename__read_int helper

Just opens a file and calls atoi() in at most its first 64 bytes.

To read things like /proc/sys/kernel/perf_event_paranoid.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-669q04c5tou5pnt8jtiz6y2r@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 17 +++++++++++++++++
 tools/perf/util/util.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8dc8cf3..c25e57b 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -394,3 +394,20 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags)
 
 	return (unsigned long) -1;
 }
+
+int filename__read_int(const char *filename, int *value)
+{
+	char line[64];
+	int fd = open(filename, O_RDONLY), err = -1;
+
+	if (fd < 0)
+		return -1;
+
+	if (read(fd, line, sizeof(line)) > 0) {
+		*value = atoi(line);
+		err = 0;
+	}
+
+	close(fd);
+	return err;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 42dfba7..c8f362d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -305,4 +305,6 @@ struct dso;
 
 char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
+
+int filename__read_int(const char *filename, int *value);
 #endif /* GIT_COMPAT_UTIL_H */
