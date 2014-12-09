Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaLIRfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:35:08 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36559 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaLIRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:35:00 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 4/8] perf probe powerpc: Handle powerpc dot symbols
Date: Tue,  9 Dec 2014 23:04:02 +0530
Message-Id: <6e97fb2cf77d91057fdcda0a75c58cfa63a7313c.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0025-0000-0000-000000B14C31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up various perf aspects related to ppc64's usage of dot functions:
- ignore leading '.' when generating event names and when looking for
  existing events.
- use the proper prefix when ignoring SyS symbol lookups.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/probe-event.c | 8 ++++++++
 tools/perf/util/symbol.c      | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c7e01ef..d465f7c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2080,6 +2080,10 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 {
 	int i, ret;
 
+	/* Skip the leading dot on powerpc */
+	if (*base == '.')
+		base++;
+
 	/* Try no suffix */
 	ret = e_snprintf(buf, len, "%s", base);
 	if (ret < 0) {
@@ -2538,6 +2542,10 @@ int del_perf_probe_events(struct strlist *dellist)
 			event = str;
 		}
 
+		/* Skip the leading dot on powerpc */
+		if (event && *event == '.')
+			event++;
+
 		ret = e_snprintf(buf, 128, "%s:%s", group, event);
 		if (ret < 0) {
 			pr_err("Failed to copy event.");
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0783311..cc04475 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -137,6 +137,12 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 	if (na >= 10 && !strncmp(syma->name, "compat_SyS", 10))
 		return SYMBOL_B;
 
+	/* On powerpc, ignore the dot variants */
+	if (na >= 4 && !strncmp(syma->name, ".SyS", 4))
+		return SYMBOL_B;
+	if (na >= 11 && !strncmp(syma->name, ".compat_SyS", 11))
+		return SYMBOL_B;
+
 	return SYMBOL_A;
 }
 
-- 
2.1.3

