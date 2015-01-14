Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbbANXst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:48:49 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38108 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbbANXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:48:46 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v3 3/3] perf probe: Fix probing kretprobes
Date: Thu, 15 Jan 2015 08:48:22 +0900
Message-Id: <1421279302-7105-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
References: <1421279302-7105-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
instead of the symbol name") converts kprobes to use ref_reloc_sym
(i.e. _stext) and offset instead of using symbol's name directly.  So
on my system, adding do_fork ends up with like below:

  $ sudo perf probe -v --add do_fork%return
  probe-definition(0): do_fork%return
  symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (7 entries long)
  Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
  Could not open debuginfo. Try to use symbols.
  Opening /sys/kernel/debug/tracing/kprobe_events write=1
  Added new event:
  Writing event: r:probe/do_fork _stext+456136
  Failed to write event: Invalid argument
  Error: Failed to add events. Reason: Operation not permitted (Code: -1)

As you can see, the do_fork was translated to _stext+456136.  This was
because to support (local) symbols that have same name.  But the
problem is that kretprobe requires to be inserted at function start
point so it simply checks whether it's called with offset 0.  And if
not, it'll return with -EINVAL.  You can see it with dmesg.

  $ dmesg | tail -1
    [125621.764103] Return probe must be used without offset.

So we need to use the symbol name instead of ref_reloc_sym in case of
return probes.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3cfad9c74faf..8fcb19b0e74f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -446,7 +446,7 @@ static int post_process_probe_trace_events(struct probe_trace_event *tevs,
 	}
 
 	for (i = 0; i < ntevs; i++) {
-		if (tevs[i].point.address) {
+		if (tevs[i].point.address && !tevs[i].point.retprobe) {
 			tmp = strdup(reloc_sym->name);
 			if (!tmp)
 				return -ENOMEM;
@@ -2254,7 +2254,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 		goto out;
 	}
 
-	if (!pev->uprobes) {
+	if (!pev->uprobes && !pp->retprobe) {
 		kmap = map__kmap(map);
 		reloc_sym = kmap->ref_reloc_sym;
 		if (!reloc_sym) {
-- 
2.2.1

