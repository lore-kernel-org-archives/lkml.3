Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaLOT2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:28:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaLOT2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:28:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kozlov <xeb@mail.ru>, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 33/96] pptp: fix stack info leak in pptp_getname()
Date: Mon, 15 Dec 2014 11:25:53 -0800
Message-Id: <1418671616-25482-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ppp/pptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 1aff970..1dc628f 100644
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
1.9.1

