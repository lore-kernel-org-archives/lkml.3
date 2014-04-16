Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaDPKvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:51:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbaDPKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Nayshtut <anton@swortex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 15/46] ipv6: Fix exthdrs offload registration.
Date: Wed, 16 Apr 2014 11:31:31 +0100
Message-Id: <1397644322-13905-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Nayshtut <anton@swortex.com>

commit d2d273ffabd315eecefce21a4391d44b6e156b73 upstream.

Without this fix, ipv6_exthdrs_offload_init doesn't register IPPROTO_DSTOPTS
offload, but returns 0 (as the IPPROTO_ROUTING registration actually succeeds).

This then causes the ipv6_gso_segment to drop IPv6 packets with IPPROTO_DSTOPTS
header.

The issue detected and the fix verified by running MS HCK Offload LSO test on
top of QEMU Windows guests, as this test sends IPv6 packets with
IPPROTO_DSTOPTS.

Signed-off-by: Anton Nayshtut <anton@swortex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/exthdrs_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs_offload.c b/net/ipv6/exthdrs_offload.c
index cf77f3a..447a7fb 100644
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
1.9.1

