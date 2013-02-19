Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3BSS6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:58:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416Ab3BSSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 69/81] bridge: Pull ip header into skb->data before looking into ip header.
Date: Tue, 19 Feb 2013 15:49:32 -0300
Message-Id: <1361299784-8830-70-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

commit 6caab7b0544e83e6c160b5e80f5a4a7dd69545c7 upstream.

If lower layer driver leaves the ip header in the skb fragment, it needs to
be first pulled into skb->data before inspecting ip header length or ip version
number.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bridge/br_netfilter.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index e41456b..ab52468 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -256,6 +256,9 @@ static int br_parse_ip_options(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	u32 len;
 
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
 
-- 
1.7.9.5

