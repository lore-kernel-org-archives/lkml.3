Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaGPBzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:55:53 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57903 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaGPBzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:55:50 -0400
MIME-Version: 1.0
Date: Wed, 16 Jul 2014 09:55:49 +0800
Message-ID: <CABawtvONfFP8ffyVOyu5=DVXgqyiek5oaVSV_EbfiMyMSpU+UQ@mail.gmail.com>
Subject: Hit bug with script/checkpatch.pl
From: Ethan Zhao <ethan.kernel@gmail.com>
To: joe@perches.com, anish@chelsio.com, apw@canonical.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I hit a bug when run script/checkpatch.pl to my patch, It
reported a error with following
macro definition, but in fact the macro is correct, I couldn't change
that macro according to
the error message output by script/checkpatch.pl. because of this bug,
my patch was rejected by some guy's patchwork.


 ./scripts/checkpatch.pl netxen.patch
ERROR: Macros with complex values should be enclosed in parenthesis
#38: FILE: drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:45:
+#define NETXEN_NIC_STAT(m)     NETXEN_STATS, \
+                       sizeof(((struct netxen_adapter *)0)->m), \
                        offsetof(struct netxen_adapter, m)

ERROR: Macros with complex values should be enclosed in parenthesis
#42: FILE: drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:49:
+#define NETXEN_NETDEV_STAT(m)  NETDEV_STATS, \
+                       sizeof(((struct rtnl_link_stats64 *)0)->m), \
+                       offsetof(struct rtnl_link_stats64, m)

total: 2 errors, 0 warnings, 62 lines checked

netxen.patch has style problems, please review.

If any of these errors are false positives, please report


----------------
Please check and fix it.
Thanks,
Ethan
----------------------------------------------following is the patch
hit the bug------------------------
From: Ethan Zhao <ethan.zhao@oracle.com>

netxen driver has implemented netxen_nic_get_ethtool_stats() interface,
but it doesn't collect stats.rxdropped in driver, so we will get
different rx_dropped statistic information while using ifconfig and ethtool.
this patch fills stats.rxdropped field with data from net core
with dev_get_stats() just as ixgbe driver did for some of its stats.

V2: only fix the stats.rxdropped field.

Tested with last netxen 4.0.82
Compiled with net-next branch 3.16-rc2

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
Tested-by: Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
---
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |   34 +++++++++++++++++---
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index 4ca2c19..49e6a1b 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -33,22 +33,30 @@
 #include "netxen_nic.h"
 #include "netxen_nic_hw.h"

+enum {NETDEV_STATS, NETXEN_STATS};
+
 struct netxen_nic_stats {
        char stat_string[ETH_GSTRING_LEN];
+       int type;
        int sizeof_stat;
        int stat_offset;
 };

-#define NETXEN_NIC_STAT(m) sizeof(((struct netxen_adapter *)0)->m), \
+#define NETXEN_NIC_STAT(m)     NETXEN_STATS, \
+                       sizeof(((struct netxen_adapter *)0)->m), \
                        offsetof(struct netxen_adapter, m)

+#define NETXEN_NETDEV_STAT(m)  NETDEV_STATS, \
+                       sizeof(((struct rtnl_link_stats64 *)0)->m), \
+                       offsetof(struct rtnl_link_stats64, m)
+
 #define NETXEN_NIC_PORT_WINDOW 0x10000
 #define NETXEN_NIC_INVALID_DATA 0xDEADBEEF

 static const struct netxen_nic_stats netxen_nic_gstrings_stats[] = {
        {"xmit_called", NETXEN_NIC_STAT(stats.xmitcalled)},
        {"xmit_finished", NETXEN_NIC_STAT(stats.xmitfinished)},
-       {"rx_dropped", NETXEN_NIC_STAT(stats.rxdropped)},
+       {"rx_dropped", NETXEN_NETDEV_STAT(rx_dropped)},
        {"tx_dropped", NETXEN_NIC_STAT(stats.txdropped)},
        {"csummed", NETXEN_NIC_STAT(stats.csummed)},
        {"rx_pkts", NETXEN_NIC_STAT(stats.rx_pkts)},
@@ -679,11 +687,27 @@ netxen_nic_get_ethtool_stats(struct net_device *dev,
 {
        struct netxen_adapter *adapter = netdev_priv(dev);
        int index;
+       struct rtnl_link_stats64 temp;
+       const struct rtnl_link_stats64 *net_stats;
+       char *p = NULL;

+       net_stats = dev_get_stats(dev, &temp);
        for (index = 0; index < NETXEN_NIC_STATS_LEN; index++) {
-               char *p =
-                   (char *)adapter +
-                   netxen_nic_gstrings_stats[index].stat_offset;
+
+               switch (netxen_nic_gstrings_stats[index].type) {
+               case NETDEV_STATS:
+                       p = (char *)net_stats +
+                               netxen_nic_gstrings_stats[index].stat_offset;
+                       break;
+               case NETXEN_STATS:
+                       p = (char *)adapter +
+                               netxen_nic_gstrings_stats[index].stat_offset;
+                       break;
+               default:
+                       data[index] = 0;
+                       continue;
+               }
+
                data[index] =
                    (netxen_nic_gstrings_stats[index].sizeof_stat ==
                     sizeof(u64)) ? *(u64 *) p : *(u32 *) p;
-- 1.7.1
