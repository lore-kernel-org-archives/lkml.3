Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbbAHJwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:52:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbbAHJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:52:37 -0500
Date: Thu, 8 Jan 2015 01:52:13 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-906451b98b6774042b707a5dcebb6a93dbd14c85@git.kernel.org>
Cc: masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, acme@redhat.com,
        mingo@kernel.org, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: dsahern@gmail.com, namhyung@kernel.org, acme@redhat.com,
        mingo@kernel.org, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20141231062747.2087.80961.stgit@localhost.localdomain>
References: <20141231062747.2087.80961.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix to fall back to find probe point in symbols
Git-Commit-ID: 906451b98b6774042b707a5dcebb6a93dbd14c85
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

Commit-ID:  906451b98b6774042b707a5dcebb6a93dbd14c85
Gitweb:     http://git.kernel.org/tip/906451b98b6774042b707a5dcebb6a93dbd14c85
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 31 Dec 2014 15:27:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Jan 2015 12:42:17 -0300

perf probe: Fix to fall back to find probe point in symbols

Fix to fall back to find a probe point in symbols if perf fails to find
it in debuginfo.

This can happen when the target function is an alias of another
function. Such alias doesn't have an entry in debuginfo but in symbols.

David Ahern reported this problem in https://lkml.org/lkml/2014/12/29/355

I ensured the problem and deeper investigation discovers it.
 -----
 eu-readelf --debug-dump=info /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.19.so | grep \"malloc\" -A6
             name                 (strp) "malloc"
             decl_file            (data1) 25
             decl_line            (data2) 466
             prototyped           (flag_present)
             type                 (ref4) [  81b5]
             declaration          (flag_present)
 [  8f58]      formal_parameter
 --
             name                 (strp) "malloc"
             decl_file            (data1) 23
             decl_line            (data2) 466
             prototyped           (flag_present)
             type                 (ref4) [  9f4a]
             declaration          (flag_present)
             sibling              (ref4) [  bb29]
 ...
 -----
All these entires have no instances (all of them are declarations)
This is why the perf probe failed to find it in debuginfo.

However, there are some malloc instances in symbols.
 -----
 eu-readelf --symbols /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.19.so | grep malloc$
  1181: 0000000000080700   5332 FUNC    LOCAL  DEFAULT       12 _int_malloc
  4537: 00000000000831d0    339 FUNC    LOCAL  DEFAULT       12 __GI___libc_malloc
  5545: 00000000000831d0    339 FUNC    LOCAL  DEFAULT       12 __malloc
  6063: 00000000000831d0    339 FUNC    GLOBAL DEFAULT       12 malloc
  7302: 00000000000831d0    339 FUNC    GLOBAL DEFAULT       12 __libc_malloc
 -----
As you an see, malloc and __libc_malloc have same address, and actually
__libc_malloc has an entry in debuginfo. So you can set up a probe on
__libc_malloc.

To fix this problem shortly, perf probe simply falls back to find probe
point(malloc) in symbols if it is not found in debuginfo.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20141231062747.2087.80961.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb141..7f9b863 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -495,9 +495,11 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	if (ntevs == 0)	{	/* No error but failed to find probe point. */
-		pr_warning("Probe point '%s' not found.\n",
+		pr_warning("Probe point '%s' not found in debuginfo.\n",
 			   synthesize_perf_probe_point(&pev->point));
-		return -ENOENT;
+		if (need_dwarf)
+			return -ENOENT;
+		return 0;
 	}
 	/* Error path : ntevs < 0 */
 	pr_debug("An error occurred in debuginfo analysis (%d).\n", ntevs);
