Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3K2Lqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/6] perf tools: Add PERF_EVLIST__ERRNO_IOCTL_ID_GROUP internal error
Date: Fri, 29 Nov 2013 12:45:08 +0100
Message-Id: <1385725510-20118-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding internal error (PERF_EVLIST__ERRNO_IOCTL_ID_GROUP) for
cases when ioctl syscall fails during perf_evlist__mmap call.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/util/evlist.c | 9 ++++++++-
 tools/perf/util/evlist.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4af0cca..f9c5abd 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -399,8 +399,10 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	 * This way does not work with group format read, so bail
 	 * out in that case.
 	 */
-	if (perf_evlist__read_format(evlist) & PERF_FORMAT_GROUP)
+	if (perf_evlist__read_format(evlist) & PERF_FORMAT_GROUP) {
+		SET_ERR(IOCTL_ID_GROUP);
 		return -1;
+	}
 
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 	    read(fd, &read_data, sizeof(read_data)) == -1)
@@ -676,6 +678,11 @@ static void __perf_evlist__strerror(struct perf_evlist *evlist,
 	case PERF_EVLIST__ERRNO_OPEN:
 		strerror_open(evlist, buf, size);
 		return;
+	case PERF_EVLIST__ERRNO_IOCTL_ID_GROUP:
+		scnprintf(buf, size,
+			"Cannot read event group on this kernel.\n"
+			"Please consider kernel update (v3.12+).\n");
+		return;
 	default:
 		scnprintf(buf, size, "Unknown error\n");
 		return;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 48ac4c5..e5ce8c7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -21,6 +21,7 @@ enum {
 	PERF_EVLIST__ERRNO_SUCCESS		= 0,
 	PERF_EVLIST__ERRNO_MMAP			= 1,
 	PERF_EVLIST__ERRNO_OPEN			= 2,
+	PERF_EVLIST__ERRNO_IOCTL_ID_GROUP	= 3,
 };
 
 struct perf_mmap {
-- 
1.8.3.1

