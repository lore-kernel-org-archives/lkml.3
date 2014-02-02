Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBBI4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaBBIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:55:58 -0500
Date: Sun, 2 Feb 2014 00:55:31 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-15a0a8706c32bd38bff9ebf7c6ef24f32d1ea921@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-4-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine:
  Add machine__get_kallsyms_filename()
Git-Commit-ID: 15a0a8706c32bd38bff9ebf7c6ef24f32d1ea921
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15a0a8706c32bd38bff9ebf7c6ef24f32d1ea921
Gitweb:     http://git.kernel.org/tip/15a0a8706c32bd38bff9ebf7c6ef24f32d1ea921
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:48 -0300

perf machine: Add machine__get_kallsyms_filename()

Separate out the logic used to make the kallsyms full path name for a
machine.  It will be reused in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ded7459..290c2e6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -496,19 +496,22 @@ static int symbol__in_kernel(void *arg, const char *name,
 	return 1;
 }
 
+static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
+					   size_t bufsz)
+{
+	if (machine__is_default_guest(machine))
+		scnprintf(buf, bufsz, "%s", symbol_conf.default_guest_kallsyms);
+	else
+		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
+}
+
 /* Figure out the start address of kernel map from /proc/kallsyms */
 static u64 machine__get_kernel_start_addr(struct machine *machine)
 {
-	const char *filename;
-	char path[PATH_MAX];
+	char filename[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_default_guest(machine))
-		filename = (char *)symbol_conf.default_guest_kallsyms;
-	else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-		filename = path;
-	}
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return 0;
