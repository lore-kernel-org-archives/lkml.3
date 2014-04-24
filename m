Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbaDXQJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:09:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:34118 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758725AbaDXQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:54 -0400
Message-Id: <20140424160851.398098812@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 7/7] ktest: Update documentation on config_bisect
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-ktest-Update-documentation-on-config_bisect.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the more robust config_bisect, the documentation is out of
date and needs to be updated.

The new rewrite allows for finding missing configs and such, and
is much more robust to use.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/sample.conf | 65 +++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 172eec4..911e45a 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1098,49 +1098,35 @@
 #
 #  The way it works is this:
 #
-#   First it finds a config to work with. Since a different version, or
-#   MIN_CONFIG may cause different dependecies, it must run through this
-#   preparation.
+#   You can specify a good config with CONFIG_BISECT_GOOD, otherwise it
+#   will use the MIN_CONFIG, and if that's not specified, it will use
+#   the config that comes with "make defconfig".
 #
-#   Overwrites any config set in the bad config with a config set in
-#   either the MIN_CONFIG or ADD_CONFIG. Thus, make sure these configs
-#   are minimal and do not disable configs you want to test:
-#   (ie.  # CONFIG_FOO is not set).
+#   It runs both the good and bad configs through a make oldconfig to
+#   make sure that they are set up for the kernel that is checked out.
 #
-#   An oldconfig is run on the bad config and any new config that
-#   appears will be added to the configs to test.
+#   It then reads the configs that are set, as well as the ones that are
+#   not set for both the good and bad configs, and then compares them.
+#   It will set half of the good configs within the bad config (note,
+#   "set" means to make the bad config match the good config, a config
+#   in the good config that is off, will be turned off in the bad
+#   config. That is considered a "set").
 #
-#   Finally, it generates a config with the above result and runs it
-#   again through make oldconfig to produce a config that should be
-#   satisfied by kconfig.
+#   It tests this new config and if it works, it becomes the new good
+#   config, otherwise it becomes the new bad config. It continues this
+#   process until there's only one config left and it will report that
+#   config.
 #
-#   Then it starts the bisect.
+#   The "bad config" can also be a config that is needed to boot but was
+#   disabled because it depended on something that wasn't set.
 #
-#   The configs to test are cut in half. If all the configs in this
-#   half depend on a config in the other half, then the other half
-#   is tested instead. If no configs are enabled by either half, then
-#   this means a circular dependency exists and the test fails.
+#   During this process, it saves the current good and bad configs in
+#   ${TMP_DIR}/good_config and ${TMP_DIR}/bad_config respectively.
+#   If you stop the test, you can copy them to a new location to
+#   reuse them again.
 #
-#   A config is created with the test half, and the bisect test is run.
-#
-#   If the bisect succeeds, then all configs in the generated config
-#   are removed from the configs to test and added to the configs that
-#   will be enabled for all builds (they will be enabled, but not be part
-#   of the configs to examine).
-#
-#   If the bisect fails, then all test configs that were not enabled by
-#   the config file are removed from the test. These configs will not
-#   be enabled in future tests. Since current config failed, we consider
-#   this to be a subset of the config that we started with.
-#
-#   When we are down to one config, it is considered the bad config.
-#
-#   Note, the config chosen may not be the true bad config. Due to
-#   dependencies and selections of the kbuild system, mulitple
-#   configs may be needed to cause a failure. If you disable the
-#   config that was found and restart the test, if the test fails
-#   again, it is recommended to rerun the config_bisect with a new
-#   bad config without the found config enabled.
+#   Although the MIN_CONFIG may be the config it starts with, the
+#   MIN_CONFIG is ignored.
 #
 #  The option BUILD_TYPE will be ignored.
 #
@@ -1160,13 +1146,16 @@
 # CONFIG_BISECT_GOOD (optional)
 #  If you have a good config to start with, then you
 #  can specify it with CONFIG_BISECT_GOOD. Otherwise
-#  the MIN_CONFIG is the base.
+#  the MIN_CONFIG is the base, if MIN_CONFIG is not set
+#  It will build a config with "make defconfig"
 #
 # CONFIG_BISECT_CHECK (optional)
 #  Set this to 1 if you want to confirm that the config ktest
 #  generates (the bad config with the min config) is still bad.
 #  It may be that the min config fixes what broke the bad config
 #  and the test will not return a result.
+#  Set it to "good" to test only the good config and set it
+#  to "bad" to only test the bad config.
 #
 # Example:
 #   TEST_START
-- 
1.8.5.3


