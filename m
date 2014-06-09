Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936505AbaFIJ3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:29:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936400AbaFIJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 119/146] target: fix memory leak on XCOPY
Date: Mon,  9 Jun 2014 10:50:54 +0200
Message-Id: <864ad8a88891e7b4ffb75c153c3909360f8a8073.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0b0009b5d4db..179141e03cb3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1103,6 +1103,7 @@ void transport_init_se_cmd(
 	init_completion(&cmd->cmd_wait_comp);
 	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
+	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
 
 	cmd->se_tfo = tfo;
@@ -2293,7 +2294,6 @@ int target_get_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd,
 	unsigned long flags;
 	int ret = 0;
 
-	kref_init(&se_cmd->cmd_kref);
 	/*
 	 * Add a second kref if the fabric caller is expecting to handle
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
-- 
1.9.3

