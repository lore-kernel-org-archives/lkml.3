Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaIKNAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51551 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Forshaw" <forshaw@google.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.103385286@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 084/131] USB: whiteheat: Added bounds checking for
 bulk command response
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Forshaw <forshaw@google.com>

commit 6817ae225cd650fb1c3295d769298c38b1eba818 upstream.

This patch fixes a potential security issue in the whiteheat USB driver
which might allow a local attacker to cause kernel memory corrpution. This
is due to an unchecked memcpy into a fixed size buffer (of 64 bytes). On
EHCI and XHCI busses it's possible to craft responses greater than 64
bytes leading a buffer overflow.

Signed-off-by: James Forshaw <forshaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/whiteheat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1006,6 +1006,10 @@ static void command_port_read_callback(s
 		dbg("%s - command_info is NULL, exiting.", __func__);
 		return;
 	}
+	if (!urb->actual_length) {
+		dev_dbg(&urb->dev->dev, "%s - empty response, exiting.\n", __func__);
+		return;
+	}
 	if (status) {
 		dbg("%s - nonzero urb status: %d", __func__, status);
 		if (status != -ENOENT)
@@ -1027,7 +1031,8 @@ static void command_port_read_callback(s
 		/* These are unsolicited reports from the firmware, hence no
 		   waiting command to wakeup */
 		dbg("%s - event received", __func__);
-	} else if (data[0] == WHITEHEAT_GET_DTR_RTS) {
+	} else if ((data[0] == WHITEHEAT_GET_DTR_RTS) &&
+		(urb->actual_length - 1 <= sizeof(command_info->result_buffer))) {
 		memcpy(command_info->result_buffer, &data[1],
 						urb->actual_length - 1);
 		command_info->command_finished = WHITEHEAT_CMD_COMPLETE;

