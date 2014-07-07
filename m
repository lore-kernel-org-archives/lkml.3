Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaGGXzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:55:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaGGXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Lukasz Rymanowski <lukasz.rymanowski@tieto.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.10 23/53] Bluetooth: Fix locking of hdev when calling into SMP code
Date: Mon,  7 Jul 2014 16:58:08 -0700
Message-Id: <20140707235829.994330480@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit c73f94b8c093a615ce80eabbde0ac6eb9abfe31a upstream.

The SMP code expects hdev to be unlocked since e.g. crypto functions
will try to (re)lock it. Therefore, we need to release the lock before
calling into smp.c from mgmt.c. Without this we risk a deadlock whenever
the smp_user_confirm_reply() function is called.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Lukasz Rymanowski <lukasz.rymanowski@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2333,8 +2333,13 @@ static int user_pairing_resp(struct sock
 	}
 
 	if (addr->type == BDADDR_LE_PUBLIC || addr->type == BDADDR_LE_RANDOM) {
-		/* Continue with pairing via SMP */
+		/* Continue with pairing via SMP. The hdev lock must be
+		 * released as SMP may try to recquire it for crypto
+		 * purposes.
+		 */
+		hci_dev_unlock(hdev);
 		err = smp_user_confirm_reply(conn, mgmt_op, passkey);
+		hci_dev_lock(hdev);
 
 		if (!err)
 			err = cmd_complete(sk, hdev->id, mgmt_op,


