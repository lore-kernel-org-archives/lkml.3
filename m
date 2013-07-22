Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab3GVUXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:23:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GVUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:23:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/11] perf tests: Add DESTDIR=TMP_DEST tests/make variable
Date: Mon, 22 Jul 2013 17:22:36 -0300
Message-Id: <1374524559-9839-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding TMP_DEST tests/make variable to provide the DESTDIR directory for
installation tests.

Adding this to existing test targets, since DESTDIR variable 'should
not' affect other than install* targets. We can always separate this if
there's a need for DESTDIR-free build test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374497014-2817-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index dbbb62c..7646a00 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -118,23 +118,27 @@ clean := @(cd $(PERF); make -s -f $(MK) clean >/dev/null)
 
 $(run):
 	$(call clean)
-	@cmd="cd $(PERF) && make -f $(MK) $($@)"; \
+	@TMP_DEST=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) DESTDIR=$$TMP_DEST $($@)"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1; \
 	echo "  test: $(call test,$@)"; \
 	$(call test,$@) && \
-	rm -f $@
+	rm -f $@ \
+	rm -rf $$TMP_DEST
 
 $(run_O):
 	$(call clean)
 	@TMP_O=$$(mktemp -d); \
-	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP_O"; \
+	TMP_DEST=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) O=$$TMP_O DESTDIR=$$TMP_DEST $($(patsubst %_O,%,$@))"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1 && \
 	echo "  test: $(call test_O,$@)"; \
 	$(call test_O,$@) && \
 	rm -f $@ && \
-	rm -rf $$TMP_O
+	rm -rf $$TMP_O \
+	rm -rf $$TMP_DEST
 
 all: $(run) $(run_O)
 	@echo OK
-- 
1.8.1.4

