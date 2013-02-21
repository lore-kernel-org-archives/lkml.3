Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3BURRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:17:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59020 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3BURRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:17:05 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH] perf: define LIBLOCKDEP_LIBS to fix linker errors
Date: Thu, 21 Feb 2013 18:16:56 +0100
Message-Id: <1361467016-4329-1-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359942644-26371-7-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-7-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXTLIBS has to include -llockdep, so that perf can be linked against
liblockdep properly by gcc 4.6 or newer. That can be done by setting
LIBLOCKDEP_LIBS to "-llockdep", as it's already included in EXTLIBS.
Without this fix, building perf will fail with the following errors:

builtin-sched.o: In function `thread_func':
/linux/tools/perf/builtin-sched.c:471:
undefined reference to `liblockdep_set_thread'
builtin-sched.o: In function `liblockdep_pthread_mutex_lock':
/linux/tools/perf/../lib/lockdep/include/liblockdep/mutex.h:41:
undefined reference to `lock_acquire'
builtin-sched.o: In function `liblockdep_pthread_mutex_unlock':
/linux/tools/perf/../lib/lockdep/include/liblockdep/mutex.h:48:
undefined reference to `lock_release'

Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
---
 tools/perf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 785cd51..8d5c9eb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -576,8 +576,9 @@ ifndef NO_LIBLOCKDEP
 # for linking with liblockdep library, run like:
 # make LIBLOCKDEP=1
 ifeq ($(LOCKDEP),1)
+	LIBLOCKDEP_LIBS := -llockdep
 	LIBLOCKDEP_CFLAGS  := -I../lib/lockdep/include -D__USE_LIBLOCKDEP
-	LIBLOCKDEP_LDFLAGS := -L../lib/lockdep/ -llockdep
+	LIBLOCKDEP_LDFLAGS := -L../lib/lockdep/ $(LIBLOCKDEP_LIBS)
 endif
 
 FLAGS_LIBLOCKDEP=$(LIBLOCKDEP_CFLAGS) $(ALL_CFLAGS) $(LIBLOCKDEP_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-- 
1.8.0.3

