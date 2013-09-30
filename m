Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3I3Uax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:30:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:33002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab3I3U3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029775"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, netdev@vger.kernel.org
Subject: [PATCH 10/11] tcp: Always set options to 0 before calling tcp_established_options
Date: Mon, 30 Sep 2013 13:29:11 -0700
Message-Id: <1380572952-30729-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

tcp_established_options assumes opts->options is 0 before calling,
as it read modify writes it.

For the tcp_current_mss() case the opts structure is not zeroed,
so this can be done with uninitialized values.

This is ok, because ->options is not read in this path.
But it's still better to avoid the operation on the uninitialized
field. This shuts up a static code analyzer, and presumably
may help the optimizer.

Cc: netdev@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/ipv4/tcp_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7c83cb8..f3ed78d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -637,6 +637,8 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	unsigned int size = 0;
 	unsigned int eff_sacks;
 
+	opts->options = 0;
+
 #ifdef CONFIG_TCP_MD5SIG
 	*md5 = tp->af_specific->md5_lookup(sk, sk);
 	if (unlikely(*md5)) {
-- 
1.8.3.1

