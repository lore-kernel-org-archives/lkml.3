Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3LMPys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:54:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44872 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LMPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:54:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: davem@davemloft.net
Cc: edumazet@google.com, netdev@vger.kernel.org, xemul@parallels.com,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] net: unix: allow bind to fail on mutex lock
Date: Fri, 13 Dec 2013 10:54:22 -0500
Message-Id: <1386950062-19020-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to the set_peek_off patch where calling bind while the
socket is stuck in unix_dgram_recvmsg() will block and cause a hung task
spew after a while.

This is also the last place that did a straightforward mutex_lock(), so
there shouldn't be any more of these patches.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 net/unix/af_unix.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 7edbcd9..800ca61 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -720,7 +720,9 @@ static int unix_autobind(struct socket *sock)
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -879,7 +881,9 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		goto out;
 
 	err = -EINVAL;
 	if (u->addr)
-- 
1.7.10.4

