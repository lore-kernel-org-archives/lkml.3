Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3DVOw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:52:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51391 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab3DVO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.247407406@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [10/75] USB: mos7840: fix broken TIOCMIWAIT
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e670c6af12517d08a403487b1122eecf506021cf upstream.

Make sure waiting processes are woken on modem-status changes.

Currently processes are only woken on termios changes regardless of
whether the modem status has changed.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -453,6 +453,9 @@ static void mos7840_handle_new_msr(struc
 			icount->rng++;
 			smp_wmb();
 		}
+
+		mos7840_port->delta_msr_cond = 1;
+		wake_up_interruptible(&mos7840_port->delta_msr_wait);
 	}
 }
 
@@ -2073,8 +2076,6 @@ static void mos7840_change_port_settings
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	wake_up(&mos7840_port->delta_msr_wait);
-	mos7840_port->delta_msr_cond = 1;
 	dbg("mos7840_change_port_settings mos7840_port->shadowLCR is End %x",
 	    mos7840_port->shadowLCR);
 }

