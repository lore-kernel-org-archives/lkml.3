Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaG1I0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:26:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaG1I0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:26:34 -0400
Date: Mon, 28 Jul 2014 01:25:36 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-4f71f2a0abe8b2a76669a4608a62f5020a64205a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-48-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-48-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add vdso__new()
Git-Commit-ID: 4f71f2a0abe8b2a76669a4608a62f5020a64205a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f71f2a0abe8b2a76669a4608a62f5020a64205a
Gitweb:     http://git.kernel.org/tip/4f71f2a0abe8b2a76669a4608a62f5020a64205a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:56 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:34:47 -0300

perf tools: Add vdso__new()

This is preparation for adding support for compat VDSOs.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-48-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/vdso.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index fdaccaf..946d927 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -121,6 +121,20 @@ void vdso__exit(struct machine *machine)
 	zfree(&machine->vdso_info);
 }
 
+static struct dso *vdso__new(struct machine *machine, const char *short_name,
+			     const char *long_name)
+{
+	struct dso *dso;
+
+	dso = dso__new(short_name);
+	if (dso != NULL) {
+		dsos__add(&machine->user_dsos, dso);
+		dso__set_long_name(dso, long_name, false);
+	}
+
+	return dso;
+}
+
 struct dso *vdso__dso_findnew(struct machine *machine)
 {
 	struct vdso_info *vdso_info;
@@ -141,11 +155,7 @@ struct dso *vdso__dso_findnew(struct machine *machine)
 		if (!file)
 			return NULL;
 
-		dso = dso__new(VDSO__MAP_NAME);
-		if (dso != NULL) {
-			dsos__add(&machine->user_dsos, dso);
-			dso__set_long_name(dso, file, false);
-		}
+		dso = vdso__new(machine, VDSO__MAP_NAME, file);
 	}
 
 	return dso;
