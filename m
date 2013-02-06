Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3BFVoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:44:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33195
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758758Ab3BFVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/17] perf sort: Check return value of strdup()
Date: Wed,  6 Feb 2013 18:44:09 -0300
Message-Id: <1360187059-12661-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When setup_sorting() is called, 'str' is passed to strtok_r() but it's
not checked to have a valid pointer.  As strtok_r() accepts NULL pointer
on a first argument and use the third argument in that case, it can
cause a trouble since our third argument, tmp, is not initialized.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1360130237-9963-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d8b4882..d41926c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -570,6 +570,11 @@ int setup_sorting(void)
 	char *tmp, *tok, *str = strdup(sort_order);
 	int ret = 0;
 
+	if (str == NULL) {
+		error("Not enough memory to setup sort keys");
+		return -ENOMEM;
+	}
+
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		ret = sort_dimension__add(tok);
-- 
1.8.1.1.361.gec3ae6e

