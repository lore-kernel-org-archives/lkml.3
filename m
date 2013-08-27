Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3H0BHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3H0BHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [ 70/74] mei: me: fix reset state machine
Date: Mon, 26 Aug 2013 18:09:08 -0700
Message-Id: <20130827010438.863544393@linuxfoundation.org>
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

commit 315a383ad7dbd484fafb93ef08038e3dbafbb7a8 upstream.

ME HW ready bit is down after hw reset was asserted or on error.
Only on error we need to enter the reset flow, additional reset
need to be prevented when reset was triggered during
initialization , power up/down or a reset is already in progress

Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -482,7 +482,9 @@ irqreturn_t mei_me_irq_thread_handler(in
 	/* check if ME wants a reset */
 	if (!mei_hw_is_ready(dev) &&
 	    dev->dev_state != MEI_DEV_RESETTING &&
-	    dev->dev_state != MEI_DEV_INITIALIZING) {
+	    dev->dev_state != MEI_DEV_INITIALIZING &&
+	    dev->dev_state != MEI_DEV_POWER_DOWN &&
+	    dev->dev_state != MEI_DEV_POWER_UP) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
 		mei_reset(dev, 1);
 		mutex_unlock(&dev->device_lock);


