Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaHTLt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:49:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59046 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Tisssoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 100/104] HID: logitech-dj: Fix USB 3.0 issue
Date: Wed, 20 Aug 2014 13:44:03 +0200
Message-Id: <b2afd9e6ecc1f6622770c66610c26cad676445e9.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 42c22dbf81ebd1146960875ddfe71630cb2b3ae6 upstream.

This fix (not very clean though) should fix the long time USB3
issue that was spotted last year. The rational has been given by
Hans de Goede:

 ----

I think the most likely cause for this is a firmware bug
in the unifying receiver, likely a race condition.

The most prominent difference between having a USB-2 device
plugged into an EHCI (so USB-2 only) port versus an XHCI
port will be inter packet timing. Specifically if you
send packets (ie hid reports) one at a time, then with
the EHCI controller their will be a significant pause
between them, where with XHCI they will be very close
together in time.

The reason for this is the difference in EHCI / XHCI
controller OS <-> driver interfaces.

For non periodic endpoints (control, bulk) the EHCI uses a
circular linked-list of commands in dma-memory, which it
follows to execute commands, if the list is empty, it
will go into an idle state and re-check periodically.

The XHCI uses a ring of commands per endpoint, and if the OS
places anything new on the ring it will do an ioport write,
waking up the XHCI making it send the new packet immediately.

For periodic transfers (isoc, interrupt) the delay between
packets when sending one at a time (rather then queuing them
up) will be even larger, because they need to be inserted into
the EHCI schedule 2 ms in the future so the OS driver can be
sure that the EHCI driver does not try to start executing the
time slot in question before the insertion has completed.

So a possible fix may be to insert a delay between packets
being send to the receiver.

 ----

I tested this on a buggy Haswell USB 3.0 motherboard, and I always
get the notification after adding the msleep.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-logitech-dj.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 2e5302462efb..834cda2c25c7 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -516,6 +516,14 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 	dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
 	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
 	kfree(dj_report);
+
+	/*
+	 * Ugly sleep to work around a USB 3.0 bug when the receiver is still
+	 * processing the "switch-to-dj" command while we send an other command.
+	 * 50 msec should gives enough time to the receiver to be ready.
+	 */
+	msleep(50);
+
 	return retval;
 }
 
-- 
2.0.4

