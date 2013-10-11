Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab3JKKnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab3JKKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Salam Noureddine <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 063/100] ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put
Date: Fri, 11 Oct 2013 11:41:33 +0100
Message-Id: <1381488130-30235-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salam Noureddine <noureddine@aristanetworks.com>

commit 9260d3e1013701aa814d10c8fc6a9f92bd17d643 upstream.

It is possible for the timer handlers to run after the call to
ipv6_mc_down so use in6_dev_put instead of __in6_dev_put in the
handler function in order to do proper cleanup when the refcnt
reaches 0. Otherwise, the refcnt can reach zero without the
inet6_dev being destroyed and we end up leaking a reference to
the net_device and see messages like the following,

unregister_netdevice: waiting for eth0 to become free. Usage count = 1

Tested on linux-3.4.43.

Signed-off-by: Salam Noureddine <noureddine@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5 (based on davem backport to 3.4):
  - dropped changes to mld_dad_timer_expire() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/mcast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 2e97228..4441a0f 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2149,7 +2149,7 @@ static void mld_gq_timer_expire(unsigned long data)
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_timer_expire(unsigned long data)
@@ -2162,7 +2162,7 @@ static void mld_ifc_timer_expire(unsigned long data)
 		if (idev->mc_ifc_count)
 			mld_ifc_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)
-- 
1.8.3.2

