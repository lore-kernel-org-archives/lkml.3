Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaHNCXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:23:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40818 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaHNCW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:57 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-bd-53ec1d7ef0b4
Subject: [PATCH 12/13] perf help: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:53 +0000
Message-ID: <20140814022253.3545.82136.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error messages
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-help.c |   20 ++++++++++++++++----
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

