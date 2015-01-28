Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbbA2Kpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:45:42 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375AbbA2I7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Simon Horman <horms@verge.net.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 165/176] ipvs: uninitialized data with IP_VS_IPV6
Date: Wed, 28 Jan 2015 15:29:55 +0100
Message-Id: <40d4cb9082b333d247c1ebff9bb1bcf84b137f53.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3b05ac3824ed9648c0d9c02d51d9b54e4e7e874f upstream.

The app_tcp_pkt_out() function expects "*diff" to be set and ends up
using uninitialized data if CONFIG_IP_VS_IPV6 is turned on.

The same issue is there in app_tcp_pkt_in().  Thanks to Julian Anastasov
for noticing that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 77c173282f38..4a662f15eaee 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -183,6 +183,8 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	struct nf_conn *ct;
 	struct net *net;
 
+	*diff = 0;
+
 #ifdef CONFIG_IP_VS_IPV6
 	/* This application helper doesn't work with IPv6 yet,
 	 * so turn this into a no-op for IPv6 packets
@@ -191,8 +193,6 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 #endif
 
-	*diff = 0;
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
@@ -321,6 +321,9 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	struct ip_vs_conn *n_cp;
 	struct net *net;
 
+	/* no diff required for incoming packets */
+	*diff = 0;
+
 #ifdef CONFIG_IP_VS_IPV6
 	/* This application helper doesn't work with IPv6 yet,
 	 * so turn this into a no-op for IPv6 packets
@@ -329,9 +332,6 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 #endif
 
-	/* no diff required for incoming packets */
-	*diff = 0;
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
-- 
2.2.2

