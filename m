Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJPMsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:48:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:48:49 -0400
Date: Thu, 16 Oct 2014 14:47:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-api@vger.kernel.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141016124741.GA3832@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The Android binder code has been "stable" for many years now.  No matter
what comes in the future, we are going to have to support this API, so
might as well move it to the "real" part of the kernel as there's no
real work that needs to be done to the existing code.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

This was discussed in the Android miniconf at the Plumbers conference.
If anyone has any objections to this, please let me know, otherwise I'm
queueing this up for 3.19-rc1


 drivers/Kconfig                                    |  2 ++
 drivers/Makefile                                   |  1 +
 drivers/android/Kconfig                            | 37 ++++++++++++++++++++++
 drivers/android/Makefile                           |  3 ++
 drivers/{staging => }/android/binder.c             |  0
 drivers/{staging => }/android/binder.h             |  2 +-
 drivers/{staging => }/android/binder_trace.h       |  0
 drivers/staging/android/Kconfig                    | 30 ------------------
 drivers/staging/android/Makefile                   |  1 -
 include/uapi/linux/Kbuild                          |  1 +
 include/uapi/linux/android/Kbuild                  |  2 ++
 .../uapi => include/uapi/linux/android}/binder.h   |  0
 12 files changed, 47 insertions(+), 32 deletions(-)
 create mode 100644 drivers/android/Kconfig
 create mode 100644 drivers/android/Makefile
 rename drivers/{staging => }/android/binder.c (100%)
 rename drivers/{staging => }/android/binder.h (95%)
 rename drivers/{staging => }/android/binder_trace.h (100%)
 create mode 100644 include/uapi/linux/android/Kbuild
 rename {drivers/staging/android/uapi => include/uapi/linux/android}/binder.h (100%)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3f9d51..569ff7886dc3 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -182,4 +182,6 @@ source "drivers/ras/Kconfig"
 
 source "drivers/thunderbolt/Kconfig"
 
+source "drivers/android/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index ebee55537a05..60d19820a4d4 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -161,3 +161,4 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
+obj-$(CONFIG_ANDROID)		+= android/
diff --git a/drivers/android/Kconfig b/drivers/android/Kconfig
new file mode 100644
index 000000000000..bdfc6c6f4f5a
--- /dev/null
+++ b/drivers/android/Kconfig
@@ -0,0 +1,37 @@
+menu "Android"
+
+config ANDROID
+	bool "Android Drivers"
+	---help---
+	  Enable support for various drivers needed on the Android platform
+
+if ANDROID
+
+config ANDROID_BINDER_IPC
+	bool "Android Binder IPC Driver"
+	depends on MMU
+	default n
+	---help---
+	  Binder is used in Android for both communication between processes,
+	  and remote method invocation.
+
+	  This means one Android process can call a method/routine in another
+	  Android process, using Binder to identify, invoke and pass arguments
+	  between said processes.
+
+config ANDROID_BINDER_IPC_32BIT
+	bool
+	depends on !64BIT && ANDROID_BINDER_IPC
+	default y
+	---help---
+	  The Binder API has been changed to support both 32 and 64bit
+	  applications in a mixed environment.
+
+	  Enable this to support an old 32-bit Android user-space (v4.4 and
+	  earlier).
+
+	  Note that enabling this will break newer Android user-space.
+
+endif # if ANDROID
+
+endmenu
diff --git a/drivers/android/Makefile b/drivers/android/Makefile
new file mode 100644
index 000000000000..3b7e4b072c58
--- /dev/null
+++ b/drivers/android/Makefile
@@ -0,0 +1,3 @@
+ccflags-y += -I$(src)			# needed for trace events
+
+obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
diff --git a/drivers/staging/android/binder.c b/drivers/android/binder.c
similarity index 100%
rename from drivers/staging/android/binder.c
rename to drivers/android/binder.c
diff --git a/drivers/staging/android/binder.h b/drivers/android/binder.h
similarity index 95%
rename from drivers/staging/android/binder.h
rename to drivers/android/binder.h
index eb0834656dfe..5dc6a66b0665 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/android/binder.h
@@ -24,7 +24,7 @@
 #define BINDER_IPC_32BIT 1
 #endif
 
-#include "uapi/binder.h"
+#include <uapi/linux/android/binder.h>
 
 #endif /* _LINUX_BINDER_H */
 
diff --git a/drivers/staging/android/binder_trace.h b/drivers/android/binder_trace.h
similarity index 100%
rename from drivers/staging/android/binder_trace.h
rename to drivers/android/binder_trace.h
diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 7a0e28852965..7e012f37792b 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -1,37 +1,7 @@
 menu "Android"
 
-config ANDROID
-	bool "Android Drivers"
-	---help---
-	  Enable support for various drivers needed on the Android platform
-
 if ANDROID
 
-config ANDROID_BINDER_IPC
-	bool "Android Binder IPC Driver"
-	depends on MMU
-	default n
-	---help---
-	  Binder is used in Android for both communication between processes,
-	  and remote method invocation.
-
-	  This means one Android process can call a method/routine in another
-	  Android process, using Binder to identify, invoke and pass arguments
-	  between said processes.
-
-config ANDROID_BINDER_IPC_32BIT
-	bool
-	depends on !64BIT && ANDROID_BINDER_IPC
-	default y
-	---help---
-	  The Binder API has been changed to support both 32 and 64bit
-	  applications in a mixed environment.
-
-	  Enable this to support an old 32-bit Android user-space (v4.4 and
-	  earlier).
-
-	  Note that enabling this will break newer Android user-space.
-
 config ASHMEM
 	bool "Enable the Anonymous Shared Memory Subsystem"
 	default n
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 517ad5ffa429..479b2b86f8c8 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -2,7 +2,6 @@ ccflags-y += -I$(src)			# needed for trace events
 
 obj-y					+= ion/
 
-obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
 obj-$(CONFIG_ANDROID_LOGGER)		+= logger.o
 obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+= timed_output.o
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 70e150ebc6c9..1bbaf6457861 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -1,4 +1,5 @@
 # UAPI Header export list
+header-y += android/
 header-y += byteorder/
 header-y += can/
 header-y += caif/
diff --git a/include/uapi/linux/android/Kbuild b/include/uapi/linux/android/Kbuild
new file mode 100644
index 000000000000..ca011eec252a
--- /dev/null
+++ b/include/uapi/linux/android/Kbuild
@@ -0,0 +1,2 @@
+# UAPI Header export list
+header-y += binder.h
diff --git a/drivers/staging/android/uapi/binder.h b/include/uapi/linux/android/binder.h
similarity index 100%
rename from drivers/staging/android/uapi/binder.h
rename to include/uapi/linux/android/binder.h
-- 
2.1.2

