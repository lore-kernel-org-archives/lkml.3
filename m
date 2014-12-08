Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaLHGuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:50:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaLHGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:50:04 -0500
Date: Sun, 7 Dec 2014 22:49:46 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-330dfa224fcc8594977785a6493ca06d124f0cfe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com, hpa@zytor.com,
        adrian.hunter@intel.com, tglx@linutronix.de, mingo@kernel.org,
        namhyung@kernel.org, jolsa@redhat.com, namhyung.kim@lge.com,
        acme@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl
Reply-To: paulus@samba.org, namhyung.kim@lge.com, acme@redhat.com,
        jolsa@redhat.com, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, adrian.hunter@intel.com
In-Reply-To: <1416285028-30572-1-git-send-email-namhyung@kernel.org>
References: <1416285028-30572-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix segfault due to invalid kernel dso access
Git-Commit-ID: 330dfa224fcc8594977785a6493ca06d124f0cfe
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

Commit-ID:  330dfa224fcc8594977785a6493ca06d124f0cfe
Gitweb:     http://git.kernel.org/tip/330dfa224fcc8594977785a6493ca06d124f0cfe
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 18 Nov 2014 13:30:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:48 -0300

perf tools: Fix segfault due to invalid kernel dso access

Jiri reported that the commit 96d78059d6d9 ("perf tools: Make vmlinux
short name more like kallsyms short name") segfaults on perf script.

When processing kernel mmap event, it should access the 'kernel'
variable as sometimes it cannot find a matching dso from build-id table
so 'dso' might be invalid.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1416285028-30572-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d97309c..b75b487 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,8 +1106,8 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
-		if (strstr(dso->long_name, "vmlinux"))
-			dso__set_short_name(dso, "[kernel.vmlinux]", false);
+		if (strstr(kernel->long_name, "vmlinux"))
+			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
 
 		machine__set_kernel_mmap_len(machine, event);
 
