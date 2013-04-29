Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3D2Ta2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:30:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab3D2TDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/34] caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
Date: Mon, 29 Apr 2013 12:02:16 -0700
Message-Id: <20130429184701.956588515@linuxfoundation.org>
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

[ Upstream commit 2d6fbfe733f35c6b355c216644e08e149c61b271 ]

The current code does not fill the msg_name member in case it is set.
It also does not set the msg_namelen member to 0 and therefore makes
net/socket.c leak the local, uninitialized sockaddr_storage variable
to userland -- 128 bytes of kernel stack memory.

Fix that by simply setting msg_namelen to 0 as obviously nobody cared
about caif_seqpkt_recvmsg() not filling the msg_name in case it was
set.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/caif_socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -287,6 +287,8 @@ static int caif_seqpkt_recvmsg(struct ki
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
+	m->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;


