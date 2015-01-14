Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbbANH6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:58:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbbANHfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 50/77] fs: nfsd: Fix signedness bug in compare_blob
Date: Tue, 13 Jan 2015 23:23:30 -0800
Message-Id: <20150114072227.002494977@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1209,15 +1209,14 @@ static int copy_cred(struct svc_cred *ta
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
@@ -1401,7 +1400,7 @@ add_clp_to_name_tree(struct nfs4_client
 static struct nfs4_client *
 find_clp_in_name_tree(struct xdr_netobj *name, struct rb_root *root)
 {
-	long long cmp;
+	int cmp;
 	struct rb_node *node = root->rb_node;
 	struct nfs4_client *clp;
 


