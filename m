Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966423AbaFQWtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:49:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215AbaFQVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 055/212] ipv6: fix calculation of option len in ip6_append_data
Date: Tue, 17 Jun 2014 14:42:29 -0700
Message-Id: <1403041506-13646-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3a1cebe7e05027a1c96f2fc1a8eddf5f19b78f42 ]

tot_len does specify the size of struct ipv6_txoptions. We need opt_flen +
opt_nflen to calculate the overall length of additional ipv6 extensions.

I found this while auditing the ipv6 output path for a memory corruption
reported by Alexey Preobrazhensky while he fuzzed an instrumented
AddressSanitizer kernel with trinity. This may or may not be the cause
of the original bug.

Fixes: 4df98e76cde7c6 ("ipv6: pmtudisc setting not respected with UFO/CORK")
Reported-by: Alexey Preobrazhensky <preobr@google.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 92bc3b4..e86c22e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1216,7 +1216,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 		unsigned int maxnonfragsize, headersize;
 
 		headersize = sizeof(struct ipv6hdr) +
-			     (opt ? opt->tot_len : 0) +
+			     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
 			     (dst_allfrag(&rt->dst) ?
 			      sizeof(struct frag_hdr) : 0) +
 			     rt->rt6i_nfheader_len;
-- 
1.9.1

