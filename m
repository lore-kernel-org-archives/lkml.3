Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840AbaKNSfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:35:13 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:39613 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964931AbaKNSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:35:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNADJKZlRXQzQ2/2dsb2JhbABbgw6BLrlDBQF1mhWBHRcBAQEBAX2EMC8jgRo3iEUBwXKQJyyGPopkHYQ1BZ5MjRKJaIFHAW6BRzwwgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] Bluetooth: hidp: replace kzalloc/copy_from_user by memdup_user
Date: Fri, 14 Nov 2014 19:35:05 +0100
Message-Id: <1415990105-28609-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use memdup_user for rd_data import.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/bluetooth/hidp/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 1b7d605..cc25d0b 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -736,14 +736,10 @@ static int hidp_setup_hid(struct hidp_session *session,
 	struct hid_device *hid;
 	int err;
 
-	session->rd_data = kzalloc(req->rd_size, GFP_KERNEL);
-	if (!session->rd_data)
-		return -ENOMEM;
+	session->rd_data = memdup_user(req->rd_data, req->rd_size);
+	if (IS_ERR(session->rd_data))
+		return PTR_ERR(session->rd_data);
 
-	if (copy_from_user(session->rd_data, req->rd_data, req->rd_size)) {
-		err = -EFAULT;
-		goto fault;
-	}
 	session->rd_size = req->rd_size;
 
 	hid = hid_allocate_device();
-- 
1.9.3

