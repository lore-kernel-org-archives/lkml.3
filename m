Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbbAIQhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:37:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24148 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbbAIQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:37:33 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        matthew.vick@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com
Cc: linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, brian.maly@oracle.com,
        Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] i40e: don't enable and init FCOE by default when do PF reset
Date: Sat, 10 Jan 2015 01:37:46 +0900
Message-Id: <1420821466-5747-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While do PF reset with function i40e_reset_and_rebuild(), it will
call i40e_init_pf_fcoe() by default if FCOE is defined, thus if the
PF is resetted, FCOE will be enabled whatever it was - enabled or
not.

Such bug might be hit when PF resumes from suspend, run diagnostic
test with ethtool, setup VLAN etc.

Passed building with v3.19-rc3.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index a5f2660..a2572cc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6180,9 +6180,12 @@ static void i40e_reset_and_rebuild(struct i40e_pf *pf, bool reinit)
 	}
 #endif /* CONFIG_I40E_DCB */
 #ifdef I40E_FCOE
-	ret = i40e_init_pf_fcoe(pf);
-	if (ret)
-		dev_info(&pf->pdev->dev, "init_pf_fcoe failed: %d\n", ret);
+	if (pf->flags & I40E_FLAG_FCOE_ENABLED) {
+		ret = i40e_init_pf_fcoe(pf);
+		if (ret)
+			dev_info(&pf->pdev->dev,
+				 "init_pf_fcoe failed: %d\n", ret);
+	}
 
 #endif
 	/* do basic switch setup */
-- 
1.8.3.1

