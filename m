Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbAYVqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:46:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:63921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbbAYVqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:46:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444962548"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        <stable@vger.kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 2/2 3.19] mei: me: release hw from reset only during the reset flow
Date: Sun, 25 Jan 2015 23:45:28 +0200
Message-Id: <1422222328-16109-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422222328-16109-1-git-send-email-tomas.winkler@intel.com>
References: <1422222328-16109-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We might enter the interrupt handler with hw_ready already set,
but prior we actually started the reset flow.
To soleve this we move the reset release from the interrupt handler
to the HW start wait function which is part of the reset sequence.

Cc: <stable@vger.kernel.org> #3.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ccc1b405ca21..f8fd503dfbd6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -335,6 +335,7 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
 		return -ETIME;
 	}
 
+	mei_me_hw_reset_release(dev);
 	dev->recvd_hw_ready = false;
 	return 0;
 }
@@ -731,9 +732,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
 		if (mei_hw_is_ready(dev)) {
-			mei_me_hw_reset_release(dev);
 			dev_dbg(dev->dev, "we need to start the dev.\n");
-
 			dev->recvd_hw_ready = true;
 			wake_up(&dev->wait_hw_ready);
 		} else {
-- 
1.9.3

