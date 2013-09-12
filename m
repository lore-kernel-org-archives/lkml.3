Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3ILNIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:08:55 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63277 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3ILNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:08:54 -0400
Date: Thu, 12 Sep 2013 15:08:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>
Subject: Re: [PATCH 14/16] perf kvm: reuse some code of
 perf_kvm__timerfd_create()
Message-ID: <20130912130849.GA23826@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
 <1369527896-3650-15-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369527896-3650-15-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., I tried to build perf on a really old distro that has no timerfd.h, 
and got:

builtin-kvm.c:22:25: error: sys/timerfd.h: No such file or directory
cc1: warnings being treated as errors
builtin-kvm.c: In function ‘perf_kvm__timerfd_create’:
builtin-kvm.c:967: warning: implicit declaration of function ‘timerfd_create’
builtin-kvm.c:967: warning: nested extern declaration of ‘timerfd_create’
builtin-kvm.c:967: error: ‘TFD_NONBLOCK’ undeclared (first use in this function)
builtin-kvm.c:967: error: (Each undeclared identifier is reported only once
builtin-kvm.c:967: error: for each function it appears in.)
builtin-kvm.c:978: warning: implicit declaration of function ‘timerfd_settime’
builtin-kvm.c:978: warning: nested extern declaration of ‘timerfd_settime’
make: *** [builtin-kvm.o] Error 1
make: *** Waiting for unfinished jobs....

The quick patch below made it build - but it's incomplete, I have not 
filled in the config/* details to generate HAVE_TIMERFD, I only made 
builtin-kvm.o build.

Thanks,

	Ingo

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 935d522..5cae8f2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -19,7 +19,22 @@
 #include "util/top.h"
 
 #include <sys/prctl.h>
-#include <sys/timerfd.h>
+#ifdef HAVE_TIMERFD
+# include <sys/timerfd.h>
+#else
+# define TFD_NONBLOCK -1
+static int timerfd_create(clockid_t __clock_id __maybe_unused, int __flags __maybe_unused)
+{
+	return -1;
+}
+static int timerfd_settime(int __ufd __maybe_unused, int __flags __maybe_unused,
+			const struct itimerspec *__utmr __maybe_unused,
+			struct itimerspec *__otmr __maybe_unused)
+{
+	return -1;
+}
+
+#endif
 
 #include <termios.h>
 #include <semaphore.h>

