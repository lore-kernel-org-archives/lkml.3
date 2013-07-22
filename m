Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3GVMo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:44:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3GVMoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:44:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 3/5] perf tests: Add DESTDIR=TMP_DEST tests/make variable
Date: Mon, 22 Jul 2013 14:43:32 +0200
Message-Id: <1374497014-2817-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding TMP_DEST tests/make variable to provide the
DESTDIR directory for installation tests.

Adding this to existing test targets, since DESTDIR
variable 'should not' affect other than install*
targets. We can always separate this if there's a
need for DESTDIR-free build test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
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
1.7.11.7

