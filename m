Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaGVNVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:21:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:45622 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbaGVNVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576986341"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 47/52] perf tools: Add vdso__new()
Date: Tue, 22 Jul 2014 16:17:56 +0300
Message-Id: <1406035081-14301-48-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation for adding support for
compat VDSOs.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
-- 
1.8.3.2

