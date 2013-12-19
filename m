Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3LSNGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:06:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3LSLzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/208] net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sockaddr_storage)
Date: Thu, 19 Dec 2013 11:52:01 +0000
Message-Id: <1387454106-19326-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 68c6beb373955da0886d8f4f5995b3922ceda4be upstream.

In that case it is probable that kernel code overwrote part of the
stack. So we should bail out loudly here.

The BUG_ON may be removed in future if we are sure all protocols are
conformant.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 5158ff7..65b0013 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -221,12 +221,13 @@ static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
 	int err;
 	int len;
 
+	BUG_ON(klen > sizeof(struct sockaddr_storage));
 	err = get_user(len, ulen);
 	if (err)
 		return err;
 	if (len > klen)
 		len = klen;
-	if (len < 0 || len > sizeof(struct sockaddr_storage))
+	if (len < 0)
 		return -EINVAL;
 	if (len) {
 		if (audit_sockaddr(klen, kaddr))
-- 
1.8.3.2

