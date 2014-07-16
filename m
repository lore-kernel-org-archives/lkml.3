Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbaGPTQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:16:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760821AbaGPTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:16:19 -0400
Date: Wed, 16 Jul 2014 12:15:55 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-da50ad69723111e0292f1943dad77b41bb9a25b0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, jolsa@redhat.com, cornelia.huck@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404395992-17095-2-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1404395992-17095-2-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
Git-Commit-ID: da50ad69723111e0292f1943dad77b41bb9a25b0
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

Commit-ID:  da50ad69723111e0292f1943dad77b41bb9a25b0
Gitweb:     http://git.kernel.org/tip/da50ad69723111e0292f1943dad77b41bb9a25b0
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Thu, 3 Jul 2014 17:59:49 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 16:55:23 -0300

perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag

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
index 346bdb6..b7f42d5 100644
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
