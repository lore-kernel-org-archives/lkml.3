Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3KAJ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:29:42 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51495 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KAJ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:29:39 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 2/4] perf tools: relate 'start' & 'end' to perf_session
Date: Fri,  1 Nov 2013 17:29:04 +0800
Message-Id: <1383298146-3860-3-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
References: <1383298146-3860-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the value to start and end to struct perf_session.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-report.c |    5 +++++
 tools/perf/util/session.c   |    3 +++
 tools/perf/util/session.h   |    2 ++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e9e9d0a..d3c1c8a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -889,6 +889,11 @@ repeat:
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (tstart)
+		session->tstart = tstart * 1e6;
+	if (tend)
+		session->tend = tend * 1e6;
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 568b750..193bb6a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -134,6 +134,9 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machines__init(&self->machines);
 
+	self->tstart = 0;
+	self->tend = ULLONG_MAX;
+
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
 			goto out_delete;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 04bf737..c9a6c27 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -37,6 +37,8 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
+	u64			tstart;
+	u64			tend;
 	struct ordered_samples	ordered_samples;
 	char			filename[1];
 };
-- 
1.7.8.rc2.5.g815b

