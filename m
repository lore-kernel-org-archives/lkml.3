Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaGVWYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:24:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44534 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 098/116] Bluetooth: Fix SSP acceptor just-works confirmation without MITM
Date: Tue, 22 Jul 2014 15:21:49 -0700
Message-Id: <1406067727-19683-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit ba15a58b179ed76a7e887177f2b06de12c58ec8f upstream.

>From the Bluetooth Core Specification 4.1 page 1958:

"if both devices have set the Authentication_Requirements parameter to
one of the MITM Protection Not Required options, authentication stage 1
shall function as if both devices set their IO capabilities to
DisplayOnly (e.g., Numeric comparison with automatic confirmation on
both devices)"

So far our implementation has done user confirmation for all just-works
cases regardless of the MITM requirements, however following the
specification to the word means that we should not be doing confirmation
when neither side has the MITM flag set.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_event.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ba6f399..4d9e4b0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3573,8 +3573,11 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 
 		/* If we're not the initiators request authorization to
 		 * proceed from user space (mgmt_user_confirm with
-		 * confirm_hint set to 1). */
-		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->flags)) {
+		 * confirm_hint set to 1). The exception is if neither
+		 * side had MITM in which case we do auto-accept.
+		 */
+		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->flags) &&
+		    (loc_mitm || rem_mitm)) {
 			BT_DBG("Confirming auto-accept as acceptor");
 			confirm_hint = 1;
 			goto confirm;
-- 
1.9.1

