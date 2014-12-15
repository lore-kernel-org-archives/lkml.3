Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaLOOdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:33:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39033 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaLOO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Herbert <therbert@google.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 159/168] gre: Set inner mac header in gro complete
Date: Mon, 15 Dec 2014 14:26:53 +0000
Message-Id: <1418653622-21105-160-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

commit 6fb2a756739aa507c1fd5b8126f0bfc2f070dc46 upstream.

Set the inner mac header to point to the GRE payload when
doing GRO. This is needed if we proceed to send the packet
through GRE GSO which now uses the inner mac header instead
of inner network header to determine the length of encapsulation
headers.

Fixes: 14051f0452a2 ("gre: Use inner mac length when computing tunnel length")
Reported-by: Wolfgang Walter <linux@stwm.de>
Signed-off-by: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/gre_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 32041ecbeafb..4ae6b52751e9 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -279,6 +279,9 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 		err = ptype->callbacks.gro_complete(skb, nhoff + grehlen);
 
 	rcu_read_unlock();
+
+	skb_set_inner_mac_header(skb, nhoff + grehlen);
+
 	return err;
 }
 
-- 
2.1.3

