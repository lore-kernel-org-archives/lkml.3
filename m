Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3LFXdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:33:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab3LFXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 084/152] IB/qib: Fix txselect regression
Date: Fri,  6 Dec 2013 15:10:08 -0800
Message-Id: <1386371476-2477-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 2fadd83184d58701f1116ca578465b5a75f9417c upstream.

Commit 7fac33014f54("IB/qib: checkpatch fixes") was overzealous in
removing a simple_strtoul for a parse routine, setup_txselect().  That
routine is required to handle a multi-value string.

Unwind that aspect of the fix.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/qib/qib_iba7322.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 3f6b21e..bd8cb0f 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5853,21 +5853,20 @@ static int setup_txselect(const char *str, struct kernel_param *kp)
 {
 	struct qib_devdata *dd;
 	unsigned long val;
-	int ret;
-
+	char *n;
 	if (strlen(str) >= MAX_ATTEN_LEN) {
 		pr_info("txselect_values string too long\n");
 		return -ENOSPC;
 	}
-	ret = kstrtoul(str, 0, &val);
-	if (ret || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
+	val = simple_strtoul(str, &n, 0);
+	if (n == str || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
 				TXDDS_MFG_SZ)) {
 		pr_info("txselect_values must start with a number < %d\n",
 			TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ + TXDDS_MFG_SZ);
-		return ret ? ret : -EINVAL;
+		return -EINVAL;
 	}
-
 	strcpy(txselect_list, str);
+
 	list_for_each_entry(dd, &qib_dev_list, list)
 		if (dd->deviceid == PCI_DEVICE_ID_QLOGIC_IB_7322)
 			set_no_qsfp_atten(dd, 1);
-- 
1.8.3.2

