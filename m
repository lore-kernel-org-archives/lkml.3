Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286Ab3CZPXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220Ab3CZPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 107/150] USB: mos7840: fix broken TIOCMIWAIT
Date: Tue, 26 Mar 2013 15:20:06 +0000
Message-Id: <1364311249-14454-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e670c6af12517d08a403487b1122eecf506021cf upstream.

Make sure waiting processes are woken on modem-status changes.

Currently processes are only woken on termios changes regardless of
whether the modem status has changed.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 1b5ea51..be5f09b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -442,6 +442,9 @@ static void mos7840_handle_new_msr(struct moschip_port *port, __u8 new_msr)
 			icount->rng++;
 			smp_wmb();
 		}
+
+		mos7840_port->delta_msr_cond = 1;
+		wake_up_interruptible(&mos7840_port->delta_msr_wait);
 	}
 }
 
@@ -2096,8 +2099,6 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	wake_up(&mos7840_port->delta_msr_wait);
-	mos7840_port->delta_msr_cond = 1;
 	dbg("mos7840_change_port_settings mos7840_port->shadowLCR is End %x",
 	    mos7840_port->shadowLCR);
 }
-- 
1.8.1.2

