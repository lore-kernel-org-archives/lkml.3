Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab3D2TVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:21:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab3D2TDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/34] rose: fix info leak via msg_name in rose_recvmsg()
Date: Mon, 29 Apr 2013 12:02:22 -0700
Message-Id: <20130429184702.609591835@linuxfoundation.org>
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

[ Upstream commit 4a184233f21645cf0b719366210ed445d1024d72 ]

The code in rose_recvmsg() does not initialize all of the members of
struct sockaddr_rose/full_sockaddr_rose when filling the sockaddr info.
Nor does it initialize the padding bytes of the structure inserted by
the compiler for alignment. This will lead to leaking uninitialized
kernel stack bytes in net/socket.c.

Fix the issue by initializing the memory used for sockaddr info with
memset(0).

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *io
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;


