Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850AbaFLMEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:04:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbaFLMEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:04:41 -0400
Date: Thu, 12 Jun 2014 05:03:55 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-h4kby5wyp6nfev3882rzm3r9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Show the inner make output when an error happens
Git-Commit-ID: a5c5009f72ced4b90f8715137784c0cd8b244544
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5c5009f72ced4b90f8715137784c0cd8b244544
Gitweb:     http://git.kernel.org/tip/a5c5009f72ced4b90f8715137784c0cd8b244544
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Jun 2014 17:15:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Jun 2014 12:14:22 -0300

perf tests: Show the inner make output when an error happens

Before:

  [acme@zoo linux]$ make -C tools/perf -f tests/make make_static
  make: Entering directory `/home/git/linux/tools/perf'
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.JcWuM4Zu9f LDFLAGS=-static
  make: *** [make_static] Error 1
  make: Leaving directory `/home/git/linux/tools/perf'
  [acme@zoo linux]$

After:

  [acme@zoo linux]$ make -C tools/perf -f tests/make make_static
  make: Entering directory `/home/git/linux/tools/perf'
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.X3su83i14u LDFLAGS=-static
  cd . && make -f Makefile DESTDIR=/tmp/tmp.X3su83i14u LDFLAGS=-static
    BUILD:   Doing 'make -j4' parallel build
  config/Makefile:303: *** No static glibc found, please install glibc-static.  Stop.
  make[1]: *** [all] Error 2
    test: test -x ./perf
  make: Leaving directory `/home/git/linux/tools/perf'
  [acme@zoo linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-h4kby5wyp6nfev3882rzm3r9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2f92d6e..69a71ff 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -205,8 +205,7 @@ $(run):
 	( eval $$cmd ) >> $@ 2>&1; \
 	echo "  test: $(call test,$@)" >> $@ 2>&1; \
 	$(call test,$@) && \
-	rm -f $@ \
-	rm -rf $$TMP_DEST
+	rm -rf $@ $$TMP_DEST || (cat $@ ; false)
 
 $(run_O):
 	$(call clean)
@@ -217,9 +216,7 @@ $(run_O):
 	( eval $$cmd ) >> $@ 2>&1 && \
 	echo "  test: $(call test_O,$@)" >> $@ 2>&1; \
 	$(call test_O,$@) && \
-	rm -f $@ && \
-	rm -rf $$TMP_O \
-	rm -rf $$TMP_DEST
+	rm -rf $@ $$TMP_O $$TMP_DEST || (cat $@ ; false)
 
 tarpkg:
 	@cmd="$(PERF)/tests/perf-targz-src-pkg $(PERF)"; \
