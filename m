Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbbAUPCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:02:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:43524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbbAUPBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:01:52 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf probe: Fix probing kretprobes
Date: Wed, 21 Jan 2015 12:01:10 -0300
Message-Id: <1421852470-20153-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421852470-20153-1-git-send-email-acme@kernel.org>
References: <1421852470-20153-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
instead of the symbol name") converts kprobes to use ref_reloc_sym (i.e.
_stext) and offset instead of using symbol's name directly.  So on my
system, adding do_fork ends up with like below:

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
because to support (local) symbols that have same name.  But the problem
is that kretprobe requires to be inserted at function start point so it
simply checks whether it's called with offset 0.  And if not, it'll
return with -EINVAL.  You can see it with dmesg.

  $ dmesg | tail -1
    [125621.764103] Return probe must be used without offset.

So we need to use the symbol name instead of ref_reloc_sym in case of
return probes.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1421234288-22758-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7cc89b15fdb0..919937eb0be2 100644
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
1.9.3

