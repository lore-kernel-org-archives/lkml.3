Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaHUGlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:41:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:52754 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaHUGla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375133510"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/2] ACPI/EC: Add support to disallow QR_EC to be issued before completing the previous QR_EC.
Date: Thu, 21 Aug 2014 14:41:26 +0800
Message-Id: <54a1dc3591438f6fc5765dbabc17bdaa50df0dd4.1408601898.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1408601898.git.lv.zheng@intel.com>
References: <cover.1408601898.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is platform refusing to respond QR_EC when SCI_EVT isn't set.
A known such platform is Acer Aspire V5-573G.

By disallowing QR_EC issuing without completing the previous one, we are
able to reduce the possibilities to trigger issues on such platforms.

Note that this fix can only reduce the occurrence rate of this issue, but
this issue may still occur when such a platform doesn't clear SCI_EVT
before or immediately after completing the previous QR_EC transaction. This
patch cannot fix CLEAR_ON_RESUME quirk which also relies on the assumption
that the platforms are able to respond even when SCI_EVT isn't set.

But this patch is still useful as it can help to reduce the number of
scheduled QR_EC work items.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reported-and-tested-by: Alexander Mezin <mezin.alexander@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5e1ed31..9922cc4 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -303,11 +303,11 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	start_transaction(ec);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
-		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	ec->curr = NULL;
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;
-- 
1.7.10

