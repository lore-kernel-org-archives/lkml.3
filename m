Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaFWJEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:04:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55474 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Mikulas Patocka <mpatocka@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 009/111] target: Fix NULL pointer dereference for XCOPY in target_put_sess_cmd
Date: Mon, 23 Jun 2014 10:30:44 +0200
Message-Id: <9c7e073545e0a7139d8071b7f012ea885fe69d4f.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0ed6e189e3f6ac3a25383ed5cc8b0ac24c9b97b7 upstream.

This patch fixes a NULL pointer dereference regression bug that was
introduced with:

commit 1e1110c43b1cda9fe77fc4a04835e460550e6b3c
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Sat May 17 06:49:22 2014 -0400

    target: fix memory leak on XCOPY

Now that target_put_sess_cmd() -> kref_put_spinlock_irqsave() is
called with a valid se_cmd->cmd_kref, a NULL pointer dereference
is triggered because the XCOPY passthrough commands don't have
an associated se_session pointer.

To address this bug, go ahead and checking for a NULL se_sess pointer
within target_put_sess_cmd(), and call se_cmd->se_tfo->release_cmd()
to release the XCOPY's xcopy_pt_cmd memory.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # 3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 179141e03cb3..edacb8d0d6b8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2343,6 +2343,10 @@ static void target_release_cmd_kref(struct kref *kref)
  */
 int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
+	if (!se_sess) {
+		se_cmd->se_tfo->release_cmd(se_cmd);
+		return 1;
+	}
 	return kref_put_spinlock_irqsave(&se_cmd->cmd_kref, target_release_cmd_kref,
 			&se_sess->sess_cmd_lock);
 }
-- 
2.0.0

