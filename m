Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030629AbaGCJZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030597AbaGCJZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Tore Morken <jantore@morken.priv.no>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 196/198] netfilter: ipt_ULOG: fix info leaks
Date: Thu,  3 Jul 2014 10:20:39 +0100
Message-Id: <1404379241-8590-197-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 278f2b3e2af5f32ea1afe34fa12a2518153e6e49 upstream.

The ulog messages leak heap bytes by the means of padding bytes and
incompletely filled string arrays. Fix those by memset(0)'ing the
whole struct before filling it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jan Tore Morken <jantore@morken.priv.no>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

