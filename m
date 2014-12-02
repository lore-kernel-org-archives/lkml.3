Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbaLBTqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:46:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbaLBTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 090/121] target: Don't call TFO->write_pending if data_length == 0
Date: Tue,  2 Dec 2014 11:19:29 -0800
Message-Id: <1417548000-1794-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 885e7b0e181c14e4d0ddd26c688bad2b84c1ada9 upstream.

If an initiator sends a zero-length command (e.g. TEST UNIT READY) but
sets the transfer direction in the transport layer to indicate a
data-out phase, we still shouldn't try to transfer data.  At best it's
a NOP, and depending on the transport, we might crash on an
uninitialized sg list.

Reported-by: Craig Watson <craig.watson@vanguard-rugged.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3acb125..40f171b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2192,7 +2192,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * and let it call back once the write buffers are ready.
 	 */
 	target_add_to_state_list(cmd);
-	if (cmd->data_direction != DMA_TO_DEVICE) {
+	if (cmd->data_direction != DMA_TO_DEVICE || cmd->data_length == 0) {
 		target_execute_cmd(cmd);
 		return 0;
 	}
-- 
1.9.1

