Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbaGHTuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:50:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:58129 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbaGHTD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:03:59 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/16] perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
Date: Tue,  8 Jul 2014 16:02:57 -0300
Message-Id: <1404846184-20075-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

kvm stat support is currently conditional on i386/x86_64. Let's abstract
this into a HAVE_KVM_STAT_SUPPORT flag, so that other architectures can
support kvm stat as well.

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
Link: http://lkml.kernel.org/r/1404395992-17095-2-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/Makefile | 1 +
 tools/perf/builtin-kvm.c     | 6 +++---
 tools/perf/config/Makefile   | 4 ++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542e3636..d3939014a877 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -15,3 +15,4 @@ endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
+HAVE_KVM_STAT_SUPPORT := 1
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0f1e5a2f6ad7..214ec0e7492b 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -29,7 +29,7 @@
 #include <pthread.h>
 #include <math.h>
 
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef HAVE_KVM_STAT_SUPPORT
 #include <asm/svm.h>
 #include <asm/vmx.h>
 #include <asm/kvm.h>
@@ -1609,7 +1609,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
-#endif
+#endif /* HAVE_KVM_STAT_SUPPORT */
 
 static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
@@ -1726,7 +1726,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef HAVE_KVM_STAT_SUPPORT
 	else if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 346bdb617544..b7f42d577c4e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -594,6 +594,10 @@ ifndef NO_LIBNUMA
   endif
 endif
 
+ifdef HAVE_KVM_STAT_SUPPORT
+    CFLAGS += -DHAVE_KVM_STAT_SUPPORT
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
-- 
1.9.3

