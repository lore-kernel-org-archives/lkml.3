Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaLEWqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:46:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaLEWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Craig Watson <craig.watson@vanguard-rugged.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.17 084/122] target: Dont call TFO->write_pending if data_length == 0
Date: Fri,  5 Dec 2014 14:44:18 -0800
Message-Id: <20141205223318.415032893@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2295,7 +2295,7 @@ transport_generic_new_cmd(struct se_cmd
 	 * and let it call back once the write buffers are ready.
 	 */
 	target_add_to_state_list(cmd);
-	if (cmd->data_direction != DMA_TO_DEVICE) {
+	if (cmd->data_direction != DMA_TO_DEVICE || cmd->data_length == 0) {
 		target_execute_cmd(cmd);
 		return 0;
 	}


