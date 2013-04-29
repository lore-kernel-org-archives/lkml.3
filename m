Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab3D2TDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab3D2TDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/34] Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
Date: Mon, 29 Apr 2013 12:02:15 -0700
Message-Id: <20130429184701.844242994@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit e11e0455c0d7d3d62276a0c55d9dfbc16779d691 ]

If RFCOMM_DEFER_SETUP is set in the flags, rfcomm_sock_recvmsg() returns
early with 0 without updating the possibly set msg_namelen member. This,
in turn, leads to a 128 byte kernel stack leak in net/socket.c.

Fix this by updating msg_namelen in this case. For all other cases it
will be handled in bt_sock_stream_recvmsg().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -628,6 +628,7 @@ static int rfcomm_sock_recvmsg(struct ki
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
+		msg->msg_namelen = 0;
 		return 0;
 	}
 


