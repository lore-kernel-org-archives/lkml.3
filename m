Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbaLLGed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:34:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759293AbaLLGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <johan@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.625721286@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 106/164] USB: kobil_sct: fix non-atomic allocation in
 write path
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 191252837626fca0de694c18bb2aa64c118eda89 upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
[bwh: Backported to 3.2:
 - s/interrupt_out_urb/write_urb/
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/kobil_sct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -463,7 +463,8 @@ static int kobil_write(struct tty_struct
 			);
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->write_urb, GFP_NOIO);
+			result = usb_submit_urb(port->write_urb,
+					GFP_ATOMIC);
 			dbg("%s - port %d Send write URB returns: %i",
 					__func__, port->number, result);
 			todo = priv->filled - priv->cur_pos;
@@ -487,7 +488,7 @@ static int kobil_write(struct tty_struct
 			port->interrupt_in_urb->dev = port->serial->dev;
 
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+					GFP_ATOMIC);
 			dbg("%s - port %d Send read URB returns: %i",
 					__func__, port->number, result);
 		}

