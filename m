Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaJ1Djx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaJ1Djt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.17 100/146] Bluetooth: Fix incorrect LE CoC PDU length restriction based on HCI MTU
Date: Tue, 28 Oct 2014 11:34:02 +0800
Message-Id: <20141028033347.809346554@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 72c6fb915ff2d30ae14053edee4f0d30019bad76 upstream.

The l2cap_create_le_flowctl_pdu() function that l2cap_segment_le_sdu()
calls is perfectly capable of doing packet fragmentation if given bigger
PDUs than the HCI buffers allow. Forcing the PDU length based on the HCI
MTU (conn->mtu) would therefore needlessly strict operation on hardware
with limited LE buffers (e.g. both Intel and Broadcom seem to have this
set to just 27 bytes).

This patch removes the restriction and makes it possible to send PDUs of
the full length that the remote MPS value allows.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2418,12 +2418,8 @@ static int l2cap_segment_le_sdu(struct l
 
 	BT_DBG("chan %p, msg %p, len %zu", chan, msg, len);
 
-	pdu_len = chan->conn->mtu - L2CAP_HDR_SIZE;
-
-	pdu_len = min_t(size_t, pdu_len, chan->remote_mps);
-
 	sdu_len = len;
-	pdu_len -= L2CAP_SDULEN_SIZE;
+	pdu_len = chan->remote_mps - L2CAP_SDULEN_SIZE;
 
 	while (len > 0) {
 		if (len <= pdu_len)


