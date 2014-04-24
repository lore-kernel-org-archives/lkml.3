Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaDXN1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:27:44 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45906 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaDXN1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:27:41 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v3 1/3] perf tools: Handle EINTR error for readn/writen
Date: Thu, 24 Apr 2014 22:27:32 +0900
Message-Id: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those readn/writen functions are to ensure read/write does I/O for
a given size exactly.  But ion() - its implementation - does not
handle in case it returns prematurely due to a signal.  As it's not
an error itself so just retry the operation.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/util.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9f66549562bd..7fff6be07f07 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -166,6 +166,8 @@ static ssize_t ion(bool is_read, int fd, void *buf, size_t n)
 		ssize_t ret = is_read ? read(fd, buf, left) :
 					write(fd, buf, left);
 
+		if (ret < 0 && errno == EINTR)
+			continue;
 		if (ret <= 0)
 			return ret;
 
-- 
1.7.9.2

