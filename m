Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3EJOs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:48:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56927 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab3EJOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:08 -0400
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
Message-ID: <lsq.1368193181.979111941@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [106/118] netrom: fix info leak via msg_name in nr_recvmsg()
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

[ Upstream commits 3ce5efad47b62c57a4f5c54248347085a750ce0e and
  c802d759623acbd6e1ee9fbdabae89159a513913 ]

In case msg_name is set the sockaddr info gets filled out, as
requested, but the code fails to initialize the padding bytes of
struct sockaddr_ax25 inserted by the compiler for alignment. Also
the sax25_ndigis member does not get assigned, leaking four more
bytes.

Both issues lead to the fact that the code will leak uninitialized
kernel stack bytes in net/socket.c.

Fix both issues by initializing the memory with memset(0).

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netrom/af_netrom.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1178,6 +1178,7 @@ static int nr_recvmsg(struct kiocb *iocb
 	}
 
 	if (sax != NULL) {
+		memset(sax, 0, sizeof(sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);

