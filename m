Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3BSRp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:45:57 -0500
Received: from mout.gmx.net ([212.227.15.19]:49552 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207Ab3BSRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:45:53 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+rVkZxuuWrut0/e9r0v7JUy9BnwWcjkWtHqQoqoh
	CKXZorM/19nHBg
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Ahn <syahn@gctsemi.com>,
        Macpaul Lin <macpaul.from.taiwan@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/3] staging/gdm72xx: Remove duplicated code in gdm_qos.c
Date: Tue, 19 Feb 2013 18:50:20 +0100
Message-Id: <1361296220-10020-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361296220-10020-1-git-send-email-peterhuewe@gmx.de>
References: <1361296220-10020-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first branch of the if statement is ended with a return thus there
is no need for an else if, and thus we can move the duplicated code to
the top and use it for the other two branches.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/gdm72xx/gdm_qos.c |   42 +++++++++++++++----------------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index d48994b..b795353 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -365,20 +365,24 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
 		send_qos_list(nic, &send_list);
 		return;
-	} else if (subCmdEvt == QOS_ADD) {
-		pos = 6;
-
-		SFID = ((buf[pos++]<<24)&0xff000000);
-		SFID += ((buf[pos++]<<16)&0xff0000);
-		SFID += ((buf[pos++]<<8)&0xff00);
-		SFID += (buf[pos++]);
-
-		index = get_csr(qcb, SFID, 1);
-		if (index == -1) {
-			netdev_err(nic->netdev, "QoS ERROR: csr Update Error\n");
-			return;
-		}
+	}
 
+	/* subCmdEvt == QOS_ADD || subCmdEvt == QOS_CHANG_DEL */
+	pos = 6;
+	SFID = ((buf[pos++]<<24)&0xff000000);
+	SFID += ((buf[pos++]<<16)&0xff0000);
+	SFID += ((buf[pos++]<<8)&0xff00);
+	SFID += (buf[pos++]);
+
+	index = get_csr(qcb, SFID, 1);
+	if (index == -1) {
+		netdev_err(nic->netdev,
+			   "QoS ERROR: csr Update Error / Wrong index (%d) \n",
+			   index);
+		return;
+	}
+
+	if (subCmdEvt == QOS_ADD) {
 		netdev_dbg(nic->netdev, "QOS_ADD SFID = 0x%x, index=%d\n",
 			   SFID, index);
 
@@ -420,18 +424,6 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
 	} else if (subCmdEvt == QOS_CHANGE_DEL) {
-		pos = 6;
-		SFID = ((buf[pos++]<<24)&0xff000000);
-		SFID += ((buf[pos++]<<16)&0xff0000);
-		SFID += ((buf[pos++]<<8)&0xff00);
-		SFID += (buf[pos++]);
-		index = get_csr(qcb, SFID, 1);
-		if (index == -1) {
-			netdev_err(nic->netdev, "QoS ERROR: Wrong index(%d)\n",
-				   index);
-			return;
-		}
-
 		netdev_dbg(nic->netdev, "QOS_CHANGE_DEL SFID = 0x%x, index=%d\n",
 			   SFID, index);
 
-- 
1.7.8.6

