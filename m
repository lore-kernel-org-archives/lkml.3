Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825Ab3GWW1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3GWW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Geggus <lists@fuchsschwanzdomain.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 074/103] svcrpc: fix failures to handle -1 uids
Date: Tue, 23 Jul 2013 15:26:25 -0700
Message-Id: <20130723220427.948126757@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 0979292bfa301cb87d936b69af428090d2feea1b upstream.

As of f025adf191924e3a75ce80e130afcd2485b53bb8 "sunrpc: Properly decode
kuids and kgids in RPC_AUTH_UNIX credentials" any rpc containing a -1
(0xffff) uid or gid would fail with a badcred error.

Commit afe3c3fd5392b2f0066930abc5dbd3f4b14a0f13 "svcrpc: fix failures to
handle -1 uid's and gid's" fixed part of the problem, but overlooked the
gid upcall--the kernel can request supplementary gid's for the -1 uid,
but mountd's attempt write a response will get -EINVAL.

Symptoms were nfsd failing to reply to the first attempt to use a newly
negotiated krb5 context.

Reported-by: Sven Geggus <lists@fuchsschwanzdomain.de>
Tested-by: Sven Geggus <lists@fuchsschwanzdomain.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svcauth_unix.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -493,8 +493,6 @@ static int unix_gid_parse(struct cache_d
 	if (rv)
 		return -EINVAL;
 	uid = make_kuid(&init_user_ns, id);
-	if (!uid_valid(uid))
-		return -EINVAL;
 	ug.uid = uid;
 
 	expiry = get_expiry(&mesg);


