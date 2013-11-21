Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3KUJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:16:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41853 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3KUJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:16:53 -0500
From: Vaughan Cao <vaughan.cao@oracle.com>
To: michaelc@cs.wisc.edu
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
Subject: [PATCH] iscsi: quiesce connection error event during logout
Date: Thu, 21 Nov 2013 17:19:07 +0800
Message-Id: <1385025547-1693-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'connectionX:X: detected conn error(1020)' message appear during normal
logout phase because of connection close on target peer.
Quiesce it to avoid confusion.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..0e127d1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1356,6 +1356,12 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 		spin_unlock_bh(&session->lock);
 		return;
 	}
+	/* Target closed the connection in response to logout */
+	if (session->state == ISCSI_STATE_LOGGING_OUT &&
+		err == ISCSI_ERR_TCP_CONN_CLOSE) {
+		spin_unlock_bh(&session->lock);
+		return;
+	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-- 
1.8.3.1

