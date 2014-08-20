Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaHTLyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:54:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58989 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vladimir Davydov <VDavydov@parallels.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Patrick McHardy <kaber@trash.net>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/104] e1000: fix possible reset_task running after adapter down
Date: Wed, 20 Aug 2014 13:43:38 +0200
Message-Id: <ef0e551d4c0bd15a4cc46dba73da8e7c38fc86d2.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Davydov <VDavydov@parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 74a1b1ea8a30b035aaad833bbd6b9263e72acfac upstream.

On e1000_down(), we should ensure every asynchronous work is canceled
before proceeding. Since the watchdog_task can schedule other works
apart from itself, it should be stopped first, but currently it is
stopped after the reset_task. This can result in the following race
leading to the reset_task running after the module unload:

e1000_down_and_stop():			e1000_watchdog():
----------------------			-----------------

cancel_work_sync(reset_task)
					schedule_work(reset_task)
cancel_delayed_work_sync(watchdog_task)

The patch moves cancel_delayed_work_sync(watchdog_task) at the beginning
of e1000_down_and_stop() thus ensuring the race is impossible.

Cc: Tushar Dave <tushar.n.dave@intel.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 4ca676cb7f04..15c85d4f3774 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -494,13 +494,20 @@ static void e1000_down_and_stop(struct e1000_adapter *adapter)
 {
 	set_bit(__E1000_DOWN, &adapter->flags);
 
-	/* Only kill reset task if adapter is not resetting */
-	if (!test_bit(__E1000_RESETTING, &adapter->flags))
-		cancel_work_sync(&adapter->reset_task);
-
 	cancel_delayed_work_sync(&adapter->watchdog_task);
+
+	/*
+	 * Since the watchdog task can reschedule other tasks, we should cancel
+	 * it first, otherwise we can run into the situation when a work is
+	 * still running after the adapter has been turned down.
+	 */
+
 	cancel_delayed_work_sync(&adapter->phy_info_task);
 	cancel_delayed_work_sync(&adapter->fifo_stall_task);
+
+	/* Only kill reset task if adapter is not resetting */
+	if (!test_bit(__E1000_RESETTING, &adapter->flags))
+		cancel_work_sync(&adapter->reset_task);
 }
 
 void e1000_down(struct e1000_adapter *adapter)
-- 
2.0.4

