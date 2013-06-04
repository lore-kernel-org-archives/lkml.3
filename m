Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3FDWnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:40 -0400
Received: from 1wt.eu ([62.212.114.60]:35737 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab3FDWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:28 -0400
Message-Id: <20130604172134.419170494@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 099/184] Bluetooth: RFCOMM - Fix info leak via getsockname()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 9344a972961d1a6d2c04d9008b13617bcb6ec2ef ]

The RFCOMM code fails to initialize the trailing padding byte of struct
sockaddr_rc added for alignment. It that for leaks one byte kernel stack
via the getsockname() syscall. Add an explicit memset(0) before filling
the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bluetooth/rfcomm/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 1ae3f80..c47b7c4 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -543,6 +543,7 @@ static int rfcomm_sock_getname(struct socket *sock, struct sockaddr *addr, int *
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	memset(sa, 0, sizeof(*sa));
 	sa->rc_family  = AF_BLUETOOTH;
 	sa->rc_channel = rfcomm_pi(sk)->channel;
 	if (peer)
-- 
1.7.12.2.21.g234cd45.dirty



