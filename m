Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbaJ3Axa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:53:30 -0400
Received: from jim.sh ([75.150.123.25]:51599 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbaJ3Ax3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:53:29 -0400
Date: Wed, 29 Oct 2014 20:53:14 -0400
From: Jim Paris <jim@jtan.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3] cdc-acm: ensure that termios get set when the port is
 activated
Message-ID: <20141030005314.GA6049@psychosis.jim.sh>
References: <20141029150716.GG2265@localhost>
 <1414596640-28555-1-git-send-email-johan@kernel.org>
 <20141029155602.GC17399@kroah.com>
 <20141029155840.GJ2265@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029155840.GJ2265@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver wasn't properly configuring the hardware for the current
termios settings under all conditions.  Ensure that termios are
written to the device when the port is activated.

Signed-off-by: Jim Paris <jim@jtan.com>
---

Switched to Johan's suggestion of using a prototype rather than moving
acm_tty_set_termios.  This depends on his patch in order to get proper
DTR handling.

Thanks,
Jim 

---
 drivers/usb/class/cdc-acm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e934e19f49f5..d2cd1b6d02a7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -58,6 +58,9 @@ static struct usb_driver acm_driver;
 static struct tty_driver *acm_tty_driver;
 static struct acm *acm_table[ACM_TTY_MINORS];
 
+static void acm_tty_set_termios(struct tty_struct *tty,
+				struct ktermios *termios_old);
+
 static DEFINE_MUTEX(acm_table_lock);
 
 /*
@@ -554,6 +557,8 @@ static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
 		goto error_submit_urb;
 	}
 
+	acm_tty_set_termios(tty, NULL);
+
 	/*
 	 * Unthrottle device in case the TTY was closed while throttled.
 	 */
-- 
2.1.0

