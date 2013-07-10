Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab3GJEJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:09:48 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:38222
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab3GJEJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:09:47 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: rafael.j.wysocki@intel.com, bhelgaas@google.com, a.zummo@towertech.it,
        key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com, matthew.garrett@nebula.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, tpmdd-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 1/4] pnp: Change pnp bus pm_ops to invoke pnp driver dev_pm_ops if specified
Date: Tue,  9 Jul 2013 22:09:26 -0600
Message-Id: <1373429366-3870-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_bus_suspend() and pnp_bus_resume() invoke legacy pm_ops from
pnp_driver. Changed pnp_bus_suspend() and pnp_bus_resume() to check
if pnp driver has dev_pm_ops and call. If dev_pm_ops don't exist, then
call use legacy pm_ops. Without this change, pnp_driver dev_pm_ops will
not get called.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/pnp/driver.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index 00e9403..c3f9e89 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -163,6 +163,13 @@ static int pnp_bus_suspend(struct device *dev, pm_message_t state)
 	if (!pnp_drv)
 		return 0;
 
+	if (pnp_drv->driver.pm && pnp_drv->driver.pm->suspend) {
+		error = pnp_drv->driver.pm->suspend(dev);
+		suspend_report_result(pnp_drv->driver.pm->suspend, error);
+		if (error)
+			return error;
+	}
+
 	if (pnp_drv->suspend) {
 		error = pnp_drv->suspend(pnp_dev, state);
 		if (error)
@@ -201,6 +208,12 @@ static int pnp_bus_resume(struct device *dev)
 			return error;
 	}
 
+	if (pnp_drv->driver.pm && pnp_drv->driver.pm->resume) {
+		error = pnp_drv->driver.pm->resume(dev);
+		if (error)
+			return error;
+	}
+
 	if (pnp_drv->resume) {
 		error = pnp_drv->resume(pnp_dev);
 		if (error)
-- 
1.7.10.4

