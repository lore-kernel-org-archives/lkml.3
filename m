Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaBGLwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42530 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaBGLwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 221/233] fib_frontend: fix possible NULL pointer dereference
Date: Fri,  7 Feb 2014 11:47:20 +0000
Message-Id: <1391773652-25214-222-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit a0065f266a9b5d51575535a25c15ccbeed9a9966 upstream.

The two commits 0115e8e30d (net: remove delay at device dismantle) and
748e2d9396a (net: reinstate rtnl in call_netdevice_notifiers()) silently
removed a NULL pointer check for in_dev since Linux 3.7.

This patch re-introduces this check as it causes crashing the kernel when
setting small mtu values on non-ip capable netdevices.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/fib_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b3f627a..f7f8cff 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1049,6 +1049,8 @@ static int fib_netdev_event(struct notifier_block *this, unsigned long event, vo
 	}
 
 	in_dev = __in_dev_get_rtnl(dev);
+	if (!in_dev)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UP:
-- 
1.8.3.2

