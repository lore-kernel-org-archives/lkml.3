Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaLOPU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:20:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaLOO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kozlov <xeb@mail.ru>, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 008/168] pptp: fix stack info leak in pptp_getname()
Date: Mon, 15 Dec 2014 14:24:22 +0000
Message-Id: <1418653622-21105-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit a5f6fc28d6e6cc379c6839f21820e62262419584 upstream.

pptp_getname() only partially initializes the stack variable sa,
particularly only fills the pptp part of the sa_addr union. The code
thereby discloses 16 bytes of kernel stack memory via getsockname().

Fix this by memset(0)'ing the union before.

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ppp/pptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 1aff970be33e..1dc628ffce2b 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -506,7 +506,9 @@ static int pptp_getname(struct socket *sock, struct sockaddr *uaddr,
 	int len = sizeof(struct sockaddr_pppox);
 	struct sockaddr_pppox sp;
 
-	sp.sa_family	  = AF_PPPOX;
+	memset(&sp.sa_addr, 0, sizeof(sp.sa_addr));
+
+	sp.sa_family    = AF_PPPOX;
 	sp.sa_protocol  = PX_PROTO_PPTP;
 	sp.sa_addr.pptp = pppox_sk(sock->sk)->proto.pptp.src_addr;
 
-- 
2.1.3

