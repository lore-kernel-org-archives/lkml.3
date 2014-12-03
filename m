Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaLCLar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:30:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaLCL1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:48 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/101] pptp: fix stack info leak in pptp_getname()
Date: Wed,  3 Dec 2014 12:26:56 +0100
Message-Id: <416b05bc9db9b9cd48418391538478a438e762b3.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a5f6fc28d6e6cc379c6839f21820e62262419584 ]

pptp_getname() only partially initializes the stack variable sa,
particularly only fills the pptp part of the sa_addr union. The code
thereby discloses 16 bytes of kernel stack memory via getsockname().

Fix this by memset(0)'ing the union before.

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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

