Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab3D2TWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:22:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700Ab3D2TDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/34] irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
Date: Mon, 29 Apr 2013 12:02:17 -0700
Message-Id: <20130429184702.063056913@linuxfoundation.org>
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

[ Upstream commit 5ae94c0d2f0bed41d6718be743985d61b7f5c47d ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about irda_recvmsg_dgram() not filling the msg_name in case it was
set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/irda/af_irda.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1386,6 +1386,8 @@ static int irda_recvmsg_dgram(struct kio
 
 	IRDA_DEBUG(4, "%s()\n", __func__);
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (!skb)


