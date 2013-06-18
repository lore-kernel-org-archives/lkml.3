Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3FRMOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:14:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3FRLnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:43:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 03/93] cfg80211: check wdev->netdev in connection work
Date: Tue, 18 Jun 2013 12:42:11 +0100
Message-Id: <1371555821-12820-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit c815797663b72e3ac1736f1886538152bc48e4af upstream.

If a P2P-Device is present and another virtual interface triggers
the connection work, the system crash because it tries to check
if the P2P-Device's netdev (which doesn't exist) is up. Skip any
wdevs that have no netdev to fix this.

Reported-by: YanBo <dreamfly281@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backport to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/sme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f7e937f..3fd50a1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -222,6 +222,9 @@ void cfg80211_conn_work(struct work_struct *work)
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
-- 
1.8.1.2

