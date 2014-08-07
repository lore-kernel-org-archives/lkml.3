Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaHGIrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:47:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63936 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaHGIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:47:33 -0400
From: A Raghavendra Rao <raghav3276@gmail.com>
X-Google-Original-From: A Raghavendra Rao <arrao@cdac.in>
To: gregkh@linuxfoundation.org, matt@ninezulu.com, vitaly.osipov@gmail.com,
        ztugcesirin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        A Raghavendra Rao <arrao@cdac.in>
Subject: [PATCH] Staging: wlan-ng: fix sparse warning in prism2fw.c
Date: Thu,  7 Aug 2014 14:10:39 +0530
Message-Id: <1407400839-13996-1-git-send-email-arrao@cdac.in>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning :

In file included from drivers/staging/wlan-ng/prism2usb.c:5:0:
drivers/staging/wlan-ng/prism2fw.c: In function
‘read_cardpda.constprop.43’:
drivers/staging/wlan-ng/prism2fw.c:792:1: warning: the frame size of
1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]

The variable to 'struct p80211msg_p2req_readpda' was previously being created
on the stack, which inturn exeeded the frame size limit, resulting in a
sparse warning. This patch alloctes the memory to the structure dynamically
and the operations are left unchanged.

Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
---
 drivers/staging/wlan-ng/prism2fw.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 42c14b0..3f5f7cc 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -764,30 +764,35 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 static int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 {
 	int result = 0;
-	struct p80211msg_p2req_readpda msg;
+	struct p80211msg_p2req_readpda *msg;
+
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
 
 	/* set up the msg */
-	msg.msgcode = DIDmsg_p2req_readpda;
-	msg.msglen = sizeof(msg);
-	strcpy(msg.devname, wlandev->name);
-	msg.pda.did = DIDmsg_p2req_readpda_pda;
-	msg.pda.len = HFA384x_PDA_LEN_MAX;
-	msg.pda.status = P80211ENUM_msgitem_status_no_value;
-	msg.resultcode.did = DIDmsg_p2req_readpda_resultcode;
-	msg.resultcode.len = sizeof(u32);
-	msg.resultcode.status = P80211ENUM_msgitem_status_no_value;
-
-	if (prism2mgmt_readpda(wlandev, &msg) != 0) {
+	msg->msgcode = DIDmsg_p2req_readpda;
+	msg->msglen = sizeof(msg);
+	strcpy(msg->devname, wlandev->name);
+	msg->pda.did = DIDmsg_p2req_readpda_pda;
+	msg->pda.len = HFA384x_PDA_LEN_MAX;
+	msg->pda.status = P80211ENUM_msgitem_status_no_value;
+	msg->resultcode.did = DIDmsg_p2req_readpda_resultcode;
+	msg->resultcode.len = sizeof(u32);
+	msg->resultcode.status = P80211ENUM_msgitem_status_no_value;
+
+	if (prism2mgmt_readpda(wlandev, msg) != 0) {
 		/* prism2mgmt_readpda prints an errno if appropriate */
 		result = -1;
-	} else if (msg.resultcode.data == P80211ENUM_resultcode_success) {
-		memcpy(pda->buf, msg.pda.data, HFA384x_PDA_LEN_MAX);
+	} else if (msg->resultcode.data == P80211ENUM_resultcode_success) {
+		memcpy(pda->buf, msg->pda.data, HFA384x_PDA_LEN_MAX);
 		result = mkpdrlist(pda);
 	} else {
 		/* resultcode must've been something other than success */
 		result = -1;
 	}
 
+	kfree(msg);
 	return result;
 }
 
-- 
1.7.9.5

