Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaGGXyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaGGXx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Szymon Janc <szymon.janc@tieto.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 054/122] Bluetooth: Fix SSP acceptor just-works confirmation without MITM
Date: Mon,  7 Jul 2014 16:56:56 -0700
Message-Id: <20140707235735.897136322@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3503,8 +3503,11 @@ static void hci_user_confirm_request_evt
 
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


