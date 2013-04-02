Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab3DBKD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:03:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760379Ab3DBKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:03:26 -0400
Date: Tue, 2 Apr 2013 03:03:09 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-elrijp95pijt66y6mmij4xm1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf map browser: Use ui_browser__input_window()
Git-Commit-ID: a403253634141137e9a0585a6044e7c059c92f1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 03:03:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a403253634141137e9a0585a6044e7c059c92f1b
Gitweb:     http://git.kernel.org/tip/a403253634141137e9a0585a6044e7c059c92f1b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 28 Mar 2013 11:07:37 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:23:10 -0300

perf map browser: Use ui_browser__input_window()

Instead of an ad-hoc, libnewt based equivalent.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-elrijp95pijt66y6mmij4xm1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/map.c | 44 ++++++--------------------------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index 98851d5..10b549c 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -1,6 +1,5 @@
 #include "../libslang.h"
 #include <elf.h>
-#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <string.h>
@@ -10,41 +9,9 @@
 #include "../../util/symbol.h"
 #include "../browser.h"
 #include "../helpline.h"
+#include "../keysyms.h"
 #include "map.h"
 
-static int ui_entry__read(const char *title, char *bf, size_t size, int width)
-{
-	struct newtExitStruct es;
-	newtComponent form, entry;
-	const char *result;
-	int err = -1;
-
-	newtCenteredWindow(width, 1, title);
-	form = newtForm(NULL, NULL, 0);
-	if (form == NULL)
-		return -1;
-
-	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
-	if (entry == NULL)
-		goto out_free_form;
-
-	newtFormAddComponent(form, entry);
-	newtFormAddHotKey(form, NEWT_KEY_ENTER);
-	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(form, CTRL('c'));
-	newtFormRun(form, &es);
-
-	if (result != NULL) {
-		strncpy(bf, result, size);
-		err = 0;
-	}
-out_free_form:
-	newtPopWindow();
-	newtFormDestroy(form);
-	return err;
-}
-
 struct map_browser {
 	struct ui_browser b;
 	struct map	  *map;
@@ -78,10 +45,11 @@ static int map_browser__search(struct map_browser *self)
 {
 	char target[512];
 	struct symbol *sym;
-	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
-
-	if (err)
-		return err;
+	int err = ui_browser__input_window("Search by name/addr",
+					   "Prefix with 0x to search by address",
+					   target, "ENTER: OK, ESC: Cancel", 0);
+	if (err != K_ENTER)
+		return -1;
 
 	if (target[0] == '0' && tolower(target[1]) == 'x') {
 		u64 addr = strtoull(target, NULL, 16);
