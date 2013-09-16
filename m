Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3IPKqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:46:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:47741 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3IPKqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:46:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,914,1371106800"; 
   d="scan'208";a="361036291"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/11] perf tools: fix path unpopulated in machine__create_modules()
Date: Mon, 16 Sep 2013 13:52:43 +0300
Message-Id: <1379328772-21214-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379328772-21214-1-git-send-email-adrian.hunter@intel.com>
References: <1379328772-21214-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine__create_modules() the 'path' char array
was used in a call to symbol__restricted_filename()
without always being populated.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f..1ae917c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -782,20 +782,17 @@ static int machine__create_modules(struct machine *machine)
 	size_t n;
 	FILE *file;
 	struct map *map;
-	const char *modules;
 	char path[PATH_MAX];
 
 	if (machine__is_default_guest(machine))
-		modules = symbol_conf.default_guest_modules;
-	else {
-		sprintf(path, "%s/proc/modules", machine->root_dir);
-		modules = path;
-	}
+		strncpy(path, symbol_conf.default_guest_modules, PATH_MAX);
+	else
+		snprintf(path, PATH_MAX, "%s/proc/modules", machine->root_dir);
 
 	if (symbol__restricted_filename(path, "/proc/modules"))
 		return -1;
 
-	file = fopen(modules, "r");
+	file = fopen(path, "r");
 	if (file == NULL)
 		return -1;
 
-- 
1.7.11.7

