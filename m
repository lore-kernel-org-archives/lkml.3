Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbaCEPLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:11:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaCEO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 069/131] ipv4: Fix runtime WARNING in rtmsg_ifa()
Date: Wed,  5 Mar 2014 14:23:13 +0000
Message-Id: <1394029455-23128-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 63b5f152eb4a5bb79b9caf7ec37b4201d12f6e66 upstream.

On m68k/ARAnyM:

WARNING: CPU: 0 PID: 407 at net/ipv4/devinet.c:1599 0x316a99()
Modules linked in:
CPU: 0 PID: 407 Comm: ifconfig Not tainted
3.13.0-atari-09263-g0c71d68014d1 #1378
Stack from 10c4fdf0:
        10c4fdf0 002ffabb 000243e8 00000000 008ced6c 00024416 00316a99 0000063f
        00316a99 00000009 00000000 002501b4 00316a99 0000063f c0a86117 00000080
        c0a86117 00ad0c90 00250a5a 00000014 00ad0c90 00000000 00000000 00000001
        00b02dd0 00356594 00000000 00356594 c0a86117 eff6c9e4 008ced6c 00000002
        008ced60 0024f9b4 00250b52 00ad0c90 00000000 00000000 00252390 00ad0c90
        eff6c9e4 0000004f 00000000 00000000 eff6c9e4 8000e25c eff6c9e4 80001020
Call Trace: [<000243e8>] warn_slowpath_common+0x52/0x6c
 [<00024416>] warn_slowpath_null+0x14/0x1a
 [<002501b4>] rtmsg_ifa+0xdc/0xf0
 [<00250a5a>] __inet_insert_ifa+0xd6/0x1c2
 [<0024f9b4>] inet_abc_len+0x0/0x42
 [<00250b52>] inet_insert_ifa+0xc/0x12
 [<00252390>] devinet_ioctl+0x2ae/0x5d6

Adding some debugging code reveals that net_fill_ifaddr() fails in

    put_cacheinfo(skb, ifa->ifa_cstamp, ifa->ifa_tstamp,
                              preferred, valid))

nla_put complains:

    lib/nlattr.c:454: skb_tailroom(skb) = 12, nla_total_size(attrlen) = 20

Apparently commit 5c766d642bcaffd0c2a5b354db2068515b3846cf ("ipv4:
introduce address lifetime") forgot to take into account the addition of
struct ifa_cacheinfo in inet_nlmsg_size(). Hence add it, like is already
done for ipv6.

Suggested-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: used davem's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 34ca6d5..d281cb8 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1434,7 +1434,8 @@ static size_t inet_nlmsg_size(void)
 	       + nla_total_size(4) /* IFA_ADDRESS */
 	       + nla_total_size(4) /* IFA_LOCAL */
 	       + nla_total_size(4) /* IFA_BROADCAST */
-	       + nla_total_size(IFNAMSIZ); /* IFA_LABEL */
+	       + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
+	       + nla_total_size(sizeof(struct ifa_cacheinfo)); /* IFA_CACHEINFO */
 }
 
 static inline u32 cstamp_delta(unsigned long cstamp)
-- 
1.9.0

