Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3EFVO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:14:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab3EFUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 019/115] mac80211: fix station entry leak/warning while suspending
Date: Mon,  6 May 2013 13:44:15 -0700
Message-Id: <20130506203057.547533893@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b20d34c458bc2bbd0a4624f2933581e01e72d875 upstream.

Since Stanislaw's patches, when suspending while connected,
cfg80211 will disconnect. This causes the AP station to be
removed, which uses call_rcu() to clean up. Due to needing
process context, this queues a work struct on the mac80211
workqueue. This will warn and fail when already suspended,
which can happen if the rcu call doesn't happen quickly.

To fix this, replace the synchronize_net() which is really
just synchronize_rcu_expedited() with rcu_barrier(), which
unlike synchronize_rcu() waits until RCU callback have run
and thus avoids this issue.

In theory, this can even happen without Stanislaw's change
to disconnect on suspend since userspace might disconnect
just before suspending, though then it's unlikely that the
call_rcu() will be delayed long enough.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -53,8 +53,8 @@ int __ieee80211_suspend(struct ieee80211
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-	/* flush out all packets */
-	synchronize_net();
+	/* flush out all packets and station cleanup call_rcu()s */
+	rcu_barrier();
 
 	drv_flush(local, false);
 


