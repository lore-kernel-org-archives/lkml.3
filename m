Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaD1BdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42843 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matthew Leach" <matthew.leach@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.569969857@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/94] net: socket: error on a negative msg_namelen
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

[ Upstream commit dbb490b96584d4e958533fb637f08b557f505657 ]

When copying in a struct msghdr from the user, if the user has set the
msg_namelen parameter to a negative value it gets clamped to a valid
size due to a comparison between signed and unsigned values.

Ensure the syscall errors when the user passes in a negative value.

Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1884,6 +1884,10 @@ static int copy_msghdr_from_user(struct
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

