Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbbANIqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:46:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbbANHZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.18 033/150] Bluetooth: Fix LE connection timeout deadlock
Date: Tue, 13 Jan 2015 23:21:44 -0800
Message-Id: <20150114072057.373877201@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 980ffc0a2cec2c37589cc97993e1ad17252f4f47 upstream.

The le_conn_timeout() may call hci_le_conn_failed() which in turn may
call hci_conn_del(). Trying to use the _sync variant for cancelling the
conn timeout from hci_conn_del() could therefore result in a deadlock.
This patch converts hci_conn_del() to use the non-sync variant so the
deadlock is not possible.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -517,7 +517,7 @@ int hci_conn_del(struct hci_conn *conn)
 		/* Unacked frames */
 		hdev->acl_cnt += conn->sent;
 	} else if (conn->type == LE_LINK) {
-		cancel_delayed_work_sync(&conn->le_conn_timeout);
+		cancel_delayed_work(&conn->le_conn_timeout);
 
 		if (hdev->le_pkts)
 			hdev->le_cnt += conn->sent;


