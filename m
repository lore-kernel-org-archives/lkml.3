Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120Ab3DDTDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:03:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54488 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763581Ab3DDTDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:03:16 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Michal Marek <mmarek@suse.cz>,
        Bruce Ashfield <bruce.ashfield@windriver.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH] merge_config.sh: Avoid creating unnessary source softlinks
Date: Thu,  4 Apr 2013 12:02:59 -0700
Message-Id: <1365102179-19176-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh noticed when using merge_config.sh that a source softlink
was being created even when he didn't specify the -O option.

The problem arises due to the previous commit 409f117e2d6b
which added the -O option. Basically if -O is not specified,
we still pass '-O=.' to the make command, which then generates
a source softlink to ./

This patch adds an extra check so if there is no -O specified
to merge_config.sh, we don't pass one on to make.

Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Bruce Ashfield <bruce.ashfield@windriver.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/kconfig/merge_config.sh |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 05274fc..81b0c61 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -120,10 +120,18 @@ if [ "$MAKE" = "false" ]; then
 	exit
 fi
 
+# If we have an output dir, setup the O= argument, otherwise leave
+# it blank, since O=. will create an unnecessary ./source softlink
+OUTPUT_ARG=""
+if [ "$OUTPUT" != "." ] ; then
+	OUTPUT_ARG="O=$OUTPUT"
+fi
+
+
 # Use the merged file as the starting point for:
 # alldefconfig: Fills in any missing symbols with Kconfig default
 # allnoconfig: Fills in any missing symbols with # CONFIG_* is not set
-make KCONFIG_ALLCONFIG=$TMP_FILE O=$OUTPUT $ALLTARGET
+make KCONFIG_ALLCONFIG=$TMP_FILE $OUTPUT_ARG $ALLTARGET
 
 
 # Check all specified config values took (might have missed-dependency issues)
-- 
1.7.10.4

