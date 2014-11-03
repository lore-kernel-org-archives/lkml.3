Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaKCFQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:24181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaKCFQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="410182651"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/6] ACPI/EC: Enhance the checks to apply to QR_EC transactions.
Date: Mon,  3 Nov 2014 13:16:20 +0800
Message-Id: <8f69ee1f6184cfd9ec9273bb034d8c2822c230f4.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a check is applied to new transactions, but QR_EC transactions
are not included. This patch merges the code path to make the check also
applying to the QR_EC transactions.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Ortwin Glück <odi@odi.ch>
---
 drivers/acpi/ec.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 192cd11..9a51f7a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -336,6 +336,10 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (!acpi_ec_started(ec)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	pr_debug("***** Command(%s) started *****\n",
@@ -351,6 +355,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
+unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
 }
@@ -365,10 +370,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 	if (t->rdata)
 		memset(t->rdata, 0, t->rlen);
 	mutex_lock(&ec->mutex);
-	if (!acpi_ec_started(ec)) {
-		status = -EINVAL;
-		goto unlock;
-	}
 	if (ec->global_lock) {
 		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
 		if (ACPI_FAILURE(status)) {
-- 
1.7.10

