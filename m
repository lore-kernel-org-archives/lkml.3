Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3ILSUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:20:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab3ILSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 03/16] iscsi-target: Fix iscsit_transport reference leak during NP thread reset
Date: Thu, 12 Sep 2013 11:14:55 -0700
Message-Id: <20130912181156.582564146@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit c9a03c12464c851e691e8d5b6c9deba779c512e0 upstream.

This patch fixes a bug in __iscsi_target_login_thread() where an explicit
network portal thread reset ends up leaking the iscsit_transport module
reference, along with the associated iscsi_conn allocation.

This manifests itself with iser-target where a NP reset causes the extra
iscsit_transport reference to be taken in iscsit_conn_set_transport()
during the reset, which prevents the ib_isert module from being unloaded
after the NP thread shutdown has finished.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1163,12 +1163,11 @@ static int __iscsi_target_login_thread(s
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


