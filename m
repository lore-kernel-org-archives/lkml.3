Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaHOQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:44851 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaHOQvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:18 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/18] perf kvm: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:50:01 -0300
Message-Id: <1408121403-11919-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022251.3545.83718.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 14d03edc81c2..1a4ef9cd9d5f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -990,6 +990,7 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 	int err, rc = -1;
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = kvm->evlist;
+	char sbuf[STRERR_BUFSIZE];
 
 	perf_evlist__config(evlist, &kvm->opts);
 
@@ -1026,12 +1027,14 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		printf("Couldn't create the events: %s\n", strerror(errno));
+		printf("Couldn't create the events: %s\n",
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out;
 	}
 
 	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
-		ui__error("Failed to mmap the events: %s\n", strerror(errno));
+		ui__error("Failed to mmap the events: %s\n",
+			  strerror_r(errno, sbuf, sizeof(sbuf)));
 		perf_evlist__close(evlist);
 		goto out;
 	}
-- 
1.9.3

