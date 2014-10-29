Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaJ2ATo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:19:44 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41422 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaJ2ATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:19:43 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: Improve error handling when setting bus iommu
Date: Wed, 29 Oct 2014 01:22:56 +0100
Message-ID: <1721918.cCnbhQjjFO@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When some part of bus_set_iommu fails it should undo any made changes
and not simply leave everything as is.

This includes unregistering the bus notifier in iommu_bus_init when
add_iommu_group fails and also setting the bus->iommu_ops back to NULL.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/iommu/iommu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ed8b048..b0e6b94 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -818,7 +818,15 @@ static int iommu_bus_init(struct bus_type *bus, const struct iommu_ops *ops)
 		kfree(nb);
 		return err;
 	}
-	return bus_for_each_dev(bus, NULL, &cb, add_iommu_group);
+
+	err = bus_for_each_dev(bus, NULL, &cb, add_iommu_group);
+	if (err) {
+		bus_unregister_notifier(bus, nb);
+		kfree(nb);
+		return err;
+	}
+
+	return 0;
 }
 
 /**
@@ -836,13 +844,19 @@ static int iommu_bus_init(struct bus_type *bus, const struct iommu_ops *ops)
  */
 int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops)
 {
+	int err;
+
 	if (bus->iommu_ops != NULL)
 		return -EBUSY;
 
 	bus->iommu_ops = ops;
 
 	/* Do IOMMU specific setup for this bus-type */
-	return iommu_bus_init(bus, ops);
+	err = iommu_bus_init(bus, ops);
+	if (err)
+		bus->iommu_ops = NULL;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(bus_set_iommu);
 
-- 
2.0.1


