Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbaGCOAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:00:34 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:49354 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbaGCOAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:00:32 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 1/4] perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
Date: Thu,  3 Jul 2014 17:59:49 +0400
Message-Id: <1404395992-17095-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404395992-17095-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404395992-17095-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070314-3548-0000-0000-00000062B78D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm stat support is currently conditional on i386/x86_64. Let's
abstract this into a HAVE_KVM_STAT_SUPPORT flag, so that other
architectures can support kvm stat as well.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/arch/x86/Makefile |    1 +
 tools/perf/builtin-kvm.c     |    6 +++---
 tools/perf/config/Makefile   |    4 ++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542..d393901 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -15,3 +15,4 @@ endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
+HAVE_KVM_STAT_SUPPORT := 1
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0f1e5a2..214ec0e 100644
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
index 4f100b5..82d7db5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -586,6 +586,10 @@ ifndef NO_LIBNUMA
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
1.7.9.5

