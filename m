Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaDYJM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:12:27 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:47887 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaDYJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 05/11] perf kvm: Intoduce HAVE_KVM_STAT_SUPPORT flag
Date: Fri, 25 Apr 2014 11:12:27 +0200
Message-Id: <1398417153-57347-6-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-0542-0000-0000-000008C524A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

kvm stat support is currently conditional on i386/x86_64. Let's
abstract this into a HAVE_KVM_STAT_SUPPORT flag, so that other
architectures can support kvm stat as well.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/arch/x86/Makefile | 1 +
 tools/perf/builtin-kvm.c     | 6 +++---
 tools/perf/config/Makefile   | 4 ++++
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
index 21c164b..202b9b0 100644
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
@@ -1608,7 +1608,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
-#endif
+#endif /* HAVE_KVM_STAT_SUPPORT */
 
 static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
@@ -1725,7 +1725,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef HAVE_KVM_STAT_SUPPORT
 	else if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c234182..6251d6b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -562,6 +562,10 @@ ifndef NO_LIBNUMA
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
1.8.4.2

