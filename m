Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaBEUfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:35:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:55199 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbaBEUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 132/213] Bluetooth: L2CAP - Fix info leak via getsockname()
Date: Wed, 5 Feb 2014 15:01:27 -0500
Message-ID: <1391630568-49251-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 792039c73cf176c8e39a6e8beef2c94ff46522ed upstream.

The L2CAP code fails to initialize the l2_bdaddr_type member of struct
sockaddr_l2 and the padding byte added for alignment. It that for leaks
two bytes kernel stack via the getsockname() syscall. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[PG: net/bluetooth/l2cap_sock.c --> net/bluetooth/l2cap.c in .34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/l2cap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 0b6cf87d5eb0..64ccd83d52a2 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1191,6 +1191,7 @@ static int l2cap_sock_getname(struct socket *sock, struct sockaddr *addr, int *l
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	memset(la, 0, sizeof(struct sockaddr_l2));
 	addr->sa_family = AF_BLUETOOTH;
 	*len = sizeof(struct sockaddr_l2);
 
-- 
1.8.5.2

