Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaA2JPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:15:09 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49210 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaA2JPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:15:05 -0500
Subject: [PATCH -tip v2 5/8] perf-probe: Retry to find given address from
 offline dwarf
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 29 Jan 2014 09:15:02 +0000
Message-ID: <20140129091502.22141.47150.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry to find the given address from offline dwarfs too.

On the KASLR enabled kernel, the kernel text section is
loaded with random offset, and debuginfo__new_online_kernel
tries to map the debuginfo with that offset. However,
perf's map object tries to make a non-randomized ummapped
address. This leads to fail looking up the appropriate
debuginfo from that address.

To solve this issue, we retry to use offline dwarfs if
possible.

Without this change;

  # ./perf probe -l
    probe:t_show         (on _stext+901288 with m v)
    probe:t_show_1       (on _stext+939624 with m v t)
    probe:t_show_2       (on _stext+980296 with m v fmt)
    probe:t_show_3       (on _stext+1014392 with m v file)

With this change;

  # ./perf probe -l
    probe:t_show         (on t_show@linux-3/kernel/trace/ftrace.c with m v)
    probe:t_show_1       (on t_show@linux-3/kernel/trace/trace.c with m v t)
    probe:t_show_2       (on t_show@kernel/trace/trace_printk.c with m v fmt)
    probe:t_show_3       (on t_show@kernel/trace/trace_events.c with m v file)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 120954b..b35f047 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -272,6 +272,8 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 			 tp->offset, addr);
 
 		dinfo = debuginfo__new_online_kernel(addr);
+		if (!dinfo)	/* For kaslr kernel */
+			dinfo = open_debuginfo(tp->module);
 		if (dinfo) {
 			ret = debuginfo__find_probe_point(dinfo,
 						 (unsigned long)addr, pp);


