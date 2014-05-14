Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaENWb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:31:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56476 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaENWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:31:26 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH v2 2/2] tools: add script to test udelay
Date: Wed, 14 May 2014 15:30:17 -0700
Message-Id: <1400106617-17085-3-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400106617-17085-1-git-send-email-davidriley@chromium.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
 <1400106617-17085-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script makes use of the udelay_test module to exercise udelay()
and ensure that it is delaying long enough (as compared to ktime).

Signed-off-by: David Riley <davidriley@chromium.org>
---
 tools/time/udelay_test.sh |   66 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 tools/time/udelay_test.sh

diff --git a/tools/time/udelay_test.sh b/tools/time/udelay_test.sh
new file mode 100644
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
1.7.9.5

