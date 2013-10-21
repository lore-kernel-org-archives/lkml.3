Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3JUJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:05:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39785 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256Ab3JUIwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Salam Noureddine" <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.207415708@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 111/149] ipv4 igmp: use in_dev_put in timer handlers
 instead of  __in_dev_put
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/igmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 24cf7da..75b0860 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -705,7 +705,7 @@ static void igmp_gq_timer_expire(unsigned long data)
 
 	in_dev->mr_gq_running = 0;
 	igmpv3_send_report(in_dev, NULL);
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_timer_expire(unsigned long data)
@@ -717,7 +717,7 @@ static void igmp_ifc_timer_expire(unsigned long data)
 		in_dev->mr_ifc_count--;
 		igmp_ifc_start_timer(in_dev, IGMP_Unsolicited_Report_Interval);
 	}
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_event(struct in_device *in_dev)

