Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbaFIWvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:51:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319AbaFIWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 35/40] iser-target: Add missing target_put_sess_cmd for ImmedateData failure
Date: Mon,  9 Jun 2014 15:49:06 -0700
Message-Id: <20140609224840.355227016@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -965,6 +965,8 @@ sequence_cmd:
 
 	if (!rc && dump_payload == false && unsol_data)
 		iscsit_set_unsoliticed_dataout(cmd);
+	else if (dump_payload && imm_data)
+		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 
 	return 0;
 }


