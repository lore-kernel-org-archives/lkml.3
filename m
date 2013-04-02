Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3DBXIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:08:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3DBWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 062/124] USB: mos7840: fix broken TIOCMIWAIT
Date: Tue,  2 Apr 2013 15:10:44 -0700
Message-Id: <20130402221111.396217557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e670c6af12517d08a403487b1122eecf506021cf upstream.

Make sure waiting processes are woken on modem-status changes.

Currently processes are only woken on termios changes regardless of
whether the modem status has changed.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -423,6 +423,9 @@ static void mos7840_handle_new_msr(struc
 			icount->rng++;
 			smp_wmb();
 		}
+
+		mos7840_port->delta_msr_cond = 1;
+		wake_up_interruptible(&mos7840_port->delta_msr_wait);
 	}
 }
 
@@ -2021,8 +2024,6 @@ static void mos7840_change_port_settings
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	wake_up(&mos7840_port->delta_msr_wait);
-	mos7840_port->delta_msr_cond = 1;
 	dev_dbg(&port->dev, "%s - mos7840_port->shadowLCR is End %x\n", __func__,
 		mos7840_port->shadowLCR);
 }


