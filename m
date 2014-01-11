Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaAMMYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:24:44 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:48345 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751357AbaAMMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:24:41 -0500
X-Greylist: delayed 170333 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 07:24:41 EST
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] power: clock_ops.c: check return of clk_enable() in pm_clk_resume()
Date: Sat, 11 Jan 2014 13:05:39 +0000
Message-Id: <1389445540-21426-2-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_enable() call in the pm_clk_resume() call returns an error
that is not being checked. If clk_enable() fails then we should
not set the state of the clock to PCE_STATUS_ENABLED.

Note, the issue of warning the user if this fails has not been
addressed in this patch as this is not the only place the driver
calls clk_enable().

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
---
 drivers/base/power/clock_ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index b9dd8fa..9bb95ab 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -252,6 +252,7 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
+	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -262,8 +263,9 @@ int pm_clk_resume(struct device *dev)
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (ce->status < PCE_STATUS_ERROR) {
-			clk_enable(ce->clk);
-			ce->status = PCE_STATUS_ENABLED;
+			ret = clk_enable(ce->clk);
+			if (ret == 0)
+				ce->status = PCE_STATUS_ENABLED;
 		}
 	}
 
-- 
1.8.5.2

