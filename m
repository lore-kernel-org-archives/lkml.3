Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaHRI0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:26:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaHRI0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:26:11 -0400
Date: Mon, 18 Aug 2014 01:25:27 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-ede395d27c60c06a2173e7a9c0f4a929a1fef73e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022253.3545.82136.stgit@kbuild-fedora.novalocal>
References: <20140814022253.3545.82136.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf help: Use strerror_r instead of strerror
Git-Commit-ID: ede395d27c60c06a2173e7a9c0f4a929a1fef73e
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

Commit-ID:  ede395d27c60c06a2173e7a9c0f4a929a1fef73e
Gitweb:     http://git.kernel.org/tip/ede395d27c60c06a2173e7a9c0f4a929a1fef73e
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:53 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 13:08:26 -0300

perf help: Use strerror_r instead of strerror

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022253.3545.82136.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-help.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 0384d93..25d2062 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -103,6 +103,8 @@ static int check_emacsclient_version(void)
 
 static void exec_woman_emacs(const char *path, const char *page)
 {
+	char sbuf[STRERR_BUFSIZE];
+
 	if (!check_emacsclient_version()) {
 		/* This works only with emacsclient version >= 22. */
 		struct strbuf man_page = STRBUF_INIT;
@@ -111,16 +113,19 @@ static void exec_woman_emacs(const char *path, const char *page)
 			path = "emacsclient";
 		strbuf_addf(&man_page, "(woman \"%s\")", page);
 		execlp(path, "emacsclient", "-e", man_page.buf, NULL);
-		warning("failed to exec '%s': %s", path, strerror(errno));
+		warning("failed to exec '%s': %s", path,
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 	}
 }
 
 static void exec_man_konqueror(const char *path, const char *page)
 {
 	const char *display = getenv("DISPLAY");
+
 	if (display && *display) {
 		struct strbuf man_page = STRBUF_INIT;
 		const char *filename = "kfmclient";
+		char sbuf[STRERR_BUFSIZE];
 
 		/* It's simpler to launch konqueror using kfmclient. */
 		if (path) {
@@ -139,24 +144,31 @@ static void exec_man_konqueror(const char *path, const char *page)
 			path = "kfmclient";
 		strbuf_addf(&man_page, "man:%s(1)", page);
 		execlp(path, filename, "newTab", man_page.buf, NULL);
-		warning("failed to exec '%s': %s", path, strerror(errno));
+		warning("failed to exec '%s': %s", path,
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 	}
 }
 
 static void exec_man_man(const char *path, const char *page)
 {
+	char sbuf[STRERR_BUFSIZE];
+
 	if (!path)
 		path = "man";
 	execlp(path, "man", page, NULL);
-	warning("failed to exec '%s': %s", path, strerror(errno));
+	warning("failed to exec '%s': %s", path,
+		strerror_r(errno, sbuf, sizeof(sbuf)));
 }
 
 static void exec_man_cmd(const char *cmd, const char *page)
 {
 	struct strbuf shell_cmd = STRBUF_INIT;
+	char sbuf[STRERR_BUFSIZE];
+
 	strbuf_addf(&shell_cmd, "%s %s", cmd, page);
 	execl("/bin/sh", "sh", "-c", shell_cmd.buf, NULL);
-	warning("failed to exec '%s': %s", cmd, strerror(errno));
+	warning("failed to exec '%s': %s", cmd,
+		strerror_r(errno, sbuf, sizeof(sbuf)));
 }
 
 static void add_man_viewer(const char *name)
