Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422703Ab3DKUoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3DKUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:54 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zIy0BurUMUUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aLBoyjLmYQAA:10 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=vO1rWKhFIqyBCLbNSO4A:9 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.254090549@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 006/171 ] netconsole: dont call __netpoll_cleanup() while atomic
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0006-netconsole-don-t-call-__netpoll_cleanup-while-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 3f315bef23075ea8a98a6fe4221a83b83456d970 ]

__netpoll_cleanup() is called in netconsole_netdev_event() while holding a
spinlock. Release/acquire the spinlock before/after it and restart the
loop. Also, disable the netconsole completely, because we won't have chance
after the restart of the loop, and might end up in a situation where
nt->enabled == 1 and nt->np.dev == NULL.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/netconsole.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index b332112..2524a69 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -626,6 +626,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 		goto done;
 
 	spin_lock_irqsave(&target_list_lock, flags);
+restart:
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
@@ -638,15 +639,17 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			case NETDEV_UNREGISTER:
 				/*
 				 * rtnl_lock already held
+				 * we might sleep in __netpoll_cleanup()
 				 */
-				if (nt->np.dev) {
-					__netpoll_cleanup(&nt->np);
-					dev_put(nt->np.dev);
-					nt->np.dev = NULL;
-				}
+				spin_unlock_irqrestore(&target_list_lock, flags);
+				__netpoll_cleanup(&nt->np);
+				spin_lock_irqsave(&target_list_lock, flags);
+				dev_put(nt->np.dev);
+				nt->np.dev = NULL;
 				nt->enabled = 0;
 				stopped = true;
-				break;
+				netconsole_target_put(nt);
+				goto restart;
 			}
 		}
 		netconsole_target_put(nt);
-- 
1.7.10.4


