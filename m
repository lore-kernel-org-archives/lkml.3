Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3JOFfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:35:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3JOFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:35:15 -0400
Date: Mon, 14 Oct 2013 22:34:56 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-6e427ab02c8886ca6c9ecdbb318e68fe8f605469@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-4-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Find kcore symbols on other maps
Git-Commit-ID: 6e427ab02c8886ca6c9ecdbb318e68fe8f605469
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e427ab02c8886ca6c9ecdbb318e68fe8f605469
Gitweb:     http://git.kernel.org/tip/6e427ab02c8886ca6c9ecdbb318e68fe8f605469
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Oct 2013 13:43:40 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:20 -0300

perf annotate: Find kcore symbols on other maps

Use the new map_groups__find_ams() method to find kcore symbols on other
maps.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 882bb86..cf6242c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -825,20 +825,16 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		dl->ops.target.offset = dl->ops.target.addr -
 					map__rip_2objdump(map, sym->start);
 
-	/*
-	 * kcore has no symbols, so add the call target name if it is on the
-	 * same map.
-	 */
+	/* kcore has no symbols, so add the call target name */
 	if (dl->ins && ins__is_call(dl->ins) && !dl->ops.target.name) {
-		struct symbol *s;
-		u64 ip = dl->ops.target.addr;
-
-		if (ip >= map->start && ip <= map->end) {
-			ip = map->map_ip(map, ip);
-			s = map__find_symbol(map, ip, NULL);
-			if (s && s->start == ip)
-				dl->ops.target.name = strdup(s->name);
-		}
+		struct addr_map_symbol target = {
+			.map = map,
+			.addr = dl->ops.target.addr,
+		};
+
+		if (!map_groups__find_ams(&target, NULL) &&
+		    target.sym->start == target.al_addr)
+			dl->ops.target.name = strdup(target.sym->name);
 	}
 
 	disasm__add(&notes->src->source, dl);
