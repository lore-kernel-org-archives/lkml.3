Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaIRKP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:15:28 -0400
Received: from mx1.dnsc.at ([62.212.162.144]:37258 "EHLO mx1.dnsc.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbaIRKP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:15:27 -0400
From: Bernhard Thaler <bernhard.thaler@r-it.at>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        davem@davemloft.net
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bernhard Thaler <bernhard.thaler@r-it.at>
Subject: [PATCHv2 1/1] bluetooth: Check for SCO type before setting retransmission effort
Date: Thu, 18 Sep 2014 12:15:21 +0200
Message-Id: <1411035321-10215-1-git-send-email-bernhard.thaler@r-it.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <8B07B86E-19D4-49E2-B471-DAF31C8D4F34@holtmann.org>
References: <8B07B86E-19D4-49E2-B471-DAF31C8D4F34@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCO connection cannot be setup to devices that do not support retransmission.
Patch based on http://permalink.gmane.org/gmane.linux.bluez.kernel/7779 and
adapted for this kernel version.
Code changed to check SCO/eSCO type before setting retransmission effort
and max. latency. The purpose of the patch is to support older devices not
 capable of eSCO.

Tested on Blackberry 655+ headset which does not support retransmission.
Credits go to Alexander Sommerhuber.

Signed-off-by: Bernhard Thaler <bernhard.thaler@r-it.at>
---
 net/bluetooth/hci_conn.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index faff624..f6e3183 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -194,10 +194,18 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 		param = &sco_param_wideband[conn->attempt - 1];
 		break;
 	case SCO_AIRMODE_CVSD:
-		if (conn->attempt > ARRAY_SIZE(sco_param_cvsd))
-			return false;
-		cp.retrans_effort = 0x01;
-		param = &sco_param_cvsd[conn->attempt - 1];
+		if (!lmp_esco_capable(conn->link)) {
+			/* sco_param_cvsd contains SCO in last two elements */
+			if ((conn->attempt + 3) > ARRAY_SIZE(sco_param_cvsd))
+				return false;
+			cp.retrans_effort = 0xff;
+			param = &sco_param_cvsd[(conn->attempt + 2)];
+		} else {
+			if (conn->attempt > ARRAY_SIZE(sco_param_cvsd))
+				return false;
+			cp.retrans_effort = 0x01;
+			param = &sco_param_cvsd[conn->attempt - 1];
+		}
 		break;
 	default:
 		return false;
-- 
1.7.10.4

