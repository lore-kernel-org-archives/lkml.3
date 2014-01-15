Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaAOWmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:42:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaAOVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 005/166] mac80211: fix scheduled scan rtnl deadlock
Date: Wed, 15 Jan 2014 13:50:19 -0800
Message-Id: <1389822780-4729-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/main.c | 1 +
 net/mac80211/scan.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1b087ff..e93d39d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1104,6 +1104,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
+	flush_work(&local->sched_scan_stopped_work);
 
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8d6ba43..49b5681 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1049,6 +1049,6 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 
 	trace_api_sched_scan_stopped(local);
 
-	ieee80211_queue_work(&local->hw, &local->sched_scan_stopped_work);
+	schedule_work(&local->sched_scan_stopped_work);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_stopped);
-- 
1.8.3.2

