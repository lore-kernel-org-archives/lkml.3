Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaF3MtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:49:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbaF3Mag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 179/181] netfilter: ipt_ULOG: fix info leaks
Date: Mon, 30 Jun 2014 13:53:20 +0200
Message-Id: <4b15d5d1219f1ef752f55b65536499ebb80760ff.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 278f2b3e2af5f32ea1afe34fa12a2518153e6e49 upstream.

The ulog messages leak heap bytes by the means of padding bytes and
incompletely filled string arrays. Fix those by memset(0)'ing the
whole struct before filling it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/netfilter/ipt_ULOG.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index cbc22158af49..9cb993cd224b 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -220,6 +220,7 @@ static void ipt_ulog_packet(struct net *net,
 	ub->qlen++;
 
 	pm = nlmsg_data(nlh);
+	memset(pm, 0, sizeof(*pm));
 
 	/* We might not have a timestamp, get one */
 	if (skb->tstamp.tv64 == 0)
@@ -238,8 +239,6 @@ static void ipt_ulog_packet(struct net *net,
 	}
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
-	else
-		*(pm->prefix) = '\0';
 
 	if (in && in->hard_header_len > 0 &&
 	    skb->mac_header != skb->network_header &&
@@ -251,13 +250,9 @@ static void ipt_ulog_packet(struct net *net,
 
 	if (in)
 		strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
-	else
-		pm->indev_name[0] = '\0';
 
 	if (out)
 		strncpy(pm->outdev_name, out->name, sizeof(pm->outdev_name));
-	else
-		pm->outdev_name[0] = '\0';
 
 	/* copy_len <= skb->len, so can't fail. */
 	if (skb_copy_bits(skb, 0, pm->payload, copy_len) < 0)
-- 
2.0.0

