Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaFDXXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaFDXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 180/228] target: fix memory leak on XCOPY
Date: Wed,  4 Jun 2014 16:23:29 -0700
Message-Id: <20140604232353.793982025@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1102,6 +1102,7 @@ void transport_init_se_cmd(
 	init_completion(&cmd->cmd_wait_comp);
 	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
+	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
 
 	cmd->se_tfo = tfo;
@@ -2292,7 +2293,6 @@ int target_get_sess_cmd(struct se_sessio
 	unsigned long flags;
 	int ret = 0;
 
-	kref_init(&se_cmd->cmd_kref);
 	/*
 	 * Add a second kref if the fabric caller is expecting to handle
 	 * fabric acknowledgement that requires two target_put_sess_cmd()


