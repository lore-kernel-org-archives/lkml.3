Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaF1Rtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:49:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaF1Rtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        xiao jin <jin.xiao@intel.com>, "Zhang, Qi1" <qi1.zhang@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 041/110] USB: usb_wwan: fix urb leak in write error path
Date: Sat, 28 Jun 2014 10:46:38 -0700
Message-Id: <20140628174547.604045883@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/usb_wwan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -228,8 +228,10 @@ int usb_wwan_write(struct tty_struct *tt
 			usb_pipeendpoint(this_urb->pipe), i);
 
 		err = usb_autopm_get_interface_async(port->serial->interface);
-		if (err < 0)
+		if (err < 0) {
+			clear_bit(i, &portdata->out_busy);
 			break;
+		}
 
 		/* send the data */
 		memcpy(this_urb->transfer_buffer, buf, todo);


