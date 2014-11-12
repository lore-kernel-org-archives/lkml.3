Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaKLBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKLBUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 019/319] ipv4: Do not cache routing failures due to disabled forwarding.
Date: Wed, 12 Nov 2014 10:12:37 +0900
Message-Id: <20141112010955.866756342@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit fa19c2b050ab5254326f5fc07096dd3c6a8d5d58 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1798,6 +1798,7 @@ local_input:
 no_route:
 	RT_CACHE_STAT_INC(in_no_route);
 	res.type = RTN_UNREACHABLE;
+	res.fi = NULL;
 	goto local_input;
 
 	/*


