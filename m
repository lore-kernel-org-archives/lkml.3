Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaBLINx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:13:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbaBLINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sasha Levin" <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.362010125@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 06/79] net: unix: allow bind to fail on mutex lock
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/unix/af_unix.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9338ccc..eddfdec 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -696,7 +696,9 @@ static int unix_autobind(struct socket *sock)
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -829,7 +831,9 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	addr_len = err;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		goto out;
 
 	err = -EINVAL;
 	if (u->addr)

