Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3I2Ud4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:33:56 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.94]:39413 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3I2Udy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:33:54 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2013 16:33:54 EDT
Message-ID: <52488D63.4060001@ladisch.de>
Date: Sun, 29 Sep 2013 22:28:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Prarit Bhargava <prarit@redhat.com>, Matt Wilson <msw@amazon.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hpet: allow user controlled mmap for user processes
References: <51487B59.6010607@ladisch.de> <1363959174-28999-1-git-send-email-prarit@redhat.com> <20130829060151.GA7439@u109add4315675089e695.ant.amazon.com> <523255BB.7050109@redhat.com>
In-Reply-To: <523255BB.7050109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

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
[v4]: After testing, found that I need to modify CONFIG_HPET_MMAP_DEFAULT usage
[v5]: Fixed up Documentation, Kconfig entry, and log message [CL]

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Matt Wilson <msw@amazon.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/char/Kconfig                |   10 ++++++++--
 drivers/char/hpet.c                 |   24 ++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 539a236..6a7b656 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1064,6 +1064,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				VIA, nVidia)
 			verbose: show contents of HPET registers during setup

+	hpet_mmap=	[X86, HPET_MMAP] Allow userspace to mmap HPET
+			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 1421997..fa3243d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -522,10 +522,16 @@ config HPET_MMAP
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
+	  exposed to the user.  This option selects the default (if
+	  kernel parameter hpet_mmap is not set) user access to the
+	  registers for applications that require it.

 config HANGCHECK_TIMER
 	tristate "Hangcheck timer"
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index d6568a6..964d002 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -367,12 +367,29 @@ static unsigned int hpet_poll(struct file *file, poll_table * wait)
 	return 0;
 }

+#ifdef CONFIG_HPET_MMAP
+#ifdef CONFIG_HPET_MMAP_DEFAULT
+static int hpet_mmap_enabled = 1;
+#else
+static int hpet_mmap_enabled = 0;
+#endif
+
+static __init int hpet_mmap_enable(char *str)
+{
+	get_option(&str, &hpet_mmap_enabled);
+	pr_info("HPET mmap %s\n", hpet_mmap_enabled ? "enabled" : "disabled");
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
 	devp = file->private_data;
 	addr = devp->hd_hpets->hp_hpet_phys;

@@ -381,10 +398,13 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)

 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return vm_iomap_memory(vma, addr, PAGE_SIZE);
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
