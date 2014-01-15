Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaAOW2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:28:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaAOV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 152/166] net: unix: allow bind to fail on mutex lock
Date: Wed, 15 Jan 2014 13:52:46 -0800
Message-Id: <1389822780-4729-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 37ab4fa7844a044dc21fde45e2a0fc2f3c3b6490 ]

This is similar to the set_peek_off patch where calling bind while the
socket is stuck in unix_dgram_recvmsg() will block and cause a hung task
spew after a while.

This is also the last place that did a straightforward mutex_lock(), so
there shouldn't be any more of these patches.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/unix/af_unix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 499efb7..fdf0900 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -719,7 +719,9 @@ static int unix_autobind(struct socket *sock)
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -878,7 +880,9 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		goto out;
 
 	err = -EINVAL;
 	if (u->addr)
-- 
1.8.3.2

