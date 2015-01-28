Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbbA1VYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:24:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762107AbbA1Utw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:52 -0500
Date: Wed, 28 Jan 2015 07:00:25 -0800
From: tip-bot for Wang Nan <tipbot@zytor.com>
Message-ID: <tip-75e0b5f010837f29b5773653a248852a7317562b@git.kernel.org>
Cc: wangnan0@huawei.com, tglx@linutronix.de, acme@redhat.com,
        namhyung@kernel.org, lizefan@huawei.com, jolsa@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org
Reply-To: wangnan0@huawei.com, lizefan@huawei.com, namhyung@kernel.org,
        tglx@linutronix.de, acme@redhat.com, hpa@zytor.com, jolsa@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1421671397-4659-1-git-send-email-wangnan0@huawei.com>
References: <1421671397-4659-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripting perl: Force to use stdbool
Git-Commit-ID: 75e0b5f010837f29b5773653a248852a7317562b
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

Commit-ID:  75e0b5f010837f29b5773653a248852a7317562b
Gitweb:     http://git.kernel.org/tip/75e0b5f010837f29b5773653a248852a7317562b
Author:     Wang Nan <wangnan0@huawei.com>
AuthorDate: Mon, 19 Jan 2015 20:43:17 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:05:00 -0300

perf scripting perl: Force to use stdbool

When building perf for arm64 I hit a warning (and be treated as an
error) like below:

 aarch64-oe-linux-gcc -o .../scripts/perl/Perf-Trace-Util/Context.o -c -Wbad-function-cast \
         ... scripts/perl/Perf-Trace-Util/Context.c

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
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Link: http://lkml.kernel.org/r/1421671397-4659-1-git-send-email-wangnan0@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
