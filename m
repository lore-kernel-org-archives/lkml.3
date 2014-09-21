Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaIUR6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaIUR6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:58:39 -0400
From: Mark Salter <msalter@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] iommu/core: fix bus notifier breakage
Date: Sun, 21 Sep 2014 13:58:24 -0400
Message-Id: <1411322304-3925-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_bus_init() registers a bus notifier on the given bus by using
a statically defined notifier block:

  static struct notifier_block iommu_bus_nb = {
          .notifier_call = iommu_bus_notifier,
  };

This same notifier block is used for all busses. This causes a
problem for notifiers registered after iommu has registered this
callback on multiple busses. The problem is that a subsequent
notifier being registered on a bus which has this iommu notifier
will also get linked in to the notifier list of all other busses
which have this iommu notifier.

This patch fixes this by allocating the notifier_block at runtime.
Some error checking is also added to catch any allocation failure
or notifier registration error.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/iommu/iommu.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0639b92..f00697a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -770,18 +770,26 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static struct notifier_block iommu_bus_nb = {
-	.notifier_call = iommu_bus_notifier,
-};
-
-static void iommu_bus_init(struct bus_type *bus, const struct iommu_ops *ops)
+static int iommu_bus_init(struct bus_type *bus, const struct iommu_ops *ops)
 {
+	int err;
+	struct notifier_block *nb;
 	struct iommu_callback_data cb = {
 		.ops = ops,
 	};
 
-	bus_register_notifier(bus, &iommu_bus_nb);
-	bus_for_each_dev(bus, NULL, &cb, add_iommu_group);
+	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
+	if (!nb)
+		return -ENOMEM;
+
+	nb->notifier_call = iommu_bus_notifier;
+
+	err = bus_register_notifier(bus, nb);
+	if (err) {
+		kfree(nb);
+		return err;
+	}
+	return bus_for_each_dev(bus, NULL, &cb, add_iommu_group);
 }
 
 /**
@@ -805,9 +813,7 @@ int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops)
 	bus->iommu_ops = ops;
 
 	/* Do IOMMU specific setup for this bus-type */
-	iommu_bus_init(bus, ops);
-
-	return 0;
+	return iommu_bus_init(bus, ops);
 }
 EXPORT_SYMBOL_GPL(bus_set_iommu);
 
-- 
1.9.3

