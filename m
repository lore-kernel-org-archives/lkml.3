Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3CSOu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab3CSOuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:50:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
Date: Tue, 19 Mar 2013 10:49:56 -0400
Message-Id: <1363704596-12276-1-git-send-email-prarit@redhat.com>
In-Reply-To: <5148171D.10807@ladisch.de>
References: <5148171D.10807@ladisch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
registers to userspace.  The Kconfig help points out that in some cases this
can be a security risk as some systems may erroneously configure the map such
that additional data is exposed to userspace.

This is a problem for distributions -- some users want the MMAP functionality
but it comes with a significant security risk.  In an effort to mitigate this
risk, and due to the low number of users of the MMAP functionality, I've
introduced a kernel parameter, hpet_mmap_enable, that is required in order
to actually have the HPET MMAP exposed.

[v2]: Clemens suggested modifying the Kconfig help text and making the
default setting configurable.
[v3]: Fixed up Documentation and Kconfig entries, default now "Y"

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/kernel-parameters.txt |  4 ++++
 drivers/char/Kconfig                |  9 +++++++--
 drivers/char/hpet.c                 | 21 +++++++++++++++++++--
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e567af3..1444491 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -962,6 +962,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				VIA, nVidia)
 			verbose: show contents of HPET registers during setup
 
+	hpet_mmap=	[X86, HPET_MMAP] option to expose HPET MMAP to
+			userspace.  By default this is disabled. Values are
+			0(disabled) or 1(enabled).
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3bb6fa3..51b62a1 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -534,10 +534,15 @@ config HPET_MMAP
 	  If you say Y here, user applications will be able to mmap
 	  the HPET registers.
 
+config HPET_MMAP_DEFAULT
+	bool "Enable HPET MMAP access by default"
+	default y
+	depends on HPET_MMAP
+	help
 	  In some hardware implementations, the page containing HPET
 	  registers may also contain other things that shouldn't be
-	  exposed to the user.  If this applies to your hardware,
-	  say N here.
+	  exposed to the user. This option selects the default user access
+	  to the HPET registers for applications that require it.
 
 config HANGCHECK_TIMER
 	tristate "Hangcheck timer"
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e3f9a99..0f32e30 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -367,12 +367,26 @@ static unsigned int hpet_poll(struct file *file, poll_table * wait)
 	return 0;
 }
 
+#ifdef CONFIG_HPET_MMAP
+static int hpet_mmap_enabled = CONFIG_HPET_MMAP_DEFAULT;
+
+static __init int hpet_mmap_enable(char *str)
+{
+	get_option(&str, &hpet_mmap_enabled);
+	pr_info(KERN_INFO "HPET MMAP %s\n",
+		hpet_mmap_enabled ? "disabled" : "enabled");
+	return 1;
+}
+__setup("hpet_mmap", hpet_mmap_enable);
+
 static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 {
-#ifdef	CONFIG_HPET_MMAP
 	struct hpet_dev *devp;
 	unsigned long addr;
 
+	if (!hpet_mmap_enabled)
+		return -EACCES;
+
 	if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
 		return -EINVAL;
 
@@ -393,10 +407,13 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	}
 
 	return 0;
+}
 #else
+static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+{
 	return -ENOSYS;
-#endif
 }
+#endif
 
 static int hpet_fasync(int fd, struct file *file, int on)
 {
-- 
1.8.1

