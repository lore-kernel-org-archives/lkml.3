Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3FPW3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:29:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab3FPWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "YanBo" <dreamfly281@gmail.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.236794162@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/83] cfg80211: check wdev->netdev in connection work
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit c815797663b72e3ac1736f1886538152bc48e4af upstream.

If a P2P-Device is present and another virtual interface triggers
the connection work, the system crash because it tries to check
if the P2P-Device's netdev (which doesn't exist) is up. Skip any
wdevs that have no netdev to fix this.

Reported-by: YanBo <dreamfly281@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/sme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -220,6 +220,9 @@ void cfg80211_conn_work(struct work_stru
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);

