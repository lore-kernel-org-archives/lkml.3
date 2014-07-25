Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaGYPib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:35134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbaGYPi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:28 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/27] perf tools: Add vdso__new()
Date: Fri, 25 Jul 2014 12:36:59 -0300
Message-Id: <1406302629-11790-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index fdaccaf67371..946d927765c6 100644
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
-- 
1.9.3

