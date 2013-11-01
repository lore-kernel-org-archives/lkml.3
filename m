Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3KAJZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:25:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39972 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3KAJZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:25:15 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] perf tool: remove an unnecessary function call while process pipe events
Date: Fri,  1 Nov 2013 17:25:00 +0800
Message-Id: <1383297900-3749-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

perf_session_free_sample_buffers() can be removed from
__perf_session__process_pipe_events(), since the ordered_samples buffer is not
used while samples are read from the pipe.
__perf_session__process_pipe_events() is only used while process the events from
pipe. While the sample are read from pipe, the ordered_samples is forbidden.
Refer to the following code in perf_session__new():
 150         if (tool && tool->ordering_requires_timestamps &&
 151             tool->ordered_samples && !perf_evlist__sample_id_all(self->evlist)) {
 152                 dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
 153                 tool->ordered_samples = false;
 154         }
If pipe is used, perf_evlist__sample_id_all(self->evlist) always return 0. Because
session->evlist is empty util a attr_event is read.

Thanks
Chenggang Qin

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
 tools/perf/util/session.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 568b750..b69c28a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1251,7 +1251,6 @@ done:
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(self, tool);
-	perf_session_free_sample_buffers(self);
 	return err;
 }
 
-- 
1.7.8.rc2.5.g815b

