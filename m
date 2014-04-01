Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaDALyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaDALRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Schillstrom <hans@schillstrom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/144] ipv6: ipv6_find_hdr restore prev functionality
Date: Tue,  1 Apr 2014 12:14:36 +0100
Message-Id: <1396350948-29910-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Schillstrom <hans@schillstrom.com>

commit accfe0e356327da5bd53da8852b93fc22de9b5fc upstream.

The commit 9195bb8e381d81d5a315f911904cdf0cfcc919b8 ("ipv6: improve
ipv6_find_hdr() to skip empty routing headers") broke ipv6_find_hdr().

When a target is specified like IPPROTO_ICMPV6 ipv6_find_hdr()
returns -ENOENT when it's found, not the header as expected.

A part of IPVS is broken and possible also nft_exthdr_eval().
When target is -1 which it is most cases, it works.

This patch exits the do while loop if the specific header is found
so the nexthdr could be returned as expected.

Reported-by: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
CC:Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/exthdrs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index 140748d..8af3eb5 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -212,7 +212,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 		found = (nexthdr == target);
 
 		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE) {
-			if (target < 0)
+			if (target < 0 || found)
 				break;
 			return -ENOENT;
 		}
-- 
1.9.1

