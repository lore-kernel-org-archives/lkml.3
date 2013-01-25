Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3AYOMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:12:32 -0500
Received: from forward17.mail.yandex.net ([95.108.253.142]:47076 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3AYOMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:12:30 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 09:12:30 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Tkhai Kirill <tkhai@yandex.ru>
Subject: [PATCH v3]scripts/tags.sh: Add ctags magic for declarations of popular kernel type
MIME-Version: 1.0
Message-Id: <948891359122793@web28g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Jan 2013 18:06:33 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)Add magic for declarations of variables of popular kernel type
like spinlock_t, list_head, wait_queue_head_t and other.

2)Add a set of specially handled declaration extentions
like __attribute, __aligned and other.

3)Simplify pci_bus_* magic

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Cc: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/tags.sh |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 4c53b7d..26a87e6 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -149,12 +149,17 @@ dogtags()
 exuberant()
 {
 	all_target_sources | xargs $1 -a                        \
-	-I __initdata,__exitdata,__acquires,__releases          \
-	-I __read_mostly,____cacheline_aligned                  \
+	-I __initdata,__exitdata,__initconst,__devinitdata	\
+	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
+	-I __refdata,__attribute				\
+	-I __acquires,__releases,__deprecated			\
+	-I __read_mostly,__aligned,____cacheline_aligned        \
 	-I ____cacheline_aligned_in_smp                         \
 	-I ____cacheline_internodealigned_in_smp                \
+	-I __used,__packed,__packed2__,__must_check,__must_hold	\
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
+	-I static,const						\
 	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
@@ -182,8 +187,19 @@ exuberant()
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
-	--regex-c='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
-	--regex-c='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
+	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
+	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
+	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_(RAW_SPINLOCK|RWLOCK|SEQLOCK)\((\w*)/\2/v/'	\
+	--regex-c='/DECLARE_(RWSEM|COMPLETION)\((\w*)/\2/v/'		\
+	--regex-c='/DECLARE_BITMAP\((\w*)/\1/v/'			\
+	--regex-c='/(^|\s)(|L|H)LIST_HEAD\((\w*)/\3/v/'			\
+	--regex-c='/(^|\s)RADIX_TREE\((\w*)/\2/v/'			\
+	--regex-c='/DEFINE_PER_CPU\(([^,]*,\s*)(\w*).*\)/\2/v/'		\
+	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
+	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
+	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
+	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
