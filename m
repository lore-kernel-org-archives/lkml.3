Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967340AbaFQVyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:54:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967281AbaFQVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 140/212] target: fix memory leak on XCOPY
Date: Tue, 17 Jun 2014 14:43:54 -0700
Message-Id: <1403041506-13646-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1e1110c43b1cda9fe77fc4a04835e460550e6b3c upstream.

On each processed XCOPY command, two "kmalloc-512" memory objects are
leaked. These represent two allocations of struct xcopy_pt_cmd in
target_core_xcopy.c.

The reason for the memory leak is that the cmd_kref field is not
initialized (thus, it is zero because the allocations were done with
kzalloc). When we decrement zero kref in target_put_sess_cmd, the result
is not zero, thus target_release_cmd_kref is not called.

This patch fixes the bug by moving kref initialization from
target_get_sess_cmd to transport_init_se_cmd (this function is called from
target_core_xcopy.c, so it will correctly initialize cmd_kref). It can be
easily verified that all code that calls target_get_sess_cmd also calls
transport_init_se_cmd earlier, thus moving kref_init shouldn't introduce
any new problems.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dee2be1..3ef25bd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1079,6 +1079,7 @@ void transport_init_se_cmd(
 	init_completion(&cmd->cmd_wait_comp);
 	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
+	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
 
 	cmd->se_tfo = tfo;
@@ -2254,7 +2255,6 @@ int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
 	unsigned long flags;
 	int ret = 0;
 
-	kref_init(&se_cmd->cmd_kref);
 	/*
 	 * Add a second kref if the fabric caller is expecting to handle
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
-- 
1.9.1

