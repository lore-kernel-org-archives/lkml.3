Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3BCBfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:35:22 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64723 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3BCBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:39 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 11/62] dca: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:12 -0800
Message-Id: <1359854463-2538-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/dca/dca-sysfs.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 591b659..126cf29 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -53,22 +53,19 @@ void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
 int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 {
 	struct device *cd;
-	int err = 0;
+	int ret;
 
-idr_try_again:
-	if (!idr_pre_get(&dca_idr, GFP_KERNEL))
-		return -ENOMEM;
+	idr_preload(GFP_KERNEL);
 	spin_lock(&dca_idr_lock);
-	err = idr_get_new(&dca_idr, dca, &dca->id);
+
+	ret = idr_alloc(&dca_idr, dca, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		dca->id = ret;
+
 	spin_unlock(&dca_idr_lock);
-	switch (err) {
-	case 0:
-		break;
-	case -EAGAIN:
-		goto idr_try_again;
-	default:
-		return err;
-	}
+	idr_preload_end();
+	if (ret < 0)
+		return ret;
 
 	cd = device_create(dca_class, dev, MKDEV(0, 0), NULL, "dca%d", dca->id);
 	if (IS_ERR(cd)) {
-- 
1.8.1

