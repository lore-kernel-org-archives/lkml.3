Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFFMpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:45:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56434 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaFFMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:45:14 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3/4] drivers: sh: pm_runtime implementation needs to suspend and resume devices
Date: Fri,  6 Jun 2014 21:44:34 +0900
Message-Id: <8255fe169232364e5a01bd062e8037b8c1a9adec.1402058435.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

If we override the platform bus calls for pm_runtime then we end up
with the calls to the devices' suspend and resume methods ignored
in favour of the bus ones.

Change to calling the pm_runtime calls to suspend and resume the
devices specifically in the drivers/sh/pm_runtime.c implementation
to allow any device that may want to run power management to do so.

Note, all the current sh driver implementations do not use their
own power management code so this is not a major implementation
issues.

This also brings the implementation into line with the versions
used by the Davinci and Keystone PM domain code, so once fully
tested these implementations could be merged together.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/sh/pm_runtime.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/pm_runtime.c b/drivers/sh/pm_runtime.c
index 00b82ec..25eafbe 100644
--- a/drivers/sh/pm_runtime.c
+++ b/drivers/sh/pm_runtime.c
@@ -21,10 +21,43 @@
 #include <linux/slab.h>
 
 #ifdef CONFIG_PM_RUNTIME
+static int sh_pm_runtime_suspend(struct device *dev)
+{
+	int ret;
+
+	ret = pm_generic_runtime_suspend(dev);
+	if (ret) {
+		dev_err(dev, "failed to suspend device\n");
+		return ret;
+	}
+
+	ret = pm_clk_suspend(dev);
+	if (ret) {
+		dev_err(dev, "failed to suspend clock\n");
+		pm_generic_runtime_resume(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int sh_pm_runtime_resume(struct device *dev)
+{
+	int ret;
+
+	ret = pm_clk_resume(dev);
+	if (ret) {
+		dev_err(dev, "failed to resume clock\n");
+		return ret;
+	}
+
+	return pm_generic_runtime_resume(dev);
+}
+
 static struct dev_pm_domain default_pm_domain = {
 	.ops = {
-		.runtime_suspend = pm_clk_suspend,
-		.runtime_resume = pm_clk_resume,
+		.runtime_suspend = sh_pm_runtime_suspend,
+		.runtime_resume = sh_pm_runtime_resume,
 		USE_PLATFORM_PM_SLEEP_OPS
 	},
 };
-- 
1.8.4

