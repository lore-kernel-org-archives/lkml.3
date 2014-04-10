Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257AbaDJEJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:09:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934766AbaDJDWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 065/134] USB: mos7840: fix broken TIOCMIWAIT
Date: Wed,  9 Apr 2014 20:23:01 -0700
Message-Id: <20140410032308.425414535@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e670c6af12517d08a403487b1122eecf506021cf upstream.

Make sure waiting processes are woken on modem-status changes.

Currently processes are only woken on termios changes regardless of
whether the modem status has changed.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 
@@ -2074,8 +2077,6 @@ static void mos7840_change_port_settings
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	wake_up(&mos7840_port->delta_msr_wait);
-	mos7840_port->delta_msr_cond = 1;
 	dbg("mos7840_change_port_settings mos7840_port->shadowLCR is End %x",
 	    mos7840_port->shadowLCR);
 }


