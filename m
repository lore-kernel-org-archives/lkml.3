Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab3LFVxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336Ab3LFVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Wong <normalperson@yhbt.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 22/58] net: clamp ->msg_namelen instead of returning an error
Date: Fri,  6 Dec 2013 13:51:53 -0800
Message-Id: <20131206214846.976397916@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/compat.c |    2 +-
 net/socket.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/compat.c
+++ b/net/compat.c
@@ -72,7 +72,7 @@ int get_compat_msghdr(struct msghdr *kms
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
--- a/net/socket.c
+++ b/net/socket.c
@@ -1965,7 +1965,7 @@ static int copy_msghdr_from_user(struct
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
 }
 


