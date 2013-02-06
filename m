Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3BFF5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:57:38 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51050 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3BFF5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:57:35 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-0d-5111f0c972f8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf sort: Check return value of strdup()
Date: Wed,  6 Feb 2013 14:57:17 +0900
Message-Id: <1360130237-9963-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
References: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When setup_sorting() is called, 'str' is passed to strtok_r() but it's
not checked to have a valid pointer.  As strtok_r() accepts NULL
pointer on a first argument and use the third argument in that case,
it can cause a trouble since our third argument, tmp, is not
initialized.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d8b48827a17e..d41926cb9e3f 100644
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
1.7.11.7

