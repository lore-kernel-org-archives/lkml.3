Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaAUNuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:50:21 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47796 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaAUNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:50:14 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3/3] scripts/dtc: Add a script to update to mainline dtc source
Date: Tue, 21 Jan 2014 13:50:01 +0000
Message-Id: <1390312201-22754-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
References: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very simple script that automates pulling in a newer version of DTC.
Not particularly robust, but a whole lot better than doing it by hand
every time.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 scripts/dtc/update-dtc-source.sh | 54 ++++++++++++++++++++++++++++++++++++++++
 scripts/dtc/version_gen.h        |  2 +-
 2 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100755 scripts/dtc/update-dtc-source.sh

diff --git a/scripts/dtc/update-dtc-source.sh b/scripts/dtc/update-dtc-source.sh
new file mode 100755
index 000000000000..feb01ef26be4
--- /dev/null
+++ b/scripts/dtc/update-dtc-source.sh
@@ -0,0 +1,54 @@
+#!/bin/sh
+# Simple script to update the version of DTC carried by the Linux kernel
+#
+# This script assumes that the dtc and the linux git trees are in the
+# same directory. After building dtc in the dtc directory, it copies the
+# source files and generated source files into the scripts/dtc directory
+# in the kernel and creates a git commit updating them to the new
+# version.
+#
+# Usage: from the top level Linux source tree, run:
+# $ ./scripts/dtc/update-dtc-source.sh
+#
+# The script will change into the dtc tree, build and test dtc, copy the
+# relevant files into the kernel tree and create a git commit. The commit
+# message will need to be modified to reflect the version of DTC being
+# imported
+#
+# TODO:
+# This script is pretty basic, but it is seldom used so a few manual tasks
+# aren't a big deal. If anyone is interested in making it more robust, the
+# the following would be nice:
+# * Actually fail to complete if any testcase fails.
+#   - The dtc "make check" target needs to return a failure
+# * Extract the version number from the dtc repo for the commit message
+# * Build dtc in the kernel tree
+# * run 'make check" on dtc built from the kernel tree
+
+set -ev
+
+DTC_UPSTREAM_PATH=`pwd`/../dtc
+DTC_LINUX_PATH=`pwd`/scripts/dtc
+
+DTC_SOURCE="checks.c data.c dtc.c dtc.h flattree.c fstree.c livetree.c srcpos.c \
+		srcpos.h treesource.c util.c util.h version_gen.h Makefile.dtc \
+		dtc-lexer.l dtc-parser.y"
+DTC_GENERATED="dtc-lexer.lex.c dtc-parser.tab.c dtc-parser.tab.h"
+
+# Build DTC
+cd $DTC_UPSTREAM_PATH
+make clean
+make check
+
+# Copy the files into the Linux tree
+cd $DTC_LINUX_PATH
+for f in $DTC_SOURCE; do
+	cp ${DTC_UPSTREAM_PATH}/${f} ${f}
+	git add ${f}
+done
+for f in $DTC_GENERATED; do
+	cp ${DTC_UPSTREAM_PATH}/$f ${f}_shipped
+	git add ${f}_shipped
+done
+
+git commit -e -v -m "scripts/dtc: Update to upstream version [CHANGEME]"
diff --git a/scripts/dtc/version_gen.h b/scripts/dtc/version_gen.h
index e0b82fe8e7de..54d4e904433a 100644
--- a/scripts/dtc/version_gen.h
+++ b/scripts/dtc/version_gen.h
@@ -1 +1 @@
-#define DTC_VERSION "DTC 1.4.0"
+#define DTC_VERSION "DTC 1.4.0-dirty"
-- 
1.8.3.2

