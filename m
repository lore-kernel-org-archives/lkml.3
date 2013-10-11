Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3JKTlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab3JKTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [ 062/135] iommu/arm-smmu: dont enable SMMU device until probing has completed
Date: Fri, 11 Oct 2013 12:39:03 -0700
Message-Id: <20131011193952.026756189@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit fd90cecbde065eac6ecc3ef38abace725ad27010 upstream.

We currently reset and enable the SMMU before the device has finished
being probed, so if we fail later on (for example, because we couldn't
request a global irq successfully) then we will leave the device in an
active state.

This patch delays the reset and enabling of the SMMU hardware until
probing has completed.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1839,8 +1839,6 @@ static int arm_smmu_device_dt_probe(stru
 		goto out_put_parent;
 	}
 
-	arm_smmu_device_reset(smmu);
-
 	for (i = 0; i < smmu->num_global_irqs; ++i) {
 		err = request_irq(smmu->irqs[i],
 				  arm_smmu_global_fault,
@@ -1858,6 +1856,8 @@ static int arm_smmu_device_dt_probe(stru
 	spin_lock(&arm_smmu_devices_lock);
 	list_add(&smmu->list, &arm_smmu_devices);
 	spin_unlock(&arm_smmu_devices_lock);
+
+	arm_smmu_device_reset(smmu);
 	return 0;
 
 out_free_irqs:


