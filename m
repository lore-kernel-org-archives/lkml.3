Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab3JOFeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:34:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3JOFeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:34:04 -0400
Date: Mon, 14 Oct 2013 22:33:45 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-4e987712740a3634c19a6fedaf12577b26775dc5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-2-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add map_groups__find_ams()
Git-Commit-ID: 4e987712740a3634c19a6fedaf12577b26775dc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:33:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e987712740a3634c19a6fedaf12577b26775dc5
Gitweb:     http://git.kernel.org/tip/4e987712740a3634c19a6fedaf12577b26775dc5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 14 Oct 2013 13:43:38 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:02 -0300

perf symbols: Add map_groups__find_ams()

Add a function to find a symbol using an ip that might be on a different
map.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 17 +++++++++++++++++
 tools/perf/util/map.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 17ee458..9dea404 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -371,6 +371,23 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 	return NULL;
 }
 
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
+{
+	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
+		if (ams->map->groups == NULL)
+			return -1;
+		ams->map = map_groups__find(ams->map->groups, ams->map->type,
+					    ams->addr);
+		if (ams->map == NULL)
+			return -1;
+	}
+
+	ams->al_addr = ams->map->map_ip(ams->map, ams->addr);
+	ams->sym = map__find_symbol(ams->map, ams->al_addr, filter);
+
+	return ams->sym ? 0 : -1;
+}
+
 size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp)
 {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4886ca2..0359b4a 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -167,6 +167,10 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
+struct addr_map_symbol;
+
+int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter);
+
 static inline
 struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
