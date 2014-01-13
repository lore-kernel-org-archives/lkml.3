Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaAMOiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:38:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaAMO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 85/96] net: unix: allow bind to fail on mutex lock
Date: Mon, 13 Jan 2014 14:24:48 +0000
Message-Id: <1389623099-18783-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 37ab4fa7844a044dc21fde45e2a0fc2f3c3b6490 upstream.

This is similar to the set_peek_off patch where calling bind while the
socket is stuck in unix_dgram_recvmsg() will block and cause a hung task
spew after a while.

This is also the last place that did a straightforward mutex_lock(), so
there shouldn't be any more of these patches.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/unix/af_unix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 692d780..5959b80 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -713,7 +713,9 @@ static int unix_autobind(struct socket *sock)
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -846,7 +848,9 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

