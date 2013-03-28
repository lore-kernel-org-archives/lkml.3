Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3C1RKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:10:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36318 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3C1RCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 34/36] perf map browser: Use ui_browser__input_window()
Date: Thu, 28 Mar 2013 14:02:34 -0300
Message-Id: <1364490156-32064-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/ui/browsers/map.c |   44 +++++------------------------------------
 1 files changed, 6 insertions(+), 38 deletions(-)

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
-- 
1.7.1

