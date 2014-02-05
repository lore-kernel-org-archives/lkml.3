Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaBEFTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:19:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55602 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBEFTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:19:03 -0500
Subject: [PATCH -tip ] [BUGFIX/URGENT] perf-probe: Do not add offset to
 uprobe address
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 05 Feb 2014 05:18:58 +0000
Message-ID: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf-probe not to add offset value to uprobe probe
address when post processing.
tevs[i].point.address is the address of symbol+offset,
but current perf-probe adjusts the point.address by
adding the offset. As a result, the probe address becomes
symbol+offset+offset. This may cause unexpected
code corruption. Urgent fix is needed.

Without this fix
  ---
  # ./perf probe -x ./perf dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b8)
  # nm ./perf.orig | grep dso__load_vmlinux\$
  000000000046d0a0 T dso__load_vmlinux
  ---
You can see the given offset is 3 but the actual probed
address is dso__load_vmlinux+8.

With this fix
  ---
  # ./perf probe -x ./perf dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b4)
  ---
Now the problem is fixed.

Note: This bug is introduced by
	commit fb7345bbf7fad9bf72ef63a19c707970b9685812

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a8a9b6c..d8b048c 100644
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


