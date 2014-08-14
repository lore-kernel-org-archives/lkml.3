Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaHNCXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:23:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:60848 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaHNCWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:55 -0400
X-AuditID: 85900ec0-d312bb9000001514-bc-53ec1d7c40f8
Subject: [PATCH 11/13] perf kvm: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:51 +0000
Message-ID: <20140814022251.3545.83718.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error messages
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-kvm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 14d03ed..1a4ef9c 100644
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

