Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaANA1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaANA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 20/62] net: unix: allow bind to fail on mutex lock
Date: Mon, 13 Jan 2014 16:26:45 -0800
Message-Id: <20140114002711.044881103@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -717,7 +717,9 @@ static int unix_autobind(struct socket *
 	int err;
 	unsigned int retries = 0;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		return err;
 
 	err = 0;
 	if (u->addr)
@@ -876,7 +878,9 @@ static int unix_bind(struct socket *sock
 		goto out;
 	addr_len = err;
 
-	mutex_lock(&u->readlock);
+	err = mutex_lock_interruptible(&u->readlock);
+	if (err)
+		goto out;
 
 	err = -EINVAL;
 	if (u->addr)


