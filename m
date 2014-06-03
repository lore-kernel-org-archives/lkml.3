Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaFCLkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaFCLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/138] Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
Date: Tue,  3 Jun 2014 12:37:31 +0100
Message-Id: <1401795584-22664-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 9eb1fbfa0a737fd4d3a6d12d71c5ea9af622b887 upstream.

Commit 1c2e004183178 introduced an event handler for the encryption key
refresh complete event with the intent of fixing some LE/SMP cases.
However, this event is shared with BR/EDR and there we actually want to
act only on the auth_complete event (which comes after the key refresh).

If we do not do this we may trigger an L2CAP Connect Request too early
and cause the remote side to return a security block error.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bluetooth/hci_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4cc3ee0923c5..b767ed9969c4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2992,6 +2992,12 @@ static void hci_key_refresh_complete_evt(struct hci_dev *hdev,
 	if (!conn)
 		goto unlock;
 
+	/* For BR/EDR the necessary steps are taken through the
+	 * auth_complete event.
+	 */
+	if (conn->type != LE_LINK)
+		goto unlock;
+
 	if (!ev->status)
 		conn->sec_level = conn->pending_sec_level;
 
-- 
1.9.1

