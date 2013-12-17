Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3LQSlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:41:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3LQSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 020/103] net: clamp ->msg_namelen instead of returning an error
Date: Tue, 17 Dec 2013 18:12:09 +0000
Message-Id: <1387304012-23805-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit db31c55a6fb245fdbb752a2ca4aefec89afabb06 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/compat.c | 2 +-
 net/socket.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index b4afcb4..1d223d5 100644
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
index 5febb56..b04050a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1907,7 +1907,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
 }
 
-- 
1.8.3.2

