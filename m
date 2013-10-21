Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3JUIwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab3JUIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Salam Noureddine" <noureddine@aristanetworks.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.284564624@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/149] ipv6 mcast: use in6_dev_put in timer handlers
 instead  of __in6_dev_put
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/mcast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index c7ec4bb..d20a9be 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2159,7 +2159,7 @@ static void mld_gq_timer_expire(unsigned long data)
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_timer_expire(unsigned long data)
@@ -2172,7 +2172,7 @@ static void mld_ifc_timer_expire(unsigned long data)
 		if (idev->mc_ifc_count)
 			mld_ifc_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)

