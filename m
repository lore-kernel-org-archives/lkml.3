Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbbASMtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:49:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20910 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:49:18 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <namhyung@kernel.org>, <acme@kernel.org>
Subject: [PATCH v2] perf: perl: force to use stdbool.
Date: Mon, 19 Jan 2015 20:43:17 +0800
Message-ID: <1421671397-4659-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20150119123808.GB12706@krava.brq.redhat.com>
References: <20150119123808.GB12706@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building perf for arm64 I hit a warning (and be treated as an
error) like below:

 aarch64-oe-linux-gcc -o .../util/scripting-engines/trace-event-python.o -c -Wbad-function-cast \
	 ... util/scripting-engines/trace-event-python.c

 In file included from .../usr/lib64/perl/5.14.3/CORE/perl.h:2464:0,
                  from Context.xs:23:
 /.../usr/lib64/perl/5.14.3/CORE/handy.h:108:0: error: "bool" redefined [-Werror]
  #  define bool char
  ^
 In file included from /.../usr/src/kernel/tools/include/linux/types.h:4:0,
                  from /.../usr/src/kernel/arch/arm64/include/uapi/asm/sigcontext.h:19,
		  from /.../usr/include/bits/sigcontext.h:27,
		  from /.../usr/include/signal.h:340,
		  from /.../usr/include/sys/param.h:28,
		  from /.../usr/lib64/perl/5.14.3/CORE/perl.h:678,
		  from Context.xs:23:
  /.../usr/lib/aarch64-oe-linux/gcc/aarch64-oe-linux/4.9.2/include/stdbool.h:33:0: note: this is the location of the previous definition
    #define bool _Bool

Looks like the failure is caused by arm64 uapi/asm/sigcontext.h, which
includes linux/types.h while other archs not.

Current perl consider this problem:

http://perl5.git.perl.org/perl.git/commit/bd31be4baa3ee68abdb92c0db3200efe0fad903b

However there are users which use old version of perl.

This patch includes stdbool.h before Context.xs and define HAS_BOOL to
prevent perl'e headers define its own 'bool'. Code is learn from perl's
git tree.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 790ceba..28431d1 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -5,7 +5,10 @@
  *	ANY CHANGES MADE HERE WILL BE LOST! 
  *
  */
-
+#include <stdbool.h>
+#ifndef HAS_BOOL
+# define HAS_BOOL 1
+#endif
 #line 1 "Context.xs"
 /*
  * Context.xs.  XS interfaces for perf script.
-- 
1.8.4

