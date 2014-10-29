Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaJ2Ddv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:33:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:22265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbaJ2Dds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:33:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,807,1406617200"; 
   d="scan'208";a="613180765"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/2] Revert "ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC"
Date: Wed, 29 Oct 2014 11:33:43 +0800
Message-Id: <79ca204b4d6632c596b6ff33133e99c471b3d633.1414553399.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414553399.git.lv.zheng@intel.com>
References: <544CE637.7000406@odi.ch> <cover.1414553399.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that the following commit breaks Samsung hardware:
 Commit: 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4.
 Subject: ACPI / EC: Add support to disallow QR_EC to be issued before
          completing previous QR_EC

Which means the Samsung behavior conflicts with the Acer behavior.

1. Samsung may behave like:
   [ +event 1 ] SCI_EVT set
   [ +event 2 ] SCI_EVT set
                              write QR_EC
                              read event
   [ -event 1 ] SCI_EVT clear
   Without the above commit, Samsung can work:
   [ +event 1 ] SCI_EVT set
   [ +event 2 ] SCI_EVT set
                              write QR_EC
                              CAN prepare next QR_EC as SCI_EVT=1
                              read event
   [ -event 1 ] SCI_EVT clear
                              write QR_EC
                              read event
   [ -event 2 ] SCI_EVT clear
   With the above commit, Samsung cannot work:
   [ +event 1 ] SCI_EVT set
   [ +event 2 ] SCI_EVT set
                              write QR_EC
                              read event
   [ -event 1 ] SCI_EVT clear
                              CANNOT prepare next QR_EC as SCI_EVT=0
2. Acer may behave like:
   [ +event 1 ] SCI_EVT set
   [ +event 2 ]
                              write QR_EC
                              read event
   [ -event 1 ] SCI_EVT clear
   [ +event 2 ] SCI_EVT set
   Without the above commit, Acer cannot work when there is only 1 event:
   [ +event 1 ] SCI_EVT set
                              write QR_EC
                              can prepared next QR_EC as SCI_EVT=1
                              read event
   [ -event 1 ] SCI_EVT clear
                              CANNOT write QR_EC as SCI_EVT=0
   With the above commit, Acer can work:
   [ +event 1 ] SCI_EVT set
   [ +event 2 ]
                              write QR_EC
                              read event
   [ -event 1 ] SCI_EVT set
                              can prepare next QR_EC because SCI_EVT=0
                              CAN write QR_EC as SCI_EVT=1

Since Acer can also work with only the following commit applied:
 Commit: 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08
 Subject: ACPI / EC: Add support to disallow QR_EC to be issued when
          SCI_EVT isn't set
We can revert the above commit.

This reverts commit 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4.

Conflicts:

	drivers/acpi/ec.c

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=44161
Reported-and-tested-by: Ortwin Gl¨¹ck <odi@odi.ch>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3d304ff..31b699f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -334,13 +334,13 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
 	start_transaction(ec);
-	spin_unlock_irqrestore(&ec->lock, tmp);
-	ret = ec_poll(ec);
-	spin_lock_irqsave(&ec->lock, tmp);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY) {
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 		pr_debug("***** Event stopped *****\n");
 	}
+	spin_unlock_irqrestore(&ec->lock, tmp);
+	ret = ec_poll(ec);
+	spin_lock_irqsave(&ec->lock, tmp);
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
-- 
1.7.10

