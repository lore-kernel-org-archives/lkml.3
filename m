Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3D0VKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 17:10:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52364 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3D0VKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 17:10:23 -0400
Date: Sat, 27 Apr 2013 14:10:18 -0700
From: Olof Johansson <olof@lixom.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] clk: add clk_ignore_unused option to keep boot clocks on
Message-ID: <20130427211018.GA9376@quad.lixom.net>
References: <1367019591-31685-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367019591-31685-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is primarily useful when there's a driver that doesn't claim clocks
properly, but the bootloader leaves them on. It's not expected to be used
in normal cases, but for bringup and debug it's very useful to have the
option to not gate unclaimed clocks that are still on.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 Documentation/clk.txt               | 11 +++++++++++
 Documentation/kernel-parameters.txt |  8 ++++++++
 drivers/clk/clk.c                   | 13 +++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 4274a54..b9911c2 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -231,3 +231,14 @@ To better enforce this policy, always follow this simple rule: any
 statically initialized clock data MUST be defined in a separate file
 from the logic that implements its ops.  Basically separate the logic
 from the data and all is well.
+
+	Part 6 - Disabling clock gating of unused clocks
+
+Sometimes during development it can be useful to be able to bypass the
+default disabling of unused clocks. For example, if drivers aren't enabling
+clocks properly but rely on them being on from the bootloader, bypassing
+the disabling means that the driver will remain functional while the issues
+are sorted out.
+
+To bypass this disabling, include "clk_ignore_unused" in the bootargs to the
+kernel.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c4fa000..c3bfacb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -44,6 +44,7 @@ parameter is applicable:
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
+	CLK	Common clock infrastructure is enabled.
 	CMA	Contiguous Memory Area support is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
@@ -473,6 +474,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	cio_ignore=	[S390]
 			See Documentation/s390/CommonIO for details.
+	clk_ignore_unused
+			[CLK]
+			Keep all clocks already enabled by bootloader on,
+			even if no driver has claimed them. This is useful
+			for debug and development, but should not be
+			needed on a platform with proper driver support.
+			For more information, see Documentation/clk.txt.
 
 	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 20ce67f..934cfd1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -499,10 +499,23 @@ out:
 	return;
 }
 
+static bool clk_ignore_unused;
+static int __init clk_ignore_unused_setup(char *__unused)
+{
+	clk_ignore_unused = true;
+	return 1;
+}
+__setup("clk_ignore_unused", clk_ignore_unused_setup);
+
 static int clk_disable_unused(void)
 {
 	struct clk *clk;
 
+	if (clk_ignore_unused) {
+		pr_warn("clk: Not disabling unused clocks\n");
+		return 0;
+	}
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
-- 
1.8.1.192.gc4361b8

