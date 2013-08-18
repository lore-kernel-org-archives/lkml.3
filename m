Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3HRXwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:52:11 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:32891 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3HRXwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:52:08 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 1/4] iscsi-target: Fix iscsit_transport reference leak during NP thread reset
Date: Sun, 18 Aug 2013 23:36:22 +0000
Message-Id: <1376868985-23190-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
References: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in __iscsi_target_login_thread() where an explicit
network portal thread reset ends up leaking the iscsit_transport module
reference, along with the associated iscsi_conn allocation.

This manifests itself with iser-target where a NP reset causes the extra
iscsit_transport reference to be taken in iscsit_conn_set_transport()
during the reset, which prevents the ib_isert module from being unloaded
after the NP thread shutdown has finished.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 0e85238..4c17f83 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1171,12 +1171,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
 			spin_unlock_bh(&np->np_thread_lock);
 			complete(&np->np_restart_comp);
-			if (ret == -ENODEV) {
-				iscsit_put_transport(conn->conn_transport);
-				kfree(conn);
-				conn = NULL;
+			iscsit_put_transport(conn->conn_transport);
+			kfree(conn);
+			conn = NULL;
+			if (ret == -ENODEV)
 				goto out;
-			}
 			/* Get another socket */
 			return 1;
 		}
-- 
1.7.2.5

