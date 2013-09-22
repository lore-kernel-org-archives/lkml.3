Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3IVKP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:15:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3IVKPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354049"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 01/10] perf tools: fix path unpopulated in machine__create_modules()
Date: Sun, 22 Sep 2013 13:22:09 +0300
Message-Id: <1379845338-29637-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine__create_modules() the 'path' char array
was used in a call to symbol__restricted_filename()
without always being populated.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f..ddf917b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -785,14 +785,14 @@ static int machine__create_modules(struct machine *machine)
 	const char *modules;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(machine))
+	if (machine__is_default_guest(machine)) {
 		modules = symbol_conf.default_guest_modules;
-	else {
-		sprintf(path, "%s/proc/modules", machine->root_dir);
+	} else {
+		snprintf(path, PATH_MAX, "%s/proc/modules", machine->root_dir);
 		modules = path;
 	}
 
-	if (symbol__restricted_filename(path, "/proc/modules"))
+	if (symbol__restricted_filename(modules, "/proc/modules"))
 		return -1;
 
 	file = fopen(modules, "r");
-- 
1.7.11.7

