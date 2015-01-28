Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbbA1VYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:24:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762136AbbA1Utw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:52 -0500
Date: Wed, 28 Jan 2015 07:02:48 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-25dd9171f51c482eb7c4dc8618766ae733756e2d@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@kernel.org, hpa@zytor.com, jolsa@redhat.com
Reply-To: hpa@zytor.com, namhyung@kernel.org, tglx@linutronix.de,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, jolsa@redhat.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1421234288-22758-4-git-send-email-namhyung@kernel.org>
References: <1421234288-22758-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix probing kretprobes
Git-Commit-ID: 25dd9171f51c482eb7c4dc8618766ae733756e2d
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

Commit-ID:  25dd9171f51c482eb7c4dc8618766ae733756e2d
Gitweb:     http://git.kernel.org/tip/25dd9171f51c482eb7c4dc8618766ae733756e2d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 14 Jan 2015 20:18:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:06:24 -0300

perf probe: Fix probing kretprobes

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
index 7cc89b1..919937e 100644
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
