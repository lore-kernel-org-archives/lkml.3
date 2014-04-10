Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422702AbaDJW7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:59:36 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:35757 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDJW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:59:34 -0400
To: kishon@ti.com
Subject: [PATCH] phy: fix kernel oops in phy_lookup()
Cc: linux-sh@vger.kernel.org, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Date: Fri, 11 Apr 2014 02:59:42 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404110259.43282.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel oopses in phy_lookup() due to 'phy->init_data' being NULL if we
register PHYs from a device tree probing driver and then call phy_get() on a
device that has no representation in the device tree (e.g. a PCI device).
Checking the pointer before dereferening it and skipping an interation if
it's NULL prevents this kernel oops.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'fixes' branch of Kishon's 'linux-phy.git' repo.

 drivers/phy/phy-core.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-phy/drivers/phy/phy-core.c
===================================================================
--- linux-phy.orig/drivers/phy/phy-core.c
+++ linux-phy/drivers/phy/phy-core.c
@@ -64,6 +64,9 @@ static struct phy *phy_lookup(struct dev
 	class_dev_iter_init(&iter, phy_class, NULL, NULL);
 	while ((dev = class_dev_iter_next(&iter))) {
 		phy = to_phy(dev);
+
+		if (!phy->init_data)
+			continue;
 		count = phy->init_data->num_consumers;
 		consumers = phy->init_data->consumers;
 		while (count--) {
