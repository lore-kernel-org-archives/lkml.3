Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3J2SJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3J2SJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Salam Noureddine <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 54/81] ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put
Date: Tue, 29 Oct 2013 11:04:15 -0700
Message-Id: <1383069882-11437-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salam Noureddine <noureddine@aristanetworks.com>

[ Upstream commit 9260d3e1013701aa814d10c8fc6a9f92bd17d643 ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/mcast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 79fa628..ac1b533 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2155,7 +2155,7 @@ static void mld_gq_timer_expire(unsigned long data)
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_timer_expire(unsigned long data)
@@ -2168,7 +2168,7 @@ static void mld_ifc_timer_expire(unsigned long data)
 		if (idev->mc_ifc_count)
 			mld_ifc_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)
-- 
1.8.1.2

