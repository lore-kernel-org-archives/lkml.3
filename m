Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3I3Kbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:31:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3I3KMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 039/104] net: check net.core.somaxconn sysctl values
Date: Mon, 30 Sep 2013 11:10:16 +0100
Message-Id: <1380535881-9239-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <klamm@yandex-team.ru>

commit 5f671d6b4ec3e6d66c2a868738af2cdea09e7509 upstream.

It's possible to assign an invalid value to the net.core.somaxconn
sysctl variable, because there is no checks at all.

The sk_max_ack_backlog field of the sock structure is defined as
unsigned short. Therefore, the backlog argument in inet_listen()
shouldn't exceed USHRT_MAX. The backlog argument in the listen() syscall
is truncated to the somaxconn value. So, the somaxconn value shouldn't
exceed 65535 (USHRT_MAX).
Also, negative values of somaxconn are meaningless.

before:
$ sysctl -w net.core.somaxconn=256
net.core.somaxconn = 256
$ sysctl -w net.core.somaxconn=65536
net.core.somaxconn = 65536
$ sysctl -w net.core.somaxconn=-100
net.core.somaxconn = -100

after:
$ sysctl -w net.core.somaxconn=256
net.core.somaxconn = 256
$ sysctl -w net.core.somaxconn=65536
error: "Invalid argument" setting key "net.core.somaxconn"
$ sysctl -w net.core.somaxconn=-100
error: "Invalid argument" setting key "net.core.somaxconn"

Based on a prior patch from Changli Gao.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Reported-by: Changli Gao <xiaosuo@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/sysctl_net_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index a7c3684..df0dafe 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -20,6 +20,9 @@
 #include <net/sock.h>
 #include <net/net_ratelimit.h>
 
+static int zero = 0;
+static int ushort_max = USHRT_MAX;
+
 #ifdef CONFIG_RPS
 static int rps_sock_flow_sysctl(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -198,7 +201,9 @@ static struct ctl_table netns_core_table[] = {
 		.data		= &init_net.core.sysctl_somaxconn,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.extra1		= &zero,
+		.extra2		= &ushort_max,
+		.proc_handler	= proc_dointvec_minmax
 	},
 	{ }
 };
-- 
1.8.3.2

