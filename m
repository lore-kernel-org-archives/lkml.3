Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaDPKcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51693 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaDPKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Leach <matthew.leach@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 19/46] net: socket: error on a negative msg_namelen
Date: Wed, 16 Apr 2014 11:31:35 +0100
Message-Id: <1397644322-13905-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

commit dbb490b96584d4e958533fb637f08b557f505657 upstream.

When copying in a struct msghdr from the user, if the user has set the
msg_namelen parameter to a negative value it gets clamped to a valid
size due to a comparison between signed and unsigned values.

Ensure the syscall errors when the user passes in a negative value.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index 03d5324..6bfb9e4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1981,6 +1981,10 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
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

