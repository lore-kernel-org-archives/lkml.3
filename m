Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbaIOWv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbaIOWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/187] selinux: fix the default socket labeling in sock_graft()
Date: Mon, 15 Sep 2014 15:08:02 -0700
Message-Id: <1410818997-9432-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 4da6daf4d3df5a977e4623963f141a627fd2efce upstream.

The sock_graft() hook has special handling for AF_INET, AF_INET, and
AF_UNIX sockets as those address families have special hooks which
label the sock before it is attached its associated socket.
Unfortunately, the sock_graft() hook was missing a default approach
to labeling sockets which meant that any other address family which
made use of connections or the accept() syscall would find the
returned socket to be in an "unlabeled" state.  This was recently
demonstrated by the kcrypto/AF_ALG subsystem and the newly released
cryptsetup package (cryptsetup v1.6.5 and later).

This patch preserves the special handling in selinux_sock_graft(),
but adds a default behavior - setting the sock's label equal to the
associated socket - which resolves the problem with AF_ALG and
presumably any other address family which makes use of accept().

Signed-off-by: Paul Moore <pmoore@redhat.com>
Tested-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/security.h |  5 ++++-
 security/selinux/hooks.c | 13 +++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 5623a7f..e42af21 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -987,7 +987,10 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Retrieve the LSM-specific secid for the sock to enable caching of network
  *	authorizations.
  * @sock_graft:
- *	Sets the socket's isec sid to the sock's sid.
+ *	This hook is called in response to a newly created sock struct being
+ *	grafted onto an existing socket and allows the security module to
+ *	perform whatever security attribute management is necessary for both
+ *	the sock and socket.
  * @inet_conn_request:
  *	Sets the openreq's sid to socket's sid with MLS portion taken from peer sid.
  * @inet_csk_clone:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 019749c..f66143d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4497,9 +4497,18 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 	struct inode_security_struct *isec = SOCK_INODE(parent)->i_security;
 	struct sk_security_struct *sksec = sk->sk_security;
 
-	if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6 ||
-	    sk->sk_family == PF_UNIX)
+	switch (sk->sk_family) {
+	case PF_INET:
+	case PF_INET6:
+	case PF_UNIX:
 		isec->sid = sksec->sid;
+		break;
+	default:
+		/* by default there is no special labeling mechanism for the
+		 * sksec label so inherit the label from the parent socket */
+		BUG_ON(sksec->sid != SECINITSID_UNLABELED);
+		sksec->sid = isec->sid;
+	}
 	sksec->sclass = isec->sclass;
 }
 
-- 
1.9.1

