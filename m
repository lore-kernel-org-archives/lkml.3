Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaCBWW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:22:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:4295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaCBWW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,574,1389772800"; 
   d="scan'208";a="465186797"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.14] mei: me: do not reset when less than expected data is received
Date: Mon,  3 Mar 2014 00:21:28 +0200
Message-Id: <1393798888-2474-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race in ME hardware between data copy for host and interrupt
delivery. An interrupt can be delivered prior to whole data copied for the
host to read but rather then going trough the reset we just merely need to
wait for the next interrupt.

The bug is visible in read/write stress with multiple connections per client

This is a regression caused as a side effect of the commit:
commit 544f94601409653f07ae6e22d4a39e3a90dceead
mei: do not run reset flow from the interrupt thread

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     | 9 +++++++++
 drivers/misc/mei/interrupt.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6f656c0..50d8b53 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -510,7 +510,16 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			break;
 		dev_dbg(&dev->pdev->dev, "slots to read = %08x\n", slots);
 		rets = mei_irq_read_handler(dev, &complete_list, &slots);
+		/* There is a race between ME write and interrupt delivery:
+		 * Not all data is always available immediately after the
+		 * interrupt, so try to read again on the next interrupt.
+		 */
+		if (rets == -ENODATA)
+			break;
+
 		if (rets && dev->dev_state != MEI_DEV_RESETTING) {
+			dev_err(&dev->pdev->dev, "mei_irq_read_handler ret = %d.\n",
+						rets);
 			schedule_work(&dev->reset_work);
 			goto end;
 		}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index f0fbb51..c677438 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -323,7 +323,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 		dev_err(&dev->pdev->dev, "less data available than length=%08x.\n",
 				*slots);
 		/* we can't read the message */
-		ret = -ERANGE;
+		ret = -ENODATA;
 		goto end;
 	}
 
-- 
1.8.5.3

