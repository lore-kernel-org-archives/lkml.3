Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaJ2OIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:08:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:41281 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594AbaJ2OIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:08:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Wang Nan <wangnan0@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizefan@huawei.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/25] perf tools: Ensure return negative value when write header error
Date: Wed, 29 Oct 2014 12:06:25 -0200
Message-Id: <1414591597-2763-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Nan <wangnan0@huawei.com>

When 'perf record' write headers, it calls write_xxx in
tools/perf/util/header.c, and check return value. It rolls back all
working only when return value is negative.

This patch ensures write_cpudesc() and write_total_mem() return negative number
when error. Without this patch, headers reported by 'perf report' header is
error in some platform. Following output is caputured on ARM, which doesn't
contain "Processor" field in /proc/cpuinfo. See "cpudesc", "total memory" and
"cmdline" field.

   bash-4.2# perf record ls
   ...
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.001 MB perf.data (~36 samples) ]
   bash-4.2# perf report --stdio --header
   Error:
   The perf.data file has no samples!
   # ========
   # captured on: Fri Sep 12 10:09:10 2014
   # hostname : arma15el
   # os release : 3.17.0+
   # perf version : 3.10.53
   # arch : armv7l
   # nrcpus online : 4
   # nrcpus avail : 1
   # cpudesc : (null)
   # total memory : 0 kB
   # cmdline :
   # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
   # pmu mappings: not available
   # ========
   #

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/r/1413428909-80017-1-git-send-email-wangnan0@huawei.com
Signed-off-by: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26f5b2fe5dc8..0ecf4a304cbc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -601,8 +601,10 @@ static int __write_cpudesc(int fd, const char *cpuinfo_proc)
 			break;
 	}
 
-	if (ret)
+	if (ret) {
+		ret = -1;
 		goto done;
+	}
 
 	s = buf;
 
@@ -965,7 +967,8 @@ static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
 		n = sscanf(buf, "%*s %"PRIu64, &mem);
 		if (n == 1)
 			ret = do_write(fd, &mem, sizeof(mem));
-	}
+	} else
+		ret = -1;
 	free(buf);
 	fclose(fp);
 	return ret;
-- 
1.9.3

