Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaEAGbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:31:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaEAGbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:31:00 -0400
Date: Wed, 30 Apr 2014 23:30:38 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e148c76083dc06ce618d768c0bee0a0edda96a54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle EINTR error for readn/writen
Git-Commit-ID: e148c76083dc06ce618d768c0bee0a0edda96a54
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

Commit-ID:  e148c76083dc06ce618d768c0bee0a0edda96a54
Gitweb:     http://git.kernel.org/tip/e148c76083dc06ce618d768c0bee0a0edda96a54
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 24 Apr 2014 22:27:32 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 29 Apr 2014 14:26:30 +0200

perf tools: Handle EINTR error for readn/writen

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
 
