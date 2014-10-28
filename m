Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaJ1HOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:14:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaJ1Doe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.16 068/127] Bluetooth: Fix setting correct security level when initiating SMP
Date: Tue, 28 Oct 2014 11:35:03 +0800
Message-Id: <20141028033423.822437513@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 5eb596f55cacc2389554a8d7572d90d5e9d4269d upstream.

We can only determine the final security level when both pairing request
and response have been exchanged. When initiating pairing the starting
target security level is set to MEDIUM unless explicitly specified to be
HIGH, so that we can still perform pairing even if the remote doesn't
have MITM capabilities. However, once we've received the pairing
response we should re-consult the remote and local IO capabilities and
upgrade the target security level if necessary.

Without this patch the resulting Long Term Key will occasionally be
reported to be unauthenticated when it in reality is an authenticated
one.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -432,8 +432,11 @@ static int tk_request(struct l2cap_conn
 	}
 
 	/* Not Just Works/Confirm results in MITM Authentication */
-	if (method != JUST_CFM)
+	if (method != JUST_CFM) {
 		set_bit(SMP_FLAG_MITM_AUTH, &smp->flags);
+		if (hcon->pending_sec_level < BT_SECURITY_HIGH)
+			hcon->pending_sec_level = BT_SECURITY_HIGH;
+	}
 
 	/* If both devices have Keyoard-Display I/O, the master
 	 * Confirms and the slave Enters the passkey.


