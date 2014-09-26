Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaIZKeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:34:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbaIZJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Forshaw <forshaw@google.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/142] USB: whiteheat: Added bounds checking for bulk command response
Date: Fri, 26 Sep 2014 11:43:55 +0200
Message-Id: <b3d60c320f6597c2be0bcf580cf8093c12c4555f.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Forshaw <forshaw@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6817ae225cd650fb1c3295d769298c38b1eba818 upstream.

This patch fixes a potential security issue in the whiteheat USB driver
which might allow a local attacker to cause kernel memory corrpution. This
is due to an unchecked memcpy into a fixed size buffer (of 64 bytes). On
EHCI and XHCI busses it's possible to craft responses greater than 64
bytes leading a buffer overflow.

Signed-off-by: James Forshaw <forshaw@google.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/whiteheat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 36a7740e827c..cc5a430dc357 100644
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
2.1.0

