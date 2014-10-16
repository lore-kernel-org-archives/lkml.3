Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaJPDKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:10:43 -0400
Received: from [119.145.14.65] ([119.145.14.65]:62443 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPDKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:10:41 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Wang Nan <wangnan0@huawei.com>,
        Waiman Long <Waiman.Long@hp.com>
CC: <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] perf tools: ensure return negitive value when write header error
Date: Thu, 16 Oct 2014 11:08:29 +0800
Message-ID: <1413428909-80017-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/header.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ce0de00..39b80ac 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -605,8 +605,10 @@ static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
 			break;
 	}
 
-	if (ret)
+	if (ret) {
+		ret = -1;
 		goto done;
+	}
 
 	s = buf;
 
@@ -950,7 +952,8 @@ static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
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
1.8.4

