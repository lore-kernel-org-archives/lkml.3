Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3D2THx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:07:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977Ab3D2TDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/30] ax25: fix info leak via msg_name in ax25_recvmsg()
Date: Mon, 29 Apr 2013 12:02:42 -0700
Message-Id: <20130429184357.353789210@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184355.299556377@linuxfoundation.org>
References: <20130429184355.299556377@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit ef3313e84acbf349caecae942ab3ab731471f1a1 ]

When msg_namelen is non-zero the sockaddr info gets filled out, as
requested, but the code fails to initialize the padding bytes of struct
sockaddr_ax25 inserted by the compiler for alignment. Additionally the
msg_namelen value is updated to sizeof(struct full_sockaddr_ax25) but is
not always filled up to this size.

Both issues lead to the fact that the code will leak uninitialized
kernel stack bytes in net/socket.c.

Fix both issues by initializing the memory with memset(0).

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1641,6 +1641,7 @@ static int ax25_recvmsg(struct kiocb *io
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
 
+		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
 				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;


