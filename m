Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaFPV7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:59:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55697 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbaFPV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:58:54 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH v4 2/2] tools: add script to test udelay
Date: Mon, 16 Jun 2014 14:58:33 -0700
Message-Id: <1402955913-25036-3-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
References: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script makes use of the udelay_test module to exercise udelay()
and ensure that it is delaying long enough (as compared to ktime).

Signed-off-by: David Riley <davidriley@chromium.org>
---
 tools/time/udelay_test.sh | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 tools/time/udelay_test.sh

diff --git a/tools/time/udelay_test.sh b/tools/time/udelay_test.sh
new file mode 100755
index 0000000..12d46b9
--- /dev/null
+++ b/tools/time/udelay_test.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+
+# udelay() test script
+#
+# Test is executed by writing and reading to /sys/kernel/debug/udelay_test
+# and exercises a variety of delays to ensure that udelay() is delaying
+# at least as long as requested (as compared to ktime).
+#
+# Copyright (C) 2014 Google, Inc.
+#
+# This software is licensed under the terms of the GNU General Public
+# License version 2, as published by the Free Software Foundation, and
+# may be copied, distributed, and modified under those terms.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+MODULE_NAME=udelay_test
+UDELAY_PATH=/sys/kernel/debug/udelay_test
+
+setup()
+{
+	/sbin/modprobe -q $MODULE_NAME
+	tmp_file=`mktemp`
+}
+
+test_one()
+{
+	delay=$1
+	echo $delay > $UDELAY_PATH
+	tee -a $tmp_file < $UDELAY_PATH
+}
+
+cleanup()
+{
+	if [ -f $tmp_file ]; then
+		rm $tmp_file
+	fi
+	/sbin/modprobe -q -r $MODULE_NAME
+}
+
+trap cleanup EXIT
+setup
+
+# Delay for a variety of times.
+# 1..200, 200..500 (by 10), 500..2000 (by 100)
+for (( delay = 1; delay < 200; delay += 1 )); do
+	test_one $delay
+done
+for (( delay = 200; delay < 500; delay += 10 )); do
+	test_one $delay
+done
+for (( delay = 500; delay <= 2000; delay += 100 )); do
+	test_one $delay
+done
+
+# Search for failures
+count=`grep -c FAIL $tmp_file`
+if [ $? -eq "0" ]; then
+	echo "ERROR: $count delays failed to delay long enough"
+	retcode=1
+fi
+
+exit $retcode
-- 
2.0.0

