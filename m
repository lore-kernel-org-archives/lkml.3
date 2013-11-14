Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3KNU0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:26:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3KNUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/10] perf ui browser: Fix segfault caused by off by one handling END key
Date: Thu, 14 Nov 2013 17:25:13 -0300
Message-Id: <1384460715-23198-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

$ perf record ls
$ perf report

Press 'down enter end'

Result:

Program received signal SIGSEGV, Segmentation fault.

The UI browser, used on a argv array would access past the end of the
array on SEEK_END because it wasn't using 'nr_entries - 1', fix it.

Reported-by: v.karpov@samsung.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=59291
Link: http://lkml.kernel.org/n/tip-3g83ipasqi219ktv764xzzjs@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3648d4ec041f..cbaa7af45513 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -569,7 +569,7 @@ void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence)
 		browser->top = browser->top + browser->top_idx + offset;
 		break;
 	case SEEK_END:
-		browser->top = browser->top + browser->nr_entries + offset;
+		browser->top = browser->top + browser->nr_entries - 1 + offset;
 		break;
 	default:
 		return;
-- 
1.8.1.4

