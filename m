Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3LRVNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3LRVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 056/118] mac80211: fix scheduled scan rtnl deadlock
Date: Wed, 18 Dec 2013 13:11:33 -0800
Message-Id: <20131218211221.050070790@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 18db594a1005d908d995a2fc8f5a7bf4286fdca0 upstream.

When changing cfg80211 to use RTNL locking, this caused a
deadlock in mac80211 as it calls cfg80211_sched_scan_stopped()
from a work item that's on a workqueue that is flushed with
the RTNL held.

Fix this by simply using schedule_work(), the work only needs
to finish running before the wiphy is unregistered, no other
synchronisation (e.g. with suspend) is really required since
for suspend userspace is already blocked anyway when we flush
the workqueue so will only pick up the event after resume.

Fixes: 5fe231e87372 ("cfg80211: vastly simplify locking")
Reported-and-tested-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/main.c |    1 +
 net/mac80211/scan.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1047,6 +1047,7 @@ void ieee80211_unregister_hw(struct ieee
 
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
+	flush_work(&local->sched_scan_stopped_work);
 
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1089,6 +1089,6 @@ void ieee80211_sched_scan_stopped(struct
 
 	trace_api_sched_scan_stopped(local);
 
-	ieee80211_queue_work(&local->hw, &local->sched_scan_stopped_work);
+	schedule_work(&local->sched_scan_stopped_work);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_stopped);


