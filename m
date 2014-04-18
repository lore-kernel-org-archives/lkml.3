Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaDRJmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:42:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45939 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Nayshtut <anton@swortex.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 34/72] ipv6: Fix exthdrs offload registration.
Date: Fri, 18 Apr 2014 11:22:07 +0200
Message-Id: <38de8fd06b3d36b66cbd5093db17c36714f130da.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Nayshtut <anton@swortex.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit d2d273ffabd315eecefce21a4391d44b6e156b73 ]

Without this fix, ipv6_exthdrs_offload_init doesn't register IPPROTO_DSTOPTS
offload, but returns 0 (as the IPPROTO_ROUTING registration actually succeeds).

This then causes the ipv6_gso_segment to drop IPv6 packets with IPPROTO_DSTOPTS
header.

The issue detected and the fix verified by running MS HCK Offload LSO test on
top of QEMU Windows guests, as this test sends IPv6 packets with
IPPROTO_DSTOPTS.

Signed-off-by: Anton Nayshtut <anton@swortex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/exthdrs_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs_offload.c b/net/ipv6/exthdrs_offload.c
index cf77f3abfd06..447a7fbd1bb6 100644
--- a/net/ipv6/exthdrs_offload.c
+++ b/net/ipv6/exthdrs_offload.c
@@ -25,11 +25,11 @@ int __init ipv6_exthdrs_offload_init(void)
 	int ret;
 
 	ret = inet6_add_offload(&rthdr_offload, IPPROTO_ROUTING);
-	if (!ret)
+	if (ret)
 		goto out;
 
 	ret = inet6_add_offload(&dstopt_offload, IPPROTO_DSTOPTS);
-	if (!ret)
+	if (ret)
 		goto out_rt;
 
 out:
-- 
1.9.2

