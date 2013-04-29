Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab3D2WA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:00:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055Ab3D2WA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:00:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: MFD: move ssbi driver into drivers/mfd
Date: Tue, 30 Apr 2013 00:00:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
References: <20130429162115.GA6893@kroah.com> <8yafvy92gfs.fsf@huya.qualcomm.com> <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
In-Reply-To: <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304300000.19488.arnd@arndb.de>
X-Provags-ID: V02:K0:znW9aj0gkxJV8HgnBc7e2TUFxlcgZrpIKHZ/UaVpFBS
 x+A1U2V2WPGsC2bre3bMRxAclc6gt+ckQiNxATYwFBD/qjmCPK
 ocUgSdO6M+OOKdtUehxrfm5aRYgQBH2t+/y7A+7f1nEVggXKKn
 W2WEAy5X9wsWKWnxl2Tt5UgAQEf8MhUDESzn68RZr22kL4LXE6
 lynm+eMnzKwdAQx80u8qnrNFG5qu9eyIQnrTvPDp3qk2SCM+T1
 Sxlc7PedIP2j7KN0d/lwMo+lPD8QyRS/e+zKv+T7cStBuG/JCm
 FRT31PxmG1tHHyiwPF4Pc/8JcHEblT2FC0XZtAOyr4GnlDGFIW
 mVu5rzIuzfRMuESmJrWk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for ssbi to have its own top-level driver directory
when the only users of this interface are all MFD drivers. The only
mainline driver using it at the moment (PM8921) is marked broken and in
fact does not compile. I have verified that fixing the trivial build
breakage in pm8921 links in the new ssbi code just fine, but that
can be a separate patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/Kconfig              |  2 --
 drivers/Makefile             |  1 -
 drivers/mfd/Kconfig          |  3 ++-
 drivers/mfd/Makefile         |  2 +-
 drivers/{ssbi => mfd}/ssbi.c |  0
 drivers/ssbi/Kconfig         | 16 ----------------
 drivers/ssbi/Makefile        |  1 -
 7 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 78a956e..202fa6d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,8 +52,6 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
-source "drivers/ssbi/Kconfig"
-
 source "drivers/hsi/Kconfig"
 
 source "drivers/pps/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 33360de..3c200a2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -114,7 +114,6 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-obj-$(CONFIG_SSBI)		+= ssbi/
 ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 obj-y				+= clocksource/
 endif
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ca86581..5150833 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -991,7 +991,8 @@ config MFD_PM8XXX
 
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
-	depends on SSBI && BROKEN
+	depends on (ARCH_MSM || HEXAGON)
+	depends on BROKEN
 	select MFD_CORE
 	select MFD_PM8XXX
 	help
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b90409c..3b95b47 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -133,7 +133,7 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
-obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
+obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
diff --git a/drivers/ssbi/ssbi.c b/drivers/mfd/ssbi.c
similarity index 100%
rename from drivers/ssbi/ssbi.c
rename to drivers/mfd/ssbi.c
diff --git a/drivers/ssbi/Kconfig b/drivers/ssbi/Kconfig
deleted file mode 100644
index 1ae4040a..0000000
--- a/drivers/ssbi/Kconfig
+++ /dev/null
@@ -1,16 +0,0 @@
-#
-# SSBI bus support
-#
-
-menu "Qualcomm MSM SSBI bus support"
-
-config SSBI
-	tristate "Qualcomm Single-wire Serial Bus Interface (SSBI)"
-	help
-	  If you say yes to this option, support will be included for the
-	  built-in SSBI interface on Qualcomm MSM family processors.
-
-	  This is required for communicating with Qualcomm PMICs and
-	  other devices that have the SSBI interface.
-
-endmenu
diff --git a/drivers/ssbi/Makefile b/drivers/ssbi/Makefile
deleted file mode 100644
index 38fb70c..0000000
--- a/drivers/ssbi/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_SSBI) += ssbi.o
