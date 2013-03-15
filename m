Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3COUAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab3COUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:00:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] hpet, allow user controlled mmap for user processes
Date: Fri, 15 Mar 2013 16:00:10 -0400
Message-Id: <1363377610-19196-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
registers to userspace.  The Kconfig help points out that in some cases this
can be a security risk as some systems may erroneously configure the map such
that additional data is exposed to userspace.

This is a problem for distributions -- some users want the MMAP functionality
can verify that their systems are secure, but it comes with a significant
security risk for those who do not want the functionality.  In an effort
to mitigate this risk, and due to the low number of users of the MMAP
functionality I've introduced a kernel parameter, hpet_mmap_enable, that
is required in order to actually have the HPET MMAP exposed.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/char/hpet.c                 |   20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e567af3..dbf0d81 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -962,6 +962,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				VIA, nVidia)
 			verbose: show contents of HPET registers during setup
 
+	hpet_mmap_enable [X86, HPET_MMAP] option to expose HPET MMAP to
+			 userspace.  By default this is disabled.
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e3f9a99..de770ab 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -367,12 +367,25 @@ static unsigned int hpet_poll(struct file *file, poll_table * wait)
 	return 0;
 }
 
+#ifdef	CONFIG_HPET_MMAP
+static int hpet_mmap_enabled;
+
+static __init int hpet_mmap_enable(char *str)
+{
+	pr_info(KERN_INFO "HPET MMAP enabled\n");
+	hpet_mmap_enabled = 1;
+	return 1;
+}
+__setup("hpet_mmap_enable", hpet_mmap_enable);
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
 
@@ -393,10 +406,13 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
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
1.7.9.3

