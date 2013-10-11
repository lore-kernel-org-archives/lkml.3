Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3JKTl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab3JKTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Salam Noureddine <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 044/135] ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put
Date: Fri, 11 Oct 2013 12:38:45 -0700
Message-Id: <20131011193950.047395991@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1862,7 +1862,7 @@ static void mld_dad_timer_expire(unsigne
 		if (idev->mc_dad_count)
 			mld_dad_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
@@ -2207,7 +2207,7 @@ static void mld_gq_timer_expire(unsigned
 
 	idev->mc_gq_running = 0;
 	mld_send_report(idev, NULL);
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_timer_expire(unsigned long data)
@@ -2220,7 +2220,7 @@ static void mld_ifc_timer_expire(unsigne
 		if (idev->mc_ifc_count)
 			mld_ifc_start_timer(idev, idev->mc_maxdelay);
 	}
-	__in6_dev_put(idev);
+	in6_dev_put(idev);
 }
 
 static void mld_ifc_event(struct inet6_dev *idev)


