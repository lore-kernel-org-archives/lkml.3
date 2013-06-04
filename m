Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3FDXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:01:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35661 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab3FDWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:07 -0400
Message-Id: <20130604172134.377922428@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 098/184] Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit e15ca9a0ef9a86f0477530b0f44a725d67f889ee ]

The HCI code fails to initialize the two padding bytes of struct
hci_ufilter before copying it to userland -- that for leaking two
bytes kernel stack. Add an explicit memset(0) before filling the
structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bluetooth/hci_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 75302a9..45caaaa 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -576,6 +576,7 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname, char
 		{
 			struct hci_filter *f = &hci_pi(sk)->filter;
 
+			memset(&uf, 0, sizeof(uf));
 			uf.type_mask = f->type_mask;
 			uf.opcode    = f->opcode;
 			uf.event_mask[0] = *((u32 *) f->event_mask + 0);
-- 
1.7.12.2.21.g234cd45.dirty



