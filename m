Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbbA1BbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:31:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118AbbA1B2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 3.18 55/61] ipvs: uninitialized data with IP_VS_IPV6
Date: Tue, 27 Jan 2015 17:27:07 -0800
Message-Id: <20150128012642.936354417@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3b05ac3824ed9648c0d9c02d51d9b54e4e7e874f upstream.

The app_tcp_pkt_out() function expects "*diff" to be set and ends up
using uninitialized data if CONFIG_IP_VS_IPV6 is turned on.

The same issue is there in app_tcp_pkt_in().  Thanks to Julian Anastasov
for noticing that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_ftp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -183,6 +183,8 @@ static int ip_vs_ftp_out(struct ip_vs_ap
 	struct nf_conn *ct;
 	struct net *net;
 
+	*diff = 0;
+
 #ifdef CONFIG_IP_VS_IPV6
 	/* This application helper doesn't work with IPv6 yet,
 	 * so turn this into a no-op for IPv6 packets
@@ -191,8 +193,6 @@ static int ip_vs_ftp_out(struct ip_vs_ap
 		return 1;
 #endif
 
-	*diff = 0;
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
@@ -322,6 +322,9 @@ static int ip_vs_ftp_in(struct ip_vs_app
 	struct ip_vs_conn *n_cp;
 	struct net *net;
 
+	/* no diff required for incoming packets */
+	*diff = 0;
+
 #ifdef CONFIG_IP_VS_IPV6
 	/* This application helper doesn't work with IPv6 yet,
 	 * so turn this into a no-op for IPv6 packets
@@ -330,9 +333,6 @@ static int ip_vs_ftp_in(struct ip_vs_app
 		return 1;
 #endif
 
-	/* no diff required for incoming packets */
-	*diff = 0;
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;


