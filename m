Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaF1Rw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:52:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaF1RwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 085/139] Bluetooth: Fix requiring SMP MITM for outgoing connections
Date: Sat, 28 Jun 2014 10:47:26 -0700
Message-Id: <20140628174609.318609060@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 79897d2097a629179e142014ecd3cdce6eac7f0e upstream.

Due to recent changes to the way that the MITM requirement is set for
outgoing pairing attempts we can no longer rely on the hcon->auth_type
variable (which is actually good since it was formed from BR/EDR
concepts that don't really exist for SMP).

To match the logic that BR/EDR now uses simply rely on the local IO
capability and/or needed security level to set the MITM requirement for
outgoing pairing requests.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -908,10 +908,11 @@ int smp_conn_security(struct hci_conn *h
 
 	authreq = seclevel_to_authreq(sec_level);
 
-	/* hcon->auth_type is set by pair_device in mgmt.c. If the MITM
-	 * flag is set we should also set it for the SMP request.
+	/* Require MITM if IO Capability allows or the security level
+	 * requires it.
 	 */
-	if ((hcon->auth_type & 0x01))
+	if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
+	    sec_level > BT_SECURITY_MEDIUM)
 		authreq |= SMP_AUTH_MITM;
 
 	if (hcon->link_mode & HCI_LM_MASTER) {


