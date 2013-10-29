Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3J2SJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3J2SJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Salam Noureddine <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 53/81] ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
Date: Tue, 29 Oct 2013 11:04:14 -0700
Message-Id: <1383069882-11437-54-git-send-email-kamal@canonical.com>
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

[ Upstream commit e2401654dd0f5f3fb7a8d80dad9554d73d7ca394 ]

It is possible for the timer handlers to run after the call to
ip_mc_down so use in_dev_put instead of __in_dev_put in the handler
function in order to do proper cleanup when the refcnt reaches 0.
Otherwise, the refcnt can reach zero without the in_device being
destroyed and we end up leaking a reference to the net_device and
see messages like the following,

unregister_netdevice: waiting for eth0 to become free. Usage count = 1

Tested on linux-3.4.43.

Signed-off-by: Salam Noureddine <noureddine@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/igmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index f5c3722f..5250b59 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -709,7 +709,7 @@ static void igmp_gq_timer_expire(unsigned long data)
 
 	in_dev->mr_gq_running = 0;
 	igmpv3_send_report(in_dev, NULL);
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_timer_expire(unsigned long data)
@@ -721,7 +721,7 @@ static void igmp_ifc_timer_expire(unsigned long data)
 		in_dev->mr_ifc_count--;
 		igmp_ifc_start_timer(in_dev, IGMP_Unsolicited_Report_Interval);
 	}
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_event(struct in_device *in_dev)
-- 
1.8.1.2

