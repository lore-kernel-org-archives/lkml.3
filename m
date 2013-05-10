Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3EJOtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:49:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56925 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab3EJOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Mathias Krause" <minipli@googlemail.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.646229936@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [107/118] rose: fix info leak via msg_name in rose_recvmsg()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rose/af_rose.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1258,6 +1258,7 @@ static int rose_recvmsg(struct kiocb *io
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;

