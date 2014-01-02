Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaABRFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:05:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaABRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 21/91] net: clamp ->msg_namelen instead of returning an error
Date: Thu,  2 Jan 2014 09:03:56 -0800
Message-Id: <1388682306-30859-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/compat.c | 2 +-
 net/socket.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 618c6a8..dd32e34 100644
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
index f7129f3..57d7a85 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1989,7 +1989,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
 }
 
-- 
1.8.3.2

