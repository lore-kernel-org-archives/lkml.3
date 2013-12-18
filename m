Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3LRGol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:44:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29112 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3LRGoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:44:39 -0500
From: Vaughan Cao <vaughan.cao@oracle.com>
To: michaelc@cs.wisc.edu
Cc: James.Bottomley@suse.de, vaughan.cao@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iscsi: conn error (1020) each time iscsi session logout
Date: Wed, 18 Dec 2013 14:47:01 +0800
Message-Id: <1387349221-18501-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do a normal login/logout process to iscsi server. iscsiadm report success,
but we always see the following error just before conn shutdown in dmesg.

Oct 15 05:30:09 vmhodtest019 iscsid: Connection1:0 to [target:
iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
10.182.32.162,3260] through [iface: default] is operational now
Oct 15 05:30:42 vmhodtest019 kernel:  connection1:0: detected conn error
(1020)
Oct 15 05:30:42 vmhodtest019 iscsid: Connection1:0 to [target:
iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
10.182.32.162,3260] through [iface: default] is shutdown.

It's because iscsi_tcp module evaluates socket state in data_ready() callback,
 and that detect the socket close. However, this socket close on target peer 
is in response to the logout request from initiator. So this is not an error 
that should be reported out. I quiesce it by checking session state and err 
value accordingly.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 415f2c0..84171ef 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1360,6 +1360,12 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
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

