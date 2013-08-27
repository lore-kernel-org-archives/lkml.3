Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3H0BLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:11:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3H0BHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [ 72/74] mei: me: fix waiting for hw ready
Date: Mon, 26 Aug 2013 18:09:10 -0700
Message-Id: <20130827010439.224620353@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit dab9bf41b23fe700c4a74133e41eb6a21706031e upstream.

1. MEI_INTEROP_TIMEOUT is in seconds not in jiffies
so we use mei_secs_to_jiffies macro
While cold boot is fast this is relevant in resume
2. wait_event_interruptible_timeout can return with
-ERESTARTSYS so do not override it with -ETIMEDOUT
3.Adjust error message

Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -238,14 +238,18 @@ static int mei_me_hw_ready_wait(struct m
 	if (mei_me_hw_is_ready(dev))
 		return 0;
 
+	dev->recvd_hw_ready = false;
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
-			dev->recvd_hw_ready, MEI_INTEROP_TIMEOUT);
+			dev->recvd_hw_ready,
+			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 	if (!err && !dev->recvd_hw_ready) {
+		if (!err)
+			err = -ETIMEDOUT;
 		dev_err(&dev->pdev->dev,
-			"wait hw ready failed. status = 0x%x\n", err);
-		return -ETIMEDOUT;
+			"wait hw ready failed. status = %d\n", err);
+		return err;
 	}
 
 	dev->recvd_hw_ready = false;


