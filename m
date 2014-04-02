Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaDBUWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:22:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42845 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758907AbaDBUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Bogdano Arendartchuk <barendartchuk@suse.com>,
        Simon Horman <horms@verge.net.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 23/40] ipvs: fix AF assignment in ip_vs_conn_new()
Date: Wed,  2 Apr 2014 22:13:09 +0200
Message-Id: <1b0b41d28f3b2e2107f38690c5a2db7e76feb7a1.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2a971354e74f3837d14b9c8d7f7983b0c9c330e4 upstream.

If a fwmark is passed to ip_vs_conn_new(), it is passed in
vaddr, not daddr. Therefore we should set AF to AF_UNSPEC in
vaddr assignment (like we do in ip_vs_ct_in_get()), otherwise we
may copy only first 4 bytes of an IPv6 address into cp->daddr.

Signed-off-by: Bogdano Arendartchuk <barendartchuk@suse.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/ipvs/ip_vs_conn.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 4c8e5c0aa1ab..d585626d7676 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -871,11 +871,11 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p,
 	cp->protocol	   = p->protocol;
 	ip_vs_addr_set(p->af, &cp->caddr, p->caddr);
 	cp->cport	   = p->cport;
-	ip_vs_addr_set(p->af, &cp->vaddr, p->vaddr);
-	cp->vport	   = p->vport;
-	/* proto should only be IPPROTO_IP if d_addr is a fwmark */
+	/* proto should only be IPPROTO_IP if p->vaddr is a fwmark */
 	ip_vs_addr_set(p->protocol == IPPROTO_IP ? AF_UNSPEC : p->af,
-		       &cp->daddr, daddr);
+		       &cp->vaddr, p->vaddr);
+	cp->vport	   = p->vport;
+	ip_vs_addr_set(p->af, &cp->daddr, daddr);
 	cp->dport          = dport;
 	cp->flags	   = flags;
 	cp->fwmark         = fwmark;
-- 
1.9.1

