Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3I2Ted (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:34:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3I2T3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simo Sorce <simo@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 66/71] rpc: comment on linux_cred encoding, treat all as unsigned
Date: Sun, 29 Sep 2013 12:28:18 -0700
Message-Id: <20130929192648.039293563@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 6a36978e6931e6601be586eb313375335f2cfaa3 upstream.

The encoding of linux creds is a bit confusing.

Also: I think in practice it doesn't really matter whether we treat any
of these things as signed or unsigned, but unsigned seems more
straightforward: uid_t/gid_t are unsigned and it simplifies the ngroups
overflow check.

Tested-by: Simo Sorce <simo@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_xdr.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -166,14 +166,15 @@ static int dummy_dec_opt_array(struct xd
 	return 0;
 }
 
-static int get_s32(struct xdr_stream *xdr, s32 *res)
+static int get_host_u32(struct xdr_stream *xdr, u32 *res)
 {
 	__be32 *p;
 
 	p = xdr_inline_decode(xdr, 4);
 	if (!p)
 		return -EINVAL;
-	memcpy(res, p, sizeof(s32));
+	/* Contents of linux creds are all host-endian: */
+	memcpy(res, p, sizeof(u32));
 	return 0;
 }
 
@@ -182,8 +183,9 @@ static int gssx_dec_linux_creds(struct x
 {
 	u32 length;
 	__be32 *p;
-	s32 tmp;
-	int N, i, err;
+	u32 tmp;
+	u32 N;
+	int i, err;
 
 	p = xdr_inline_decode(xdr, 4);
 	if (unlikely(p == NULL))
@@ -195,19 +197,19 @@ static int gssx_dec_linux_creds(struct x
 		return -ENOSPC;
 
 	/* uid */
-	err = get_s32(xdr, &tmp);
+	err = get_host_u32(xdr, &tmp);
 	if (err)
 		return err;
 	creds->cr_uid = make_kuid(&init_user_ns, tmp);
 
 	/* gid */
-	err = get_s32(xdr, &tmp);
+	err = get_host_u32(xdr, &tmp);
 	if (err)
 		return err;
 	creds->cr_gid = make_kgid(&init_user_ns, tmp);
 
 	/* number of additional gid's */
-	err = get_s32(xdr, &tmp);
+	err = get_host_u32(xdr, &tmp);
 	if (err)
 		return err;
 	N = tmp;
@@ -220,7 +222,7 @@ static int gssx_dec_linux_creds(struct x
 	/* gid's */
 	for (i = 0; i < N; i++) {
 		kgid_t kgid;
-		err = get_s32(xdr, &tmp);
+		err = get_host_u32(xdr, &tmp);
 		if (err)
 			goto out_free_groups;
 		err = -EINVAL;


