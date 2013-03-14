Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3CNISJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:18:09 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38802 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3CNISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:18:06 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2]Perf: Fix Makefile to clean all object files
Date: Thu, 14 Mar 2013 16:17:46 +0800
Message-Id: <1363249066-25905-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

If we execute "make clean" in perf's directory, many object files cannot be
cleaned in the current version.
For example:
While we run "make clean" in perf's directory, and run the command:
"fine ./ -name "*.o""
we will get:
------------------------------------
./arch/x86/util/unwind.o
./arch/x86/util/header.o
./arch/x86/util/dwarf-regs.o
./util/scripting-engines/trace-event-python.o
./util/scripting-engines/trace-event-perl.o
./util/probe-finder.o
./util/dwarf-aux.o
./util/unwind.o
... ...
------------------------------------
These ".o" files are not cleaned.

The reason is:
These object files are added into "BUILTIN_OBJS" while "make" process check the environment.
If the make command is "clean", the environment check process is not executed. So,
these object files will not be added into "BUILTIN_OBJS" while we execute "make clean".

This patch fixed this problem.
We only add a command:
"find . -name "*.o" -exec rm -f {} \;"

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..dec08ba 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1174,6 +1174,7 @@ clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
+	find . -name "*.o" -exec rm -f {} \;
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-- 
1.7.8.rc2.5.g815b

