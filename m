Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHRIXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:23:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaHRIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:23:51 -0400
Date: Mon, 18 Aug 2014 01:22:50 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-6eb08660962a91212902869672dab5199827cbfd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022230.3545.99254.stgit@kbuild-fedora.novalocal>
References: <20140814022230.3545.99254.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Don'
 t use strerror if strlist__add failed
Git-Commit-ID: 6eb08660962a91212902869672dab5199827cbfd
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

Commit-ID:  6eb08660962a91212902869672dab5199827cbfd
Gitweb:     http://git.kernel.org/tip/6eb08660962a91212902869672dab5199827cbfd
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:30 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:53:36 -0300

perf probe: Don't use strerror if strlist__add failed

Since the strlist__add doesn't involves any IO, the failure reason must
be ENOMEM or EINVAL, moreover this is just a debug message, we don't
need to show the error string.

And also, if get_probe_trace_command_rawlist() returns NULL, it doesn't
mean the rawlist is empty, there is an error.  So caller must use
-ENOMEM for the error.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022230.3545.99254.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ac15ff7..bf39c23 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1881,7 +1881,7 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
 			p[idx] = '\0';
 		ret = strlist__add(sl, buf);
 		if (ret < 0) {
-			pr_debug("strlist__add failed: %s\n", strerror(-ret));
+			pr_debug("strlist__add failed (%d)\n", ret);
 			strlist__delete(sl);
 			return NULL;
 		}
@@ -1940,7 +1940,7 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 
 	rawlist = get_probe_trace_command_rawlist(fd);
 	if (!rawlist)
-		return -ENOENT;
+		return -ENOMEM;
 
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
@@ -2007,6 +2007,8 @@ static struct strlist *get_probe_trace_event_names(int fd, bool include_group)
 
 	memset(&tev, 0, sizeof(tev));
 	rawlist = get_probe_trace_command_rawlist(fd);
+	if (!rawlist)
+		return NULL;
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
