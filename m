Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbAVOlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:41:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20623 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbAVOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:41:16 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7f-54c10b78d6ed
From: Marcin Lis <m.lis@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Rafal Krypa <r.krypa@samsung.com>,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcin Lis <marcin.lis.dev@gmail.com>,
        Marcin Lis <m.lis@samsung.com>
Subject: [PATCH 1/1] Smack: Assign smack_known_web as default smk_in label for
 kernel thread's socket
Date: Thu, 22 Jan 2015 15:40:33 +0100
Message-id: <1421937633-2041-1-git-send-email-m.lis@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xa7oV3AdDDG69l7O4t+0Xm0Xf4yCL
	y7vmsFl86HnEZnH34FsWi7ffvjJbvJ20gtni/IVz7A4cHjtn3WX3uLY70uPj01ssHn1bVjF6
	HN2/iM3j8ya5ALYoLpuU1JzMstQifbsErozjD36yFCzkrmja/5q1gbGHs4uRg0NCwETi5cLC
	LkZOIFNM4sK99WxdjFwcQgJLGSXub/rGBJIQEuhjkjg2vQzEZhNQkfj8rYcVpEhE4AyjRN/J
	RYwgCWaBTInnqyexgdjCAukSLxrWsIDYLAKqEk9/NrKC2LwCDhLXn31lg1isIDFnks0ERu4F
	jAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC5ssOxsXHrA4xCnAwKvHwBqw8ECLEmlhW
	XJl7iFGCg1lJhJf/JVCINyWxsiq1KD++qDQntfgQIxMHp1QDYxzv/Z6mvhUrDCYZXxfmk5L/
	yXlTNjJmNmdD05kMDue0fYGCuU6yFRciRMUOr7pWyKM3tXjBY3UW0fgvWizSKTsKD+re3xu9
	ibVrmatrBKvFvc1p2+XX9NxRbszRisis3sszKWnWGRe5+puWJh3OmUIT5bYrTzeZmlNacdDK
	aHb6po4vL54rsRRnJBpqMRcVJwIAtVj80PcBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes the bug associated with sockets owned by kernel threads. These
sockets, created usually by network devices' drivers tasks, received smk_in
label from the task that created them - the "floor" label in the most cases. The
result was that they were not able to receive data packets because of missing
smack rules. The main reason of the access deny is that the socket smk_in label
is placed as the object during smk check, kernel thread's capabilities are
omitted.

Signed-off-by: Marcin Lis <m.lis@samsung.com>
---
 security/smack/smack_lsm.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a688f7b..535a06a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2452,7 +2452,20 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 static int smack_socket_post_create(struct socket *sock, int family,
 				    int type, int protocol, int kern)
 {
-	if (family != PF_INET || sock->sk == NULL)
+	struct socket_smack *ssp;
+
+	if (sock->sk == NULL)
+		return 0;
+
+	/*
+	 * Sockets created by kernel threads receive web label.
+	 */
+	if (unlikely(current->flags & PF_KTHREAD)) {
+		ssp = sock->sk->sk_security;
+		ssp->smk_in = &smack_known_web;
+	}
+
+	if (family != PF_INET)
 		return 0;
 	/*
 	 * Set the outbound netlbl.
-- 
1.7.9.5

