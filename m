Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBVRzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:55:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40678 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaBVRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:55:15 -0500
Date: Sat, 22 Feb 2014 09:54:46 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-981a23792cd02631f8cd5dd65753208a44de5ae1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dave.long@linaro.org, hpa@zytor.com, mingo@kernel.org,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Do not add offset twice to uprobe address
Git-Commit-ID: 981a23792cd02631f8cd5dd65753208a44de5ae1
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

Commit-ID:  981a23792cd02631f8cd5dd65753208a44de5ae1
Gitweb:     http://git.kernel.org/tip/981a23792cd02631f8cd5dd65753208a44de5ae1
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 5 Feb 2014 05:18:58 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Feb 2014 11:34:30 -0300

perf probe: Do not add offset twice to uprobe address

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
