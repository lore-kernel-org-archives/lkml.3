Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaI3Vho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaI3Vhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 060/103] mei: nfc: fix memory leak in error path
Date: Tue, 30 Sep 2014 14:31:05 -0700
Message-Id: <1412112708-27356-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8e8248b1369c97c7bb6f8bcaee1f05deeabab8ef upstream.

NFC will leak buffer if send failed.
Use single exit point that does the freeing

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/nfc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 994ca4a..4b7ea3f 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -342,9 +342,10 @@ static int mei_nfc_send(struct mei_cl_device *cldev, u8 *buf, size_t length)
 	ndev = (struct mei_nfc_dev *) cldev->priv_data;
 	dev = ndev->cl->dev;
 
+	err = -ENOMEM;
 	mei_buf = kzalloc(length + MEI_NFC_HEADER_SIZE, GFP_KERNEL);
 	if (!mei_buf)
-		return -ENOMEM;
+		goto out;
 
 	hdr = (struct mei_nfc_hci_hdr *) mei_buf;
 	hdr->cmd = MEI_NFC_CMD_HCI_SEND;
@@ -354,12 +355,9 @@ static int mei_nfc_send(struct mei_cl_device *cldev, u8 *buf, size_t length)
 	hdr->data_size = length;
 
 	memcpy(mei_buf + MEI_NFC_HEADER_SIZE, buf, length);
-
 	err = __mei_cl_send(ndev->cl, mei_buf, length + MEI_NFC_HEADER_SIZE);
 	if (err < 0)
-		return err;
-
-	kfree(mei_buf);
+		goto out;
 
 	if (!wait_event_interruptible_timeout(ndev->send_wq,
 				ndev->recv_req_id == ndev->req_id, HZ)) {
@@ -368,7 +366,8 @@ static int mei_nfc_send(struct mei_cl_device *cldev, u8 *buf, size_t length)
 	} else {
 		ndev->req_id++;
 	}
-
+out:
+	kfree(mei_buf);
 	return err;
 }
 
-- 
1.9.1

