Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaDRJca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45964 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Leach <matthew.leach@arm.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 42/72] net: socket: error on a negative msg_namelen
Date: Fri, 18 Apr 2014 11:22:15 +0200
Message-Id: <21ddf0c09da76adf3d4a66473cf01bc1b428453d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew.leach@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit dbb490b96584d4e958533fb637f08b557f505657 ]

When copying in a struct msghdr from the user, if the user has set the
msg_namelen parameter to a negative value it gets clamped to a valid
size due to a comparison between signed and unsigned values.

Ensure the syscall errors when the user passes in a negative value.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index e83c416708af..dc57dae20a9a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1972,6 +1972,10 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
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
1.9.2

