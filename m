Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaIWCjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:38278 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaIWCjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:47 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Forshaw <forshaw@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 25/45] USB: whiteheat: Added bounds checking for bulk command response
Date: Tue, 23 Sep 2014 10:31:27 +0800
Message-Id: <1411439507-30391-25-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Forshaw <forshaw@google.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 6817ae225cd650fb1c3295d769298c38b1eba818 upstream.

This patch fixes a potential security issue in the whiteheat USB driver
which might allow a local attacker to cause kernel memory corrpution. This
is due to an unchecked memcpy into a fixed size buffer (of 64 bytes). On
EHCI and XHCI busses it's possible to craft responses greater than 64
bytes leading a buffer overflow.

Signed-off-by: James Forshaw <forshaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/whiteheat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 0d06d7c..bf7014d 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -953,6 +953,10 @@ static void command_port_read_callback(struct urb *urb)
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
@@ -974,7 +978,8 @@ static void command_port_read_callback(struct urb *urb)
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
1.7.9.5

