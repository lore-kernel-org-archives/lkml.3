Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab3D2ToQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:44:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab3D2TCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/42] Bluetooth: SCO - Fix missing msg_namelen update in sco_sock_recvmsg()
Date: Mon, 29 Apr 2013 12:01:51 -0700
Message-Id: <20130429184753.448369555@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit c8c499175f7d295ef867335bceb9a76a2c3cdc38 ]

If the socket is in state BT_CONNECT2 and BT_SK_DEFER_SETUP is set in
the flags, sco_sock_recvmsg() returns early with 0 without updating the
possibly set msg_namelen member. This, in turn, leads to a 128 byte
kernel stack leak in net/socket.c.

Fix this by updating msg_namelen in this case. For all other cases it
will be handled in bt_sock_recvmsg().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -667,6 +667,7 @@ static int sco_sock_recvmsg(struct kiocb
 	    test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hci_conn_accept(pi->conn->hcon, 0);
 		sk->sk_state = BT_CONFIG;
+		msg->msg_namelen = 0;
 
 		release_sock(sk);
 		return 0;


