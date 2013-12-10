Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3LJIOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:14:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3LJICE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 38/62] PNP: fix restoring devices after hibernation
Date: Tue, 10 Dec 2013 00:01:09 -0800
Message-Id: <20131210080100.115086930@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 8a37ea50e7acf8db6821ba094ca41384e7d8c70c upstream.

On returning from hibernation 'restore' callback is called,
not 'resume'.  Fix it.

Fixes: eaf140b60ec9 (PNP: convert PNP driver bus legacy pm_ops to dev_pm_ops)
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/driver.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -197,6 +197,11 @@ static int pnp_bus_freeze(struct device
 	return __pnp_bus_suspend(dev, PMSG_FREEZE);
 }
 
+static int pnp_bus_poweroff(struct device *dev)
+{
+	return __pnp_bus_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int pnp_bus_resume(struct device *dev)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
@@ -234,9 +239,14 @@ static int pnp_bus_resume(struct device
 }
 
 static const struct dev_pm_ops pnp_bus_dev_pm_ops = {
+	/* Suspend callbacks */
 	.suspend = pnp_bus_suspend,
-	.freeze = pnp_bus_freeze,
 	.resume = pnp_bus_resume,
+	/* Hibernate callbacks */
+	.freeze = pnp_bus_freeze,
+	.thaw = pnp_bus_resume,
+	.poweroff = pnp_bus_poweroff,
+	.restore = pnp_bus_resume,
 };
 
 struct bus_type pnp_bus_type = {


