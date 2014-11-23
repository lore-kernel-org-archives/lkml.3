Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaKWOWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:22:41 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45562 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKWOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:22:35 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bertrand Jacquin <beber@meleeweb.net>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Fabian Frederick <fabf@skynet.be>,
        fuse-devel@lists.sourceforge.net (open list:FUSE: FILESYSTEM...),
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hugh Dickins <hughd@google.com>, Iulia Manda <iulia.manda21@gmail.com>,
        Jan Beulich <JBeulich@suse.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Matt Turner <mattst88@gmail.com>, Mel Gorman <mgorman@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        Oleg Nesterov <oleg@redhat.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Foley <pefoley2@pefoley.com>, Thomas Graf <tgraf@suug.ch>,
        Tom Herbert <therbert@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        =?UTF-8?q?=E8=94=A1=E6=AD=A3=E9=BE=99?= <zhenglong.cai@cs2c.com.cn>
Subject: [PATCH 5/6] net/core: support compiling out splice
Date: Sun, 23 Nov 2014 15:20:49 +0100
Message-Id: <1416752468-1626-6-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement splice support, net/core makes use of nosteal_pipe_buf_ops. This
struct is exported by fs/splice. The goal of the larger patch set is to
completely compile out fs/splice, so uses of the exported struct need to be
compiled out along with fs/splice.

This patch therefore compiles out splice support in net/core when
CONFIG_SYSCALL_SPLICE is undefined. The compiled out function skb_splice_bits
is transparently mocked out with a static inline. The greater patch set removes
userspace splice support so it cannot be called anyway.

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 include/linux/skbuff.h | 9 +++++++++
 net/core/skbuff.c      | 9 ++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a59d934..54a50c1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2640,9 +2640,18 @@ int skb_copy_bits(const struct sk_buff *skb, int offset, void *to, int len);
 int skb_store_bits(struct sk_buff *skb, int offset, const void *from, int len);
 __wsum skb_copy_and_csum_bits(const struct sk_buff *skb, int offset, u8 *to,
 			      int len, __wsum csum);
+#ifdef CONFIG_SYSCALL_SPLICE
 int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int len,
 		    unsigned int flags);
+#else
+static inline int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
+		    struct pipe_inode_info *pipe, unsigned int len,
+		    unsigned int flags)
+{
+	return -EPERM;
+}
+#endif
 void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
 unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
 int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 61059a0..74fad8a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1781,9 +1781,9 @@ static bool __splice_segment(struct page *page, unsigned int poff,
  * Map linear and fragment data from the skb to spd. It reports true if the
  * pipe is full or if we already spliced the requested length.
  */
-static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
-			      unsigned int *offset, unsigned int *len,
-			      struct splice_pipe_desc *spd, struct sock *sk)
+static bool __maybe_unused __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
+					     unsigned int *offset, unsigned int *len,
+					     struct splice_pipe_desc *spd, struct sock *sk)
 {
 	int seg;
 
@@ -1821,6 +1821,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
  * the frag list, if such a thing exists. We'd probably need to recurse to
  * handle that cleanly.
  */
+#ifdef CONFIG_SYSCALL_SPLICE
 int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
 		    unsigned int flags)
@@ -1876,6 +1877,8 @@ done:
 
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
+
 
 /**
  *	skb_store_bits - store bits from kernel buffer to skb
-- 
2.1.0

