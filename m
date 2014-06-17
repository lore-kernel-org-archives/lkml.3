Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966990AbaFQWg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:36:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966209AbaFQVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 203/212] iser-target: Add missing target_put_sess_cmd for ImmedateData failure
Date: Tue, 17 Jun 2014 14:44:57 -0700
Message-Id: <1403041506-13646-204-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 0169850..8ed268d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1095,6 +1095,8 @@ sequence_cmd:
 
 	if (!rc && dump_payload == false && unsol_data)
 		iscsit_set_unsoliticed_dataout(cmd);
+	else if (dump_payload && imm_data)
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 
 	return 0;
 }
-- 
1.9.1

