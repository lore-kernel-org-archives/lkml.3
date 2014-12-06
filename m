Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaLFSBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:01:32 -0500
Received: from 1wt.eu ([62.212.114.60]:40683 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaLFRys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:48 -0500
Message-Id: <20141206174149.238290545@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Forshaw <forshaw@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 19/25] USB: whiteheat: Added bounds checking for bulk command
 response
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: James Forshaw <forshaw@google.com>

commit c5fd4126151855330280ea9382684980afcfdd03 upstream

This patch fixes a potential security issue in the whiteheat USB driver
which might allow a local attacker to cause kernel memory corrpution. This
is due to an unchecked memcpy into a fixed size buffer (of 64 bytes). On
EHCI and XHCI busses it's possible to craft responses greater than 64
bytes leading a buffer overflow.

Signed-off-by: James Forshaw <forshaw@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(backported from commit 6817ae225cd650fb1c3295d769298c38b1eba818)
CVE-2014-3185
BugLink: http://bugs.launchpad.net/bugs/1370036
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/whiteheat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 1247be1..748c627 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1012,6 +1012,10 @@ static void command_port_read_callback(struct urb *urb)
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
@@ -1033,7 +1037,8 @@ static void command_port_read_callback(struct urb *urb)
 		/* These are unsolicited reports from the firmware, hence no
 		   waiting command to wakeup */
 		dbg("%s - event received", __func__);
-	} else if (data[0] == WHITEHEAT_GET_DTR_RTS) {
+	} else if ((data[0] == WHITEHEAT_GET_DTR_RTS) &&
+		(urb->actual_length - 1 <= sizeof(command_info->result_buffer))) {
 		memcpy(command_info->result_buffer, &data[1],
 						urb->actual_length - 1);
 		command_info->command_finished = WHITEHEAT_CMD_COMPLETE;
-- 
1.7.12.2.21.g234cd45.dirty



