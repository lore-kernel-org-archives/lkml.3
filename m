Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbaICWP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:15:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbaICWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.14 67/88] mei: nfc: fix memory leak in error path
Date: Wed,  3 Sep 2014 15:05:41 -0700
Message-Id: <20140903220517.965288933@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8e8248b1369c97c7bb6f8bcaee1f05deeabab8ef upstream.

NFC will leak buffer if send failed.
Use single exit point that does the freeing

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/nfc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -342,9 +342,10 @@ static int mei_nfc_send(struct mei_cl_de
 	ndev = (struct mei_nfc_dev *) cldev->priv_data;
 	dev = ndev->cl->dev;
 
+	err = -ENOMEM;
 	mei_buf = kzalloc(length + MEI_NFC_HEADER_SIZE, GFP_KERNEL);
 	if (!mei_buf)
-		return -ENOMEM;
+		goto out;
 
 	hdr = (struct mei_nfc_hci_hdr *) mei_buf;
 	hdr->cmd = MEI_NFC_CMD_HCI_SEND;
@@ -354,12 +355,9 @@ static int mei_nfc_send(struct mei_cl_de
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
@@ -368,7 +366,8 @@ static int mei_nfc_send(struct mei_cl_de
 	} else {
 		ndev->req_id++;
 	}
-
+out:
+	kfree(mei_buf);
 	return err;
 }
 


