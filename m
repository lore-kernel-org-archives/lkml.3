Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3LBUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:09:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3LBTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.12 062/212] IB/qib: Fix txselect regression
Date: Mon,  2 Dec 2013 11:14:13 -0800
Message-Id: <20131202191254.978893685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 2fadd83184d58701f1116ca578465b5a75f9417c upstream.

Commit 7fac33014f54("IB/qib: checkpatch fixes") was overzealous in
removing a simple_strtoul for a parse routine, setup_txselect().  That
routine is required to handle a multi-value string.

Unwind that aspect of the fix.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_iba7322.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6190,21 +6190,20 @@ static int setup_txselect(const char *st
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


