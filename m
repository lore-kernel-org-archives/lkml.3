Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaLRG3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:29:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaLRG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:53 -0500
Date: Wed, 17 Dec 2014 22:29:15 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2f6mtm8xu3wo5lhkql6jdblh@git.kernel.org>
Cc: dzickus@redhat.com, namhyung@kernel.org, paulus@samba.org, efault@gmx.de,
        fweisbec@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        mingo@kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        bp@suse.de, hpa@zytor.com, dsahern@gmail.com
Reply-To: jolsa@redhat.com, peterz@infradead.org, acme@redhat.com,
        mingo@kernel.org, dsahern@gmail.com, hpa@zytor.com, bp@suse.de,
        eranian@google.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        namhyung@kernel.org, dzickus@redhat.com, tglx@linutronix.de,
        adrian.hunter@intel.com, fweisbec@gmail.com, efault@gmx.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Do not use hard coded value for a mmap_pages default
Git-Commit-ID: 8185e881f9fd9a2fa01f9d45616f8587f485f2a6
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

Commit-ID:  8185e881f9fd9a2fa01f9d45616f8587f485f2a6
Gitweb:     http://git.kernel.org/tip/8185e881f9fd9a2fa01f9d45616f8587f485f2a6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 12 Dec 2014 17:46:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Dec 2014 13:38:26 -0300

perf evlist: Do not use hard coded value for a mmap_pages default

So far what is in there by default is what we were using: 512KB + the
control page, but the admin may change that, and if it does to a smaller
value, all calls to tooling for non root users start failing, requiring
that the user manually set --mmap_pages/-m.

Use instead what is in /proc/sys/kernel/perf_event_mlock_kb.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2f6mtm8xu3wo5lhkql6jdblh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7847f38..ac80868 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -893,10 +893,22 @@ out_unmap:
 
 static size_t perf_evlist__mmap_size(unsigned long pages)
 {
-	/* 512 kiB: default amount of unprivileged mlocked memory */
-	if (pages == UINT_MAX)
-		pages = (512 * 1024) / page_size;
-	else if (!is_power_of_2(pages))
+	if (pages == UINT_MAX) {
+		int max;
+
+		if (sysctl__read_int("kernel/perf_event_mlock_kb", &max) < 0) {
+			/*
+			 * Pick a once upon a time good value, i.e. things look
+			 * strange since we can't read a sysctl value, but lets not
+			 * die yet...
+			 */
+			max = 512;
+		} else {
+			max -= (page_size / 1024);
+		}
+
+		pages = (max * 1024) / page_size;
+	} else if (!is_power_of_2(pages))
 		return 0;
 
 	return (pages + 1) * page_size;
