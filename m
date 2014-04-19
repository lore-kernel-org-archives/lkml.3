Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaDSDWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:22:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48162 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaDSDVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:21:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] phy: fix kernel oops in phy_lookup()
Date: Sat, 19 Apr 2014 08:51:43 +0530
Message-ID: <1397877704-2755-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397877704-2755-1-git-send-email-kishon@ti.com>
References: <1397877704-2755-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

The kernel oopses in phy_lookup() due to 'phy->init_data' being NULL if we
register PHYs from a device tree probing driver and then call phy_get() on a
device that has no representation in the device tree (e.g. a PCI device).
Checking the pointer before dereferening it and skipping an interation if
it's NULL prevents this kernel oops.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 623b71c..c64a2f3 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -64,6 +64,9 @@ static struct phy *phy_lookup(struct device *device, const char *port)
 	class_dev_iter_init(&iter, phy_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
 		phy = to_phy(dev);
+
+		if (!phy->init_data)
+			continue;
 		count = phy->init_data->num_consumers;
 		consumers = phy->init_data->consumers;
 		while (count--) {
-- 
1.7.9.5

