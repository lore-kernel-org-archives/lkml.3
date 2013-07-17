Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782Ab3GQXE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:04:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934488Ab3GQW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Oester <kernel@linuxace.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 079/145] netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
Date: Wed, 17 Jul 2013 15:46:51 -0700
Message-Id: <1374101277-7915-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit 409b545ac10d9548929557a75ad86540f59a2c83 upstream.

The clamp-mss-to-pmtu option of the xt_TCPMSS target can cause issues
connecting to websites if there was no MSS option present in the
original SYN packet from the client. In these cases, it may add a
MSS higher than the default specified in RFC879. Fix this by never
setting a value > 536 if no MSS option was specified by the client.

This closes netfilter's bugzilla #662.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_TCPMSS.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 71a266d..4960b66 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -124,6 +124,12 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	skb_put(skb, TCPOLEN_MSS);
 
+	/* RFC 879 states that the default MSS is 536 without specific
+	 * knowledge that the destination host is prepared to accept larger.
+	 * Since no MSS was provided, we MUST NOT set a value > 536.
+	 */
+	newmss = min(newmss, (u16)536);
+
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 
-- 
1.8.1.2

