Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaI3VnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:43:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaI3VjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/103] i2c: rcar: fix MNR interrupt handling
Date: Tue, 30 Sep 2014 14:31:42 -0700
Message-Id: <1412112708-27356-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit dd318b0df27c582ac0d72a346fd6e693700be23c upstream.

Sometimes the MNR and MST interrupts happen simultaneously  (stop  automatically
follows NACK, according to the manuals) and in such case the ID_NACK flag  isn't
set since the MST interrupt handling precedes MNR and all interrupts are cleared
and disabled then, so that MNR interrupt is never noticed -- this causes NACK'ed
transfers to be falsely reported as successful. Exchanging MNR and  MST handlers
fixes this issue, however the MNR bit  somehow  gets set again even after  being
explicitly cleared, so I decided to completely suppress handling of all disabled
interrupts (which is a good thing anyway)...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-rcar.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 56de337..e64bb5b 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -488,6 +488,9 @@ static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 
 	msr = rcar_i2c_status_get(priv);
 
+	/* Only handle interrupts that are currently enabled */
+	msr &= rcar_i2c_read(priv, ICMIER);
+
 	/*
 	 * Arbitration lost
 	 */
@@ -503,15 +506,6 @@ static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 	}
 
 	/*
-	 * Stop
-	 */
-	if (msr & MST) {
-		dev_dbg(dev, "Stop\n");
-		rcar_i2c_flags_set(priv, ID_DONE);
-		goto out;
-	}
-
-	/*
 	 * Nack
 	 */
 	if (msr & MNR) {
@@ -524,6 +518,12 @@ static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 		goto out;
 	}
 
+	/* Stop */
+	if (msr & MST) {
+		rcar_i2c_flags_set(priv, ID_DONE);
+		goto out;
+	}
+
 	/*
 	 * recv/send
 	 */
-- 
1.9.1

