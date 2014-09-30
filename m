Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaI3VeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaI3VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Forshaw <forshaw@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/103] USB: whiteheat: Added bounds checking for bulk command response
Date: Tue, 30 Sep 2014 14:30:11 -0700
Message-Id: <1412112708-27356-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/whiteheat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 36a7740..cc5a430 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -521,6 +521,10 @@ static void command_port_read_callback(struct urb *urb)
 		dev_dbg(&urb->dev->dev, "%s - command_info is NULL, exiting.\n", __func__);
 		return;
 	}
+	if (!urb->actual_length) {
+		dev_dbg(&urb->dev->dev, "%s - empty response, exiting.\n", __func__);
+		return;
+	}
 	if (status) {
 		dev_dbg(&urb->dev->dev, "%s - nonzero urb status: %d\n", __func__, status);
 		if (status != -ENOENT)
@@ -541,7 +545,8 @@ static void command_port_read_callback(struct urb *urb)
 		/* These are unsolicited reports from the firmware, hence no
 		   waiting command to wakeup */
 		dev_dbg(&urb->dev->dev, "%s - event received\n", __func__);
-	} else if (data[0] == WHITEHEAT_GET_DTR_RTS) {
+	} else if ((data[0] == WHITEHEAT_GET_DTR_RTS) &&
+		(urb->actual_length - 1 <= sizeof(command_info->result_buffer))) {
 		memcpy(command_info->result_buffer, &data[1],
 						urb->actual_length - 1);
 		command_info->command_finished = WHITEHEAT_CMD_COMPLETE;
-- 
1.9.1

