Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaJ3Gpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:45:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbaJ3Gpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:45:50 -0400
Date: Wed, 29 Oct 2014 23:45:12 -0700
From: tip-bot for Wang Nan <tipbot@zytor.com>
Message-ID: <tip-ed3077585f2f041e0db0fc41060b69673e98963b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jolsa@redhat.com, mingo@redhat.com, adrian.hunter@intel.com,
        mingo@kernel.org, tglx@linutronix.de, Waiman.Long@hp.com,
        acme@redhat.com, paulus@samba.org, lizefan@huawei.com,
        namhyung.kim@lge.com, wangnan0@huawei.com
Reply-To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jolsa@redhat.com, Waiman.Long@hp.com, acme@redhat.com,
        tglx@linutronix.de, mingo@kernel.org, adrian.hunter@intel.com,
        mingo@redhat.com, lizefan@huawei.com, paulus@samba.org,
        wangnan0@huawei.com, namhyung.kim@lge.com
In-Reply-To: <1413428909-80017-1-git-send-email-wangnan0@huawei.com>
References: <1413428909-80017-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Ensure return negative value when write header error
Git-Commit-ID: ed3077585f2f041e0db0fc41060b69673e98963b
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

Commit-ID:  ed3077585f2f041e0db0fc41060b69673e98963b
Gitweb:     http://git.kernel.org/tip/ed3077585f2f041e0db0fc41060b69673e98963b
Author:     Wang Nan <wangnan0@huawei.com>
AuthorDate: Thu, 16 Oct 2014 11:08:29 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:48 -0200

perf tools: Ensure return negative value when write header error

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
index 26f5b2f..0ecf4a3 100644
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
