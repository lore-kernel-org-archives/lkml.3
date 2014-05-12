Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaELBln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:43 -0400
Received: from 1wt.eu ([62.212.114.60]:34383 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaELBlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:39 -0400
Message-Id: <20140512003203.347626109@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 065/143] net: check net.core.somaxconn sysctl values
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <klamm@yandex-team.ru>

[ Upstream commit 5f671d6b4ec3e6d66c2a868738af2cdea09e7509 ]

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/sysctl_net_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7db1de0..e2eaf29 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -14,6 +14,9 @@
 #include <net/ip.h>
 #include <net/sock.h>
 
+static int zero = 0;
+static int ushort_max = 65535;
+
 static struct ctl_table net_core_table[] = {
 #ifdef CONFIG_NET
 	{
@@ -116,7 +119,9 @@ static struct ctl_table netns_core_table[] = {
 		.data		= &init_net.core.sysctl_somaxconn,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.extra1		= &zero,
+		.extra2		= &ushort_max,
+		.proc_handler	= proc_dointvec_minmax
 	},
 	{ .ctl_name = 0 }
 };
-- 
1.7.12.2.21.g234cd45.dirty



