Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3GWHsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:48:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3GWHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:48:18 -0400
Date: Tue, 23 Jul 2013 00:47:51 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c9311674e73345d4d02595c80d43f4bcf9ff3a3f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1374497014-2817-4-git-send-email-jolsa@redhat.com>
References: <1374497014-2817-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add DESTDIR=TMP_DEST tests/
 make variable
Git-Commit-ID: c9311674e73345d4d02595c80d43f4bcf9ff3a3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:47:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9311674e73345d4d02595c80d43f4bcf9ff3a3f
Gitweb:     http://git.kernel.org/tip/c9311674e73345d4d02595c80d43f4bcf9ff3a3f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 22 Jul 2013 14:43:32 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 16:52:50 -0300

perf tests: Add DESTDIR=TMP_DEST tests/make variable

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
