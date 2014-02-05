Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaBEUhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:37:41 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48382 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaBEUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:48 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 129/213] Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
Date: Wed, 5 Feb 2014 15:01:24 -0500
Message-ID: <1391630568-49251-130-git-send-email-paul.gortmaker@windriver.com>
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

commit e15ca9a0ef9a86f0477530b0f44a725d67f889ee upstream.

The HCI code fails to initialize the two padding bytes of struct
hci_ufilter before copying it to userland -- that for leaking two
bytes kernel stack. Add an explicit memset(0) before filling the
structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bluetooth/hci_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 38f08f6b86f6..e5d788faf03b 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -583,6 +583,7 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname, char
 		{
 			struct hci_filter *f = &hci_pi(sk)->filter;
 
+			memset(&uf, 0, sizeof(uf));
 			uf.type_mask = f->type_mask;
 			uf.opcode    = f->opcode;
 			uf.event_mask[0] = *((u32 *) f->event_mask + 0);
-- 
1.8.5.2

