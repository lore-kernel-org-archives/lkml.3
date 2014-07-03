Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaGCHwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:52:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58669 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaGCHw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:52:28 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: filter: move load_pointer() into filter.h
Date: Thu,  3 Jul 2014 00:52:12 -0700
Message-Id: <1404373932-10929-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_pointer() is already a static inline function.
Let's move it into filter.h so BPF JIT implementations can reuse this
function.

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
---
This patch is based on discussion with Alexei in the context of
reusing load_pointer for upcoming arm64 BPF JIT compiler. [1]

Compile tested on x86_64 and arm64.

[1] https://lkml.org/lkml/2014/7/3/14

 include/linux/filter.h | 13 +++++++++++++
 net/core/filter.c      |  9 ---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index a7e3c48..2288e31 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -6,6 +6,7 @@
 
 #include <linux/atomic.h>
 #include <linux/compat.h>
+#include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/filter.h>
 
@@ -406,6 +407,18 @@ static inline u16 bpf_anc_helper(const struct sock_filter *ftest)
 	}
 }
 
+void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb,
+					   int k, unsigned int size);
+
+static inline void *load_pointer(const struct sk_buff *skb, int k,
+				 unsigned int size, void *buffer)
+{
+	if (k >= 0)
+		return skb_header_pointer(skb, k, size, buffer);
+
+	return bpf_internal_load_pointer_neg_helper(skb, k, size);
+}
+
 #ifdef CONFIG_BPF_JIT
 #include <stdarg.h>
 #include <linux/linkage.h>
diff --git a/net/core/filter.c b/net/core/filter.c
index 1dbf646..1c726ea 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -84,15 +84,6 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 	return NULL;
 }
 
-static inline void *load_pointer(const struct sk_buff *skb, int k,
-				 unsigned int size, void *buffer)
-{
-	if (k >= 0)
-		return skb_header_pointer(skb, k, size, buffer);
-
-	return bpf_internal_load_pointer_neg_helper(skb, k, size);
-}
-
 /**
  *	sk_filter - run a packet through a socket filter
  *	@sk: sock associated with &sk_buff
-- 
1.9.1

