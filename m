Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaFWIoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:44:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55587 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/111] iser-target: Add missing target_put_sess_cmd for ImmedateData failure
Date: Mon, 23 Jun 2014 10:31:32 +0200
Message-Id: <a12e3e7bfc80023f8ef4ab17eebeb0e344494036.1403512281.git.jslaby@suse.cz>
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

commit 6cc44a6fb46e1ecc1c28125aa8fa34d317aa9ea7 upstream.

This patch addresses a bug where an early exception for SCSI WRITE
with ImmediateData=Yes was missing the target_put_sess_cmd() call
to drop the extra se_cmd->cmd_kref reference obtained during the
normal iscsit_setup_scsi_cmd() codepath execution.

This bug was manifesting itself during session shutdown within
isert_cq_rx_comp_err() where target_wait_for_sess_cmds() would
end up waiting indefinately for the last se_cmd->cmd_kref put to
occur for the failed SCSI WRITE + ImmediateData descriptors.

This fix follows what traditional iscsi-target code already does
for the same failure case within iscsit_get_immediate_data().

Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e6737607a088..8f23786c74e9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1081,6 +1081,8 @@ sequence_cmd:
 
 	if (!rc && dump_payload == false && unsol_data)
 		iscsit_set_unsoliticed_dataout(cmd);
+	else if (dump_payload && imm_data)
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 
 	return 0;
 }
-- 
2.0.0

