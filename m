Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbbA2KQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:16:14 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44000 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbA2KQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:16:11 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: [PATCH] builddeb: fix missing modules signatures if debug info is enabled
Date: Thu, 29 Jan 2015 13:15:51 +0300
Message-Id: <1422526551-18483-1-git-send-email-andrej.skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_DEBUG_INFO is set, builddeb creates separate package with
debug information. To do that, debug information from all of the modules
is placed into separate file and is stripped from loadable modules by objcopy.
If CONFIG_MODULE_SIG_ALL was set, then after stripping  all modules'
signatures are gone. If at the same time CONFIG_MODULE_SIG_FORCE is set,
then result package with contains non-loadable modules.

This patch resign all stripped modules again to avoid any such problems.

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
---
 scripts/package/builddeb |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 88dbf23..977c4d7 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -162,6 +162,12 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
 			# then add a link to those
 			$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $tmpdir/$module
 		done
+
+                # resign stripped modules
+                MODULE_SIG_ALL="$(grep -s '^CONFIG_MODULE_SIG_ALL=y' $KCONFIG_CONFIG || true)"
+                if [ -n "$MODULE_SIG_ALL" ]; then
+	            	INSTALL_MOD_PATH="$tmpdir" $MAKE KBUILD_SRC= modules_sign
+                fi
 	fi
 fi
 
-- 
1.7.10.4

