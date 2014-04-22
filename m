Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaDVUPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:15:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbaDVUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Nayshtut <anton@swortex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 004/133] ipv6: Fix exthdrs offload registration.
Date: Tue, 22 Apr 2014 13:12:22 -0700
Message-Id: <1398197671-12786-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Nayshtut <anton@swortex.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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

