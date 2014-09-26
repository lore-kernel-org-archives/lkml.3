Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaIZJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbaIZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/142] mei: nfc: fix memory leak in error path
Date: Fri, 26 Sep 2014 11:43:45 +0200
Message-Id: <a7678826725fbe9831db672b4caa47aba4137ffc.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8e8248b1369c97c7bb6f8bcaee1f05deeabab8ef upstream.

NFC will leak buffer if send failed.
Use single exit point that does the freeing

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/nfc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 994ca4aff1a3..4b7ea3fb143c 100644
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
2.1.0

