Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaLEXwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:52:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaLEWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kozlov <xeb@mail.ru>, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 025/122] pptp: fix stack info leak in pptp_getname()
Date: Fri,  5 Dec 2014 14:43:19 -0800
Message-Id: <20141205223309.191620061@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit a5f6fc28d6e6cc379c6839f21820e62262419584 ]

pptp_getname() only partially initializes the stack variable sa,
particularly only fills the pptp part of the sa_addr union. The code
thereby discloses 16 bytes of kernel stack memory via getsockname().

Fix this by memset(0)'ing the union before.

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pptp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -506,7 +506,9 @@ static int pptp_getname(struct socket *s
 	int len = sizeof(struct sockaddr_pppox);
 	struct sockaddr_pppox sp;
 
-	sp.sa_family	  = AF_PPPOX;
+	memset(&sp.sa_addr, 0, sizeof(sp.sa_addr));
+
+	sp.sa_family    = AF_PPPOX;
 	sp.sa_protocol  = PX_PROTO_PPTP;
 	sp.sa_addr.pptp = pppox_sk(sock->sk)->proto.pptp.src_addr;
 


