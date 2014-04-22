Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbaDVVh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:37:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbaDVUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Leach <matthew.leach@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 008/133] net: socket: error on a negative msg_namelen
Date: Tue, 22 Apr 2014 13:12:26 -0700
Message-Id: <1398197671-12786-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

[ Upstream commit dbb490b96584d4e958533fb637f08b557f505657 ]

When copying in a struct msghdr from the user, if the user has set the
msg_namelen parameter to a negative value it gets clamped to a valid
size due to a comparison between signed and unsigned values.

Ensure the syscall errors when the user passes in a negative value.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index 57d7a85..17a8cdb 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1988,6 +1988,10 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 {
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
+
+	if (kmsg->msg_namelen < 0)
+		return -EINVAL;
+
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
-- 
1.9.1

