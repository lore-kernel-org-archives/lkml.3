Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3JKTfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:35:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3JKTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Salam Noureddine <noureddine@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/39] ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put
Date: Fri, 11 Oct 2013 12:34:55 -0700
Message-Id: <20131011193212.108492237@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -705,7 +705,7 @@ static void igmp_gq_timer_expire(unsigne
 
 	in_dev->mr_gq_running = 0;
 	igmpv3_send_report(in_dev, NULL);
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_timer_expire(unsigned long data)
@@ -717,7 +717,7 @@ static void igmp_ifc_timer_expire(unsign
 		in_dev->mr_ifc_count--;
 		igmp_ifc_start_timer(in_dev, IGMP_Unsolicited_Report_Interval);
 	}
-	__in_dev_put(in_dev);
+	in_dev_put(in_dev);
 }
 
 static void igmp_ifc_event(struct in_device *in_dev)


