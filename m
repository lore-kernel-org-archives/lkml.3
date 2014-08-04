Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaHDRLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:11:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56499 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Mathias Krause" <minipli@googlemail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.630009472@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 67/94] netfilter: ipt_ULOG: fix info leaks
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 278f2b3e2af5f32ea1afe34fa12a2518153e6e49 upstream.

The ulog messages leak heap bytes by the means of padding bytes and
incompletely filled string arrays. Fix those by memset(0)'ing the
whole struct before filling it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/netfilter/ipt_ULOG.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -202,6 +202,7 @@ static void ipt_ulog_packet(unsigned int
 	ub->qlen++;
 
 	pm = NLMSG_DATA(nlh);
+	memset(pm, 0, sizeof(*pm));
 
 	/* We might not have a timestamp, get one */
 	if (skb->tstamp.tv64 == 0)
@@ -218,8 +219,6 @@ static void ipt_ulog_packet(unsigned int
 		strncpy(pm->prefix, prefix, sizeof(pm->prefix));
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
-	else
-		*(pm->prefix) = '\0';
 
 	if (in && in->hard_header_len > 0 &&
 	    skb->mac_header != skb->network_header &&
@@ -231,13 +230,9 @@ static void ipt_ulog_packet(unsigned int
 
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

