Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3HLKXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:23:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3HLKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:15 -0400
Date: Mon, 12 Aug 2013 03:22:32 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b178170a38e719cb7bc4a14d3f5e4b4ea6b7b851@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1375875537-4509-14-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-14-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Add call target name if it is missing
Git-Commit-ID: b178170a38e719cb7bc4a14d3f5e4b4ea6b7b851
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:22:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b178170a38e719cb7bc4a14d3f5e4b4ea6b7b851
Gitweb:     http://git.kernel.org/tip/b178170a38e719cb7bc4a14d3f5e4b4ea6b7b851
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:57 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:36 -0300

perf annotate: Add call target name if it is missing

The /proc/kcore file has no symbols, so the call target name does not
display.  Fix by looking up the symbol name if it is on the same map.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-14-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 646e38d..bfc5a27 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -825,6 +825,22 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		dl->ops.target.offset = dl->ops.target.addr -
 					map__rip_2objdump(map, sym->start);
 
+	/*
+	 * kcore has no symbols, so add the call target name if it is on the
+	 * same map.
+	 */
+	if (dl->ins && ins__is_call(dl->ins) && !dl->ops.target.name) {
+		struct symbol *s;
+		u64 ip = dl->ops.target.addr;
+
+		if (ip >= map->start && ip <= map->end) {
+			ip = map->map_ip(map, ip);
+			s = map__find_symbol(map, ip, NULL);
+			if (s && s->start == ip)
+				dl->ops.target.name = strdup(s->name);
+		}
+	}
+
 	disasm__add(&notes->src->source, dl);
 
 	return 0;
