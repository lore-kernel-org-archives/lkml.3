Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaLFPSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:18:13 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47732 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752169AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 51/66] target: Don't call TFO->write_pending if data_length == 0
Date: Sat,  6 Dec 2014 16:07:43 +0100
Message-Id: <63af3438d269f8a2c27ad1c2d5da7f4b190b8462.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 885e7b0e181c14e4d0ddd26c688bad2b84c1ada9 upstream.

If an initiator sends a zero-length command (e.g. TEST UNIT READY) but
sets the transfer direction in the transport layer to indicate a
data-out phase, we still shouldn't try to transfer data.  At best it's
a NOP, and depending on the transport, we might crash on an
uninitialized sg list.

Reported-by: Craig Watson <craig.watson@vanguard-rugged.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b37371ee9f95..3931b50eeefd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2231,7 +2231,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * and let it call back once the write buffers are ready.
 	 */
 	target_add_to_state_list(cmd);
-	if (cmd->data_direction != DMA_TO_DEVICE) {
+	if (cmd->data_direction != DMA_TO_DEVICE || cmd->data_length == 0) {
 		target_execute_cmd(cmd);
 		return 0;
 	}
-- 
2.1.3

