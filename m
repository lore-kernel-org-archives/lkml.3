Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3ISVwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:52:53 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57671 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:52:51 -0400
Date: Thu, 19 Sep 2013 14:52:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12-rc1] USB: input: cm109.c: Convert high volume
 dev_err() to dev_err_ratelimited()
Message-ID: <20130919215246.GB16015@core.coreip.homeip.net>
References: <1378830193-48384-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378830193-48384-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, Sep 10, 2013 at 10:23:13AM -0600, Tim Gardner wrote:
> BugLink: http://bugs.launchpad.net/bugs/1222850
> 
> This input device can get into a state that produces a high
> volume of device status errors. Attempt to throttle these
> error messages such that the kernel log is not flooded.
> 

Only 2 of these printks need to be rate-limited, as other failures are
fatal to the driver since it will not resubmit the IO.

Also I think we need to try and resubmit control URB to try and execute
buzzer command if previous one failed.

BTW, EPROTO/EILSEQ errors mentioned in the launchpad bug seem to relate
to timeout/CRC errors reported by the host controller, so it must indeed
be the extender that is misbehaving.

Thanks.

-- 
Dmitry


Input: cm109 - convert high volume dev_err() to dev_err_ratelimited()

From: Tim Gardner <tim.gardner@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/1222850

This input device can get into a state that produces a high
volume of device status errors. Attempt to throttle these
error messages such that the kernel log is not flooded.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/cm109.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 082684e..9365535 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -351,7 +351,9 @@ static void cm109_urb_irq_callback(struct urb *urb)
 	if (status) {
 		if (status == -ESHUTDOWN)
 			return;
-		dev_err(&dev->intf->dev, "%s: urb status %d\n", __func__, status);
+		dev_err_ratelimited(&dev->intf->dev, "%s: urb status %d\n",
+				    __func__, status);
+		goto out;
 	}
 
 	/* Special keys */
@@ -418,8 +420,12 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 	     dev->ctl_data->byte[2],
 	     dev->ctl_data->byte[3]);
 
-	if (status)
-		dev_err(&dev->intf->dev, "%s: urb status %d\n", __func__, status);
+	if (status) {
+		if (status == -ESHUTDOWN)
+			return;
+		dev_err_ratelimited(&dev->intf->dev, "%s: urb status %d\n",
+				    __func__, status);
+	}
 
 	spin_lock(&dev->ctl_submit_lock);
 
@@ -427,7 +433,7 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 
 	if (likely(!dev->shutdown)) {
 
-		if (dev->buzzer_pending) {
+		if (dev->buzzer_pending || status) {
 			dev->buzzer_pending = 0;
 			dev->ctl_urb_pending = 1;
 			cm109_submit_buzz_toggle(dev);
