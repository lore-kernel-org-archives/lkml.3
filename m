Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965836AbaGPTRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:17:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbaGPTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:17:08 -0400
Date: Wed, 16 Jul 2014 12:16:46 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-f8d9ccde2be4c24bfb8787af36a59a981b00a02d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <87ioneo7qh.wl%yarygin@linux.vnet.ibm.com>
References: <87ioneo7qh.wl%yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Allow to use cpuinfo on s390
Git-Commit-ID: f8d9ccde2be4c24bfb8787af36a59a981b00a02d
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

Commit-ID:  f8d9ccde2be4c24bfb8787af36a59a981b00a02d
Gitweb:     http://git.kernel.org/tip/f8d9ccde2be4c24bfb8787af36a59a981b00a02d
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 18:08:22 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 16:55:24 -0300

perf tools: Allow to use cpuinfo on s390

This patch defines CPUINFO_PROC for s390 and implements get_cpuid().

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87ioneo7qh.wl%yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/s390/Makefile      |  1 +
 tools/perf/arch/s390/util/header.c | 28 ++++++++++++++++++++++++++++
 tools/perf/perf-sys.h              |  1 +
 3 files changed, 30 insertions(+)

diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..744e629 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -2,3 +2,4 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/s390/util/header.c b/tools/perf/arch/s390/util/header.c
new file mode 100644
index 0000000..9fa6c3e
--- /dev/null
+++ b/tools/perf/arch/s390/util/header.c
@@ -0,0 +1,28 @@
+/*
+ * Implementation of get_cpuid().
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+int get_cpuid(char *buffer, size_t sz)
+{
+	const char *cpuid = "IBM/S390";
+
+	if (strlen(cpuid) + 1 > sz)
+		return -1;
+
+	strcpy(buffer, cpuid);
+	return 0;
+}
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 5268a14..937e432 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -54,6 +54,7 @@
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#define CPUINFO_PROC	"vendor_id"
 #endif
 
 #ifdef __sh__
