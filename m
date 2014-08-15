Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaHOQvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:44864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaHOQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:22 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/18] perf help: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:50:02 -0300
Message-Id: <1408121403-11919-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
index 0384d930480b..25d20628212e 100644
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
-- 
1.9.3

