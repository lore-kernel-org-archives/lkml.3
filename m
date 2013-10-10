Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3JJPmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:42:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Li Yu <raise.sail@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 002/104] net: avoid to hang up on sending due to sysctl configuration overflow.
Date: Thu, 10 Oct 2013 08:40:50 -0700
Message-Id: <1381419752-29733-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "bingtian.ly@taobao.com" <bingtian.ly@taobao.com>

commit cdda88912d62f9603d27433338a18be83ef23ac1 upstream.

    I found if we write a larger than 4GB value to some sysctl
variables, the sending syscall will hang up forever, because these
variables are 32 bits, such large values make them overflow to 0 or
negative.

    This patch try to fix overflow or prevent from zero value setup
of below sysctl variables:

net.core.wmem_default
net.core.rmem_default

net.core.rmem_max
net.core.wmem_max

net.ipv4.udp_rmem_min
net.ipv4.udp_wmem_min

net.ipv4.tcp_wmem
net.ipv4.tcp_rmem

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Li Yu <raise.sail@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/sysctl_net_core.c | 14 ++++++++++----
 net/ipv4/sysctl_net_ipv4.c | 11 +++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d1b0804..cfdb46a 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -20,6 +20,8 @@
 #include <net/sock.h>
 #include <net/net_ratelimit.h>
 
+static int one = 1;
+
 #ifdef CONFIG_RPS
 static int rps_sock_flow_sysctl(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -92,28 +94,32 @@ static struct ctl_table net_core_table[] = {
 		.data		= &sysctl_wmem_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "rmem_max",
 		.data		= &sysctl_rmem_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "wmem_default",
 		.data		= &sysctl_wmem_default,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "rmem_default",
 		.data		= &sysctl_rmem_default,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "dev_weight",
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 63632ea..d22765d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -27,6 +27,7 @@
 #include <net/tcp_memcontrol.h>
 
 static int zero;
+static int one = 1;
 static int two = 2;
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
@@ -560,14 +561,16 @@ static struct ctl_table ipv4_table[] = {
 		.data		= &sysctl_tcp_wmem,
 		.maxlen		= sizeof(sysctl_tcp_wmem),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "tcp_rmem",
 		.data		= &sysctl_tcp_rmem,
 		.maxlen		= sizeof(sysctl_tcp_rmem),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "tcp_app_win",
@@ -790,7 +793,7 @@ static struct ctl_table ipv4_table[] = {
 		.maxlen		= sizeof(sysctl_udp_rmem_min),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero
+		.extra1		= &one
 	},
 	{
 		.procname	= "udp_wmem_min",
@@ -798,7 +801,7 @@ static struct ctl_table ipv4_table[] = {
 		.maxlen		= sizeof(sysctl_udp_wmem_min),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero
+		.extra1		= &one
 	},
 	{ }
 };
-- 
1.8.1.2

