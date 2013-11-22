Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3KVHye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:54:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:53116 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KVHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:54:32 -0500
Message-ID: <528F0DB8.7020604@windriver.com>
Date: Fri, 22 Nov 2013 15:54:32 +0800
From: yzhu1 <Yanjun.Zhu@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        zhuyj <zyjzyj2000@gmail.com>
Subject: [PATCH 1/1] e1000: prevent oops when adapter is being closed and
 reset simultaneously
Content-Type: multipart/mixed;
	boundary="------------060303040403000205030505"
X-Originating-IP: [128.224.162.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060303040403000205030505
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hi, maintainers

This change is based on a similar change made to e1000e support in
commit bb9e44d0d0f4 ("e1000e: prevent oops when adapter is being closed
and reset simultaneously").  The same issue has also been observed
on the older e1000 cards.

Here, we have increased the RESET_COUNT value to 50 because there are too
many accesses to e1000 nic on stress tests to e1000 nic, it is not enough
to set RESET_COUT 25. Experimentation has shown that it is enough to set
RESET_COUNT 50.

Please help me to merge this patch. Thanks a lot.

Zhu Yanjun

--------------060303040403000205030505
Content-Type: text/x-patch;
	name="0001-e1000-prevent-oops-when-adapter-is-being-closed-and-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-e1000-prevent-oops-when-adapter-is-being-closed-and-.pa";
	filename*1="tch"

>From 54e9e48a9f878eb45f0cc6322415244d7a9f1598 Mon Sep 17 00:00:00 2001
From: yzhu1 <yanjun.zhu@windriver.com>
Date: Fri, 22 Nov 2013 15:46:48 +0800
Subject: [PATCH 1/1] e1000: prevent oops when adapter is being closed and
 reset simultaneously

This change is based on a similar change made to e1000e support in
commit bb9e44d0d0f4 ("e1000e: prevent oops when adapter is being closed
and reset simultaneously").  The same issue has also been observed
on the older e1000 cards.

Here, we have increased the RESET_COUNT value to 50 because there are too
many accesses to e1000 nic on stress tests to e1000 nic, it is not enough
to set RESET_COUT 25. Experimentation has shown that it is enough to set
RESET_COUNT 50.

Signed-off-by: yzhu1 <yanjun.zhu@windriver.com>
---
 drivers/net/ethernet/intel/e1000/e1000.h      |    5 +++++
 drivers/net/ethernet/intel/e1000/e1000_main.c |    9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 58c1472..0af4a8e 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -83,6 +83,11 @@ struct e1000_adapter;
 
 #define E1000_MAX_INTR			10
 
+/*
+ * Count for polling __E1000_RESET condition every 10-20msec.
+ */
+#define E1000_CHECK_RESET_COUNT         50
+
 /* TX/RX descriptor defines */
 #define E1000_DEFAULT_TXD		256
 #define E1000_MAX_TXD			256
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index e386228..c0f5217 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1440,6 +1440,10 @@ static int e1000_close(struct net_device *netdev)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	int count = E1000_CHECK_RESET_COUNT;
+
+	while (test_bit(__E1000_RESETTING, &adapter->flags) && count--)
+		usleep_range(10000, 20000);
 
 	WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
 	e1000_down(adapter);
@@ -4963,6 +4967,11 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 	netif_device_detach(netdev);
 
 	if (netif_running(netdev)) {
+		int count = E1000_CHECK_RESET_COUNT;
+
+		while (test_bit(__E1000_RESETTING, &adapter->flags) && count--)
+			usleep_range(10000, 20000);
+
 		WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
 		e1000_down(adapter);
 	}
-- 
1.7.9.5


--------------060303040403000205030505--
