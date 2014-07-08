Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaGHTPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54361 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David Cohen" <david.a.cohen@linux.intel.com>,
        "Johan Hovold" <jhovold@gmail.com>, "xiao jin" <jin.xiao@intel.com>,
        "Zhang, Qi1" <qi1.zhang@intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.859487206@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/125] USB: usb_wwan: fix urb leak in write error path
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb_wwan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -236,8 +236,10 @@ int usb_wwan_write(struct tty_struct *tt
 		    usb_pipeendpoint(this_urb->pipe), i);
 
 		err = usb_autopm_get_interface_async(port->serial->interface);
-		if (err < 0)
+		if (err < 0) {
+			clear_bit(i, &portdata->out_busy);
 			break;
+		}
 
 		/* send the data */
 		memcpy(this_urb->transfer_buffer, buf, todo);

