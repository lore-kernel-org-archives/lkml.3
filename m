Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaKKLry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:47:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaKKLKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 080/170] ipv4: Do not cache routing failures due to disabled forwarding.
Date: Tue, 11 Nov 2014 11:07:19 +0000
Message-Id: <1415704129-12709-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

commit fa19c2b050ab5254326f5fc07096dd3c6a8d5d58 upstream.

If we cache them, the kernel will reuse them, independently of
whether forwarding is enabled or not.  Which means that if forwarding is
disabled on the input interface where the first routing request comes
from, then that unreachable result will be cached and reused for
other interfaces, even if forwarding is enabled on them.  The opposite
is also true.

This can be verified with two interfaces A and B and an output interface
C, where B has forwarding enabled, but not A and trying
ip route get $dst iif A from $src && ip route get $dst iif B from $src

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4b340c30a037..ca0d8cca21dc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1798,6 +1798,7 @@ local_input:
 no_route:
 	RT_CACHE_STAT_INC(in_no_route);
 	res.type = RTN_UNREACHABLE;
+	res.fi = NULL;
 	if (err == -ESRCH)
 		err = -ENETUNREACH;
 	goto local_input;
-- 
2.1.0

