Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3FEVyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:54:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab3FEVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Sikorski <belegdol@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 066/127] svcrpc: fix failures to handle -1 uids and gids
Date: Wed,  5 Jun 2013 14:33:53 -0700
Message-Id: <20130605213225.442658787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit afe3c3fd5392b2f0066930abc5dbd3f4b14a0f13 upstream.

As of f025adf191924e3a75ce80e130afcd2485b53bb8 "sunrpc: Properly decode
kuids and kgids in RPC_AUTH_UNIX credentials" any rpc containing a -1
(0xffff) uid or gid would fail with a badcred error.

Reported symptoms were xmbc clients failing on upgrade of the NFS
server; examination of the network trace showed them sending -1 as the
gid.

Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svcauth_unix.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -810,11 +810,15 @@ svcauth_unix_accept(struct svc_rqst *rqs
 		goto badcred;
 	argv->iov_base = (void*)((__be32*)argv->iov_base + slen);	/* skip machname */
 	argv->iov_len -= slen*4;
-
+	/*
+	 * Note: we skip uid_valid()/gid_valid() checks here for
+	 * backwards compatibility with clients that use -1 id's.
+	 * Instead, -1 uid or gid is later mapped to the
+	 * (export-specific) anonymous id by nfsd_setuser.
+	 * Supplementary gid's will be left alone.
+	 */
 	cred->cr_uid = make_kuid(&init_user_ns, svc_getnl(argv)); /* uid */
 	cred->cr_gid = make_kgid(&init_user_ns, svc_getnl(argv)); /* gid */
-	if (!uid_valid(cred->cr_uid) || !gid_valid(cred->cr_gid))
-		goto badcred;
 	slen = svc_getnl(argv);			/* gids length */
 	if (slen > 16 || (len -= (slen + 2)*4) < 0)
 		goto badcred;
@@ -823,8 +827,6 @@ svcauth_unix_accept(struct svc_rqst *rqs
 		return SVC_CLOSE;
 	for (i = 0; i < slen; i++) {
 		kgid_t kgid = make_kgid(&init_user_ns, svc_getnl(argv));
-		if (!gid_valid(kgid))
-			goto badcred;
 		GROUP_AT(cred->cr_group_info, i) = kgid;
 	}
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {


