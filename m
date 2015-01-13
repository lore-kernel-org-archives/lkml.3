Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbAMNoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:44:15 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:52352 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:44:11 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>, <jolsa@kernel.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 3/5] perf tools: [uclibc] Avoid build splat for syscall numbers
Date: Tue, 13 Jan 2015 19:13:22 +0530
Message-ID: <1421156604-30603-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is due to duplicated unistd inclusion (via uClibc headers + kernel headers)
Also seen on ARM uClibc based tools

   ------- ARC build ---------->8-------------

  CC       util/evlist.o
In file included from
~/arc/k.org/arch/arc/include/uapi/asm/unistd.h:25:0,
                 from util/../perf-sys.h:10,
                 from util/../perf.h:15,
                 from util/event.h:7,
                 from util/event.c:3:
~/arc/k.org/include/uapi/asm-generic/unistd.h:906:0:
warning: "__NR_fcntl64" redefined [enabled by default]
 #define __NR_fcntl64 __NR3264_fcntl
 ^
In file included from
~/arc/gnu/INSTALL_1412-arc-2014.12-rc1/arc-snps-linux-uclibc/sysroot/usr/include/sys/syscall.h:24:0,
                 from util/../perf-sys.h:6,
   ----------------->8-------------------

   ------- ARM build ---------->8-------------

  CC FPIC  plugin_scsi.o
In file included from util/../perf-sys.h:9:0,
                 from util/../perf.h:15,
                 from util/cache.h:7,
                 from perf.c:12:
~/arc/k.org/arch/arm/include/uapi/asm/unistd.h:28:0:
warning: "__NR_restart_syscall" redefined [enabled by default]
In file included from
~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/sys/syscall.h:25:0,
                 from util/../perf-sys.h:6,
                 from util/../perf.h:15,
                 from util/cache.h:7,
                 from perf.c:12:
~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/bits/sysnum.h:17:0:
note: this is the location of the previous definition
   ----------------->8-------------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/perf/bench/sched-pipe.c | 2 +-
 tools/perf/builtin-top.c      | 1 -
 tools/perf/perf-sys.h         | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 07a8d7646a15..005cc283790c 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -19,12 +19,12 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <sys/wait.h>
-#include <linux/unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <assert.h>
 #include <sys/time.h>
 #include <sys/types.h>
+#include <sys/syscall.h>
 
 #include <pthread.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0aa7747ff139..233ffff1b31b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -66,7 +66,6 @@
 #include <sys/utsname.h>
 #include <sys/mman.h>
 
-#include <linux/unistd.h>
 #include <linux/types.h>
 
 static volatile int done;
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 3183809ff6d9..7b7cb7396b69 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -6,7 +6,6 @@
 #include <sys/syscall.h>
 #include <linux/types.h>
 #include <linux/perf_event.h>
-#include <asm/unistd.h>
 
 #if defined(__i386__)
 #define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-- 
1.9.1

