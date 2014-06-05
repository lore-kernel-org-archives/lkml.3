Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaFEEWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaFEEWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YanBo <dreamfly281@gmail.com>, Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 201/214] cfg80211: check wdev->netdev in connection work
Date: Wed,  4 Jun 2014 21:19:24 -0700
Message-Id: <20140605041706.467767106@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/sme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -222,6 +222,9 @@ void cfg80211_conn_work(struct work_stru
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);


