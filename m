Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBMVRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:17:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55903 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaBMVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:16:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf probe: Do not add offset twice to uprobe address
Date: Thu, 13 Feb 2014 18:15:57 -0300
Message-Id: <1392326161-30579-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392326161-30579-1-git-send-email-acme@infradead.org>
References: <1392326161-30579-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf-probe not to add offset value twice to uprobe probe address
when post processing.

The tevs[i].point.address struct member is the address of symbol+offset,
but current perf-probe adjusts the point.address by adding the offset.

As a result, the probe address becomes symbol+offset+offset. This may
cause unexpected code corruption. Urgent fix is needed.

Without this fix:
  ---
  # ./perf probe -x ./perf dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b8)
  # nm ./perf.orig | grep dso__load_vmlinux\$
  000000000046d0a0 T dso__load_vmlinux
  ---

You can see the given offset is 3 but the actual probed address is
dso__load_vmlinux+8.

With this fix:
  ---
  # ./perf probe -x ./perf dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b4)
  ---

Now the problem is fixed.

Note: This bug is introduced by
	commit fb7345bbf7fad9bf72ef63a19c707970b9685812

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a8a9b6cd93a8..d8b048c20cde 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -336,8 +336,8 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 		return ret;
 
 	for (i = 0; i < ntevs && ret >= 0; i++) {
+		/* point.address is the addres of point.symbol + point.offset */
 		offset = tevs[i].point.address - stext;
-		offset += tevs[i].point.offset;
 		tevs[i].point.offset = 0;
 		zfree(&tevs[i].point.symbol);
 		ret = e_snprintf(buf, 32, "0x%lx", offset);
-- 
1.8.1.4

