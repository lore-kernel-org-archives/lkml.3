Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3ILRca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:32:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3ILR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Gushchin <klamm@yandex-team.ru>, Changli Gao <xiaosuo@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/19] net: check net.core.somaxconn sysctl values
Date: Thu, 12 Sep 2013 10:26:11 -0700
Message-Id: <20130912172524.437243748@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sysctl_net_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -19,6 +19,9 @@
 #include <net/sock.h>
 #include <net/net_ratelimit.h>
 
+static int zero = 0;
+static int ushort_max = USHRT_MAX;
+
 #ifdef CONFIG_RPS
 static int rps_sock_flow_sysctl(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -192,7 +195,9 @@ static struct ctl_table netns_core_table
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


