Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaFNUoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:10 -0400
Received: from 1wt.eu ([62.212.114.60]:42877 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbaFNUoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:06 -0400
Message-Id: <20140614191250.499750488@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: tyler.hicks@canonical.com, luis.henriques@canonical.com,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 9/9] net: fix regression introduced in 2.6.32.62 by sysctl
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 fixes

From: Willy Tarreau <w@1wt.eu>

Commits b7c9e4ee1 ("sysctl net: Keep tcp_syn_retries inside the boundary")
and eedcafdc ("net: check net.core.somaxconn sysctl values") were missing
a .strategy entry which is still required in 2.6.32. Because of this, the
Ubuntu kernel team has faced kernel dumps during their testing.

Tyler Hicks and Luis Henriques proposed this patch to fix the issue,
which properly sets .strategy as needed in 2.6.32.

Reported-by: Luis Henriques <luis.henriques@canonical.com>
Cc: tyler.hicks@canonical.com
Cc: Michal Tesar <mtesar@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/sysctl_net_core.c | 3 ++-
 net/ipv4/sysctl_net_ipv4.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index e2eaf29..e6bf72c 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -121,7 +121,8 @@ static struct ctl_table netns_core_table[] = {
 		.mode		= 0644,
 		.extra1		= &zero,
 		.extra2		= &ushort_max,
-		.proc_handler	= proc_dointvec_minmax
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec
 	},
 	{ .ctl_name = 0 }
 };
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 910fa54..d957371 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -241,7 +241,8 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &tcp_syn_retries_min,
-		.extra2		= &tcp_syn_retries_max
+		.extra2		= &tcp_syn_retries_max,
+		.strategy	= &sysctl_intvec
 	},
 	{
 		.ctl_name	= NET_IPV4_NONLOCAL_BIND,
-- 
1.7.12.2.21.g234cd45.dirty




