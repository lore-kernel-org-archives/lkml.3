Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3L2Cqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:46:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab3L2CKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:25 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Eric Wong" <normalperson@yhbt.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.224117336@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 162/185] net: clamp ->msg_namelen instead of returning
 an error
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit db31c55a6fb245fdbb752a2ca4aefec89afabb06 ]

If kmsg->msg_namelen > sizeof(struct sockaddr_storage) then in the
original code that would lead to memory corruption in the kernel if you
had audit configured.  If you didn't have audit configured it was
harmless.

There are some programs such as beta versions of Ruby which use too
large of a buffer and returning an error code breaks them.  We should
clamp the ->msg_namelen value instead.

Fixes: 1661bf364ae9 ("net: heap overflow in __audit_sockaddr()")
Reported-by: Eric Wong <normalperson@yhbt.net>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Eric Wong <normalperson@yhbt.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/compat.c | 2 +-
 net/socket.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 3312574..41724c9 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -72,7 +72,7 @@ int get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg)
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
diff --git a/net/socket.c b/net/socket.c
index 8021b0f..d4faade 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1885,7 +1885,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
 }
 

