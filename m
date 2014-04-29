Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaD2NsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:48:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaD2Nr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:47:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/6] perf tools: Handle EINTR error for readn/writen
Date: Tue, 29 Apr 2014 15:47:45 +0200
Message-Id: <1398779270-10271-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
References: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Those readn/writen functions are to ensure read/write does I/O for
a given size exactly.  But ion() - its implementation - does not
handle in case it returns prematurely due to a signal.  As it's not
an error itself so just retry the operation.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398346054-3322-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9f66549..7fff6be 100644
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
1.8.3.1

