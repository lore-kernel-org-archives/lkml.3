Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbaGCJWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbaGCJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/198] USB: usb_wwan: fix urb leak in write error path
Date: Thu,  3 Jul 2014 10:18:23 +0100
Message-Id: <1404379241-8590-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiao jin <jin.xiao@intel.com>

commit db0904737947d509844e171c9863ecc5b4534005 upstream.

When enable usb serial for modem data, sometimes the tty is blocked
in tty_wait_until_sent because portdata->out_busy always is set and
have no chance to be cleared.

We find a bug in write error path. usb_wwan_write set portdata->out_busy
firstly, then try autopm async with error. No out urb submit and no
usb_wwan_outdat_callback to this write, portdata->out_busy can't be
cleared.

This patch clear portdata->out_busy if usb_wwan_write try autopm async
with error.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Zhang, Qi1 <qi1.zhang@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 6fa78361be56..7096d0ba1d0f 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -228,8 +228,10 @@ int usb_wwan_write(struct tty_struct *tty, struct usb_serial_port *port,
 			usb_pipeendpoint(this_urb->pipe), i);
 
 		err = usb_autopm_get_interface_async(port->serial->interface);
-		if (err < 0)
+		if (err < 0) {
+			clear_bit(i, &portdata->out_busy);
 			break;
+		}
 
 		/* send the data */
 		memcpy(this_urb->transfer_buffer, buf, todo);
-- 
1.9.1

