Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbbA2JEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:04:52 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44824 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759503AbbA2JEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/176] fs: nfsd: Fix signedness bug in compare_blob
Date: Wed, 28 Jan 2015 15:27:50 +0100
Message-Id: <b2abe3c2f4217e3df748a348d2536bae103afc9e.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ef17af2a817db97d42dd2ec0a425231748e23dbc upstream.

Bugs similar to the one in acbbe6fbb240 (kcmp: fix standard comparison
bug) are in rich supply.

In this variant, the problem is that struct xdr_netobj::len has type
unsigned int, so the expression o1->len - o2->len _also_ has type
unsigned int; it has completely well-defined semantics, and the result
is some non-negative integer, which is always representable in a long
long. But this means that if the conditional triggers, we are
guaranteed to return a positive value from compare_blob.

In this case it could be fixed by

-       res = o1->len - o2->len;
+       res = (long long)o1->len - (long long)o2->len;

but I'd rather eliminate the usually broken 'return a - b;' idiom.

Reviewed-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4state.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5ae1dd340073..0a138e4fc2e0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1197,15 +1197,14 @@ static int copy_cred(struct svc_cred *target, struct svc_cred *source)
 	return 0;
 }
 
-static long long
+static int
 compare_blob(const struct xdr_netobj *o1, const struct xdr_netobj *o2)
 {
-	long long res;
-
-	res = o1->len - o2->len;
-	if (res)
-		return res;
-	return (long long)memcmp(o1->data, o2->data, o1->len);
+	if (o1->len < o2->len)
+		return -1;
+	if (o1->len > o2->len)
+		return 1;
+	return memcmp(o1->data, o2->data, o1->len);
 }
 
 static int same_name(const char *n1, const char *n2)
@@ -1389,7 +1388,7 @@ add_clp_to_name_tree(struct nfs4_client *new_clp, struct rb_root *root)
 static struct nfs4_client *
 find_clp_in_name_tree(struct xdr_netobj *name, struct rb_root *root)
 {
-	long long cmp;
+	int cmp;
 	struct rb_node *node = root->rb_node;
 	struct nfs4_client *clp;
 
-- 
2.2.2

