Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaDQOMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:12:21 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48025 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaDQOMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:12:16 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH 2/4] Documentation: add makefiles for more targets
Date: Thu, 17 Apr 2014 10:11:48 -0400
Message-Id: <1397743910-18391-2-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bunch of previously unbuilt source files to the Documentation build
machinery.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/Makefile                         |  7 +++---
 Documentation/arm/Makefile                     |  1 +
 Documentation/arm/SH-Mobile/Makefile           | 11 ++++-----
 Documentation/blackfin/Makefile                |  7 ++----
 Documentation/filesystems/Makefile             |  2 ++
 Documentation/laptops/Makefile                 |  2 +-
 Documentation/mic/Makefile                     |  1 +
 Documentation/mic/mpssd/Makefile               | 22 ++++++++---------
 Documentation/networking/timestamping/Makefile |  5 +---
 Documentation/prctl/Makefile                   |  8 +++++++
 Documentation/ptp/Makefile                     |  8 +++++++
 Documentation/ptp/testptp.mk                   | 33 --------------------------
 Documentation/vDSO/Makefile                    |  9 +++++++
 Documentation/video4linux/Makefile             |  1 +
 14 files changed, 53 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/arm/Makefile
 create mode 100644 Documentation/mic/Makefile
 create mode 100644 Documentation/prctl/Makefile
 create mode 100644 Documentation/ptp/Makefile
 delete mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 Documentation/vDSO/Makefile
 create mode 100644 Documentation/video4linux/Makefile

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 605f84f..6883a1b 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,3 +1,4 @@
-subdir-y := DocBook accounting auxdisplay connector \
-	filesystems filesystems ia64 laptops networking \
-	pcmcia spi timers watchdog misc-devices
+subdir-y := accounting arm auxdisplay blackfin connector \
+	filesystems filesystems ia64 laptops mic misc-devices \
+	networking pcmcia prctl ptp spi timers vDSO video4linux \
+	watchdog
diff --git a/Documentation/arm/Makefile b/Documentation/arm/Makefile
new file mode 100644
index 0000000..732c770
--- /dev/null
+++ b/Documentation/arm/Makefile
@@ -0,0 +1 @@
+subdir-y := SH-Mobile
diff --git a/Documentation/arm/SH-Mobile/Makefile b/Documentation/arm/SH-Mobile/Makefile
index 8771d83..ac8075d 100644
--- a/Documentation/arm/SH-Mobile/Makefile
+++ b/Documentation/arm/SH-Mobile/Makefile
@@ -1,8 +1,7 @@
-BIN := vrl4
+# List of programs to build
+hostprogs-y := vrl4
 
-.PHONY: all
-all: $(BIN)
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
 
-.PHONY: clean
-clean:
-	rm -f *.o $(BIN)
+HOSTCFLAGS_vrl4.o += -I$(objtree)/usr/include
diff --git a/Documentation/blackfin/Makefile b/Documentation/blackfin/Makefile
index 773dbb1..c7e6c99 100644
--- a/Documentation/blackfin/Makefile
+++ b/Documentation/blackfin/Makefile
@@ -1,6 +1,3 @@
+ifneq ($(CONFIG_BLACKFIN),)
 obj-m := gptimers-example.o
-
-all: modules
-
-modules clean:
-	$(MAKE) -C ../.. SUBDIRS=$(PWD) $@
+endif
diff --git a/Documentation/filesystems/Makefile b/Documentation/filesystems/Makefile
index 883010c..13483d1 100644
--- a/Documentation/filesystems/Makefile
+++ b/Documentation/filesystems/Makefile
@@ -1,3 +1,5 @@
+subdir-y := configfs
+
 # List of programs to build
 hostprogs-y := dnotify_test
 
diff --git a/Documentation/laptops/Makefile b/Documentation/laptops/Makefile
index 0abe44f..9dcbc3f 100644
--- a/Documentation/laptops/Makefile
+++ b/Documentation/laptops/Makefile
@@ -1,5 +1,5 @@
 # List of programs to build
-hostprogs-y := dslm
+hostprogs-y := dslm hpfall
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
diff --git a/Documentation/mic/Makefile b/Documentation/mic/Makefile
new file mode 100644
index 0000000..a191d45
--- /dev/null
+++ b/Documentation/mic/Makefile
@@ -0,0 +1 @@
+subdir-y := mpssd
diff --git a/Documentation/mic/mpssd/Makefile b/Documentation/mic/mpssd/Makefile
index eb860a7..44ec68b 100644
--- a/Documentation/mic/mpssd/Makefile
+++ b/Documentation/mic/mpssd/Makefile
@@ -1,19 +1,17 @@
-#
-# Makefile - Intel MIC User Space Tools.
-# Copyright(c) 2013, Intel Corporation.
-#
+# List of programs to build
+hostprogs-y := mpssd
+
+mpssd-objs := mpssd.o sysfs.o
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
 ifdef DEBUG
-CFLAGS += $(USERWARNFLAGS) -I. -g -Wall -DDEBUG=$(DEBUG)
-else
-CFLAGS += $(USERWARNFLAGS) -I. -g -Wall
+HOSTCFLAGS += -DDEBUG=$(DEBUG)
 endif
 
-mpssd: mpssd.o sysfs.o
-	$(CC) $(CFLAGS) -o $@ $^ -lpthread
+HOSTLOADLIBES_mpssd := -lpthread
 
 install:
 	install mpssd /usr/sbin/mpssd
 	install micctrl /usr/sbin/micctrl
-
-clean:
-	rm -f mpssd *.o
diff --git a/Documentation/networking/timestamping/Makefile b/Documentation/networking/timestamping/Makefile
index bbe6f81..52ac67d 100644
--- a/Documentation/networking/timestamping/Makefile
+++ b/Documentation/networking/timestamping/Makefile
@@ -1,11 +1,8 @@
 # List of programs to build
-hostprogs-y := timestamping hwtstamp_config
+hostprogs-y := hwtstamp_config timestamping
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
 HOSTCFLAGS_timestamping.o += -I$(objtree)/usr/include
 HOSTCFLAGS_hwtstamp_config.o += -I$(objtree)/usr/include
-
-clean:
-	rm -f timestamping hwtstamp_config
diff --git a/Documentation/prctl/Makefile b/Documentation/prctl/Makefile
new file mode 100644
index 0000000..3e3232d
--- /dev/null
+++ b/Documentation/prctl/Makefile
@@ -0,0 +1,8 @@
+# List of programs to build
+hostprogs-y := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test disable-tsc-test
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_disable-tsc-ctxt-sw-stress-test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_disable-tsc-on-off-stress-test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_disable-tsc-test.o += -I$(objtree)/usr/include
diff --git a/Documentation/ptp/Makefile b/Documentation/ptp/Makefile
new file mode 100644
index 0000000..293d6c0
--- /dev/null
+++ b/Documentation/ptp/Makefile
@@ -0,0 +1,8 @@
+# List of programs to build
+hostprogs-y := testptp
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_testptp.o += -I$(objtree)/usr/include
+HOSTLOADLIBES_testptp := -lrt
diff --git a/Documentation/ptp/testptp.mk b/Documentation/ptp/testptp.mk
deleted file mode 100644
index 4ef2d97..0000000
--- a/Documentation/ptp/testptp.mk
+++ /dev/null
@@ -1,33 +0,0 @@
-# PTP 1588 clock support - User space test program
-#
-# Copyright (C) 2010 OMICRON electronics GmbH
-#
-#  This program is free software; you can redistribute it and/or modify
-#  it under the terms of the GNU General Public License as published by
-#  the Free Software Foundation; either version 2 of the License, or
-#  (at your option) any later version.
-#
-#  This program is distributed in the hope that it will be useful,
-#  but WITHOUT ANY WARRANTY; without even the implied warranty of
-#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-#  GNU General Public License for more details.
-#
-#  You should have received a copy of the GNU General Public License
-#  along with this program; if not, write to the Free Software
-#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-CC        = $(CROSS_COMPILE)gcc
-INC       = -I$(KBUILD_OUTPUT)/usr/include
-CFLAGS    = -Wall $(INC)
-LDLIBS    = -lrt
-PROGS     = testptp
-
-all: $(PROGS)
-
-testptp: testptp.o
-
-clean:
-	rm -f testptp.o
-
-distclean: clean
-	rm -f $(PROGS)
diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
new file mode 100644
index 0000000..2f22772
--- /dev/null
+++ b/Documentation/vDSO/Makefile
@@ -0,0 +1,9 @@
+# List of programs to build
+hostprogs-$(CONFIG_X86) := vdso_test
+vdso_test-objs := parse_vdso.o vdso_test.o
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
+HOSTLDFLAGS = -nostdlib -fno-asynchronous-unwind-tables
diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
new file mode 100644
index 0000000..d58101e
--- /dev/null
+++ b/Documentation/video4linux/Makefile
@@ -0,0 +1 @@
+obj-m := v4l2-pci-skeleton.o
-- 
1.9.2

