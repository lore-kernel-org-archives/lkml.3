Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaD0RO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:14:58 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48085 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbaD0RIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:23 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Liang Zhen <liang.zhen@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 32/47] staging/lustre/lnet: NI shutdown may loop forever
Date: Sun, 27 Apr 2014 13:06:56 -0400
Message-Id: <1398618431-29757-33-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Zhen <liang.zhen@intel.com>

lnet_shutdown_lndnis() may enter endless loop if there is a busy NI,
this is injected by LNet SMP improvements. It's fixed in this patch.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-on: http://review.whamcloud.com/9706
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4780
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/lnet/api-ni.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index f5a9ae3..3f1fdaa 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -986,12 +986,11 @@ lnet_shutdown_lndnis (void)
 			break;
 		}
 
-		while (!list_empty(&ni->ni_list)) {
+		if (!list_empty(&ni->ni_list)) {
 			lnet_net_unlock(LNET_LOCK_EX);
 			++i;
 			if ((i & (-i)) == i) {
-				CDEBUG(D_WARNING,
-				       "Waiting for zombie LNI %s\n",
+				CDEBUG(D_WARNING, "Waiting for zombie LNI %s\n",
 				       libcfs_nid2str(ni->ni_nid));
 			}
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1016,6 +1015,8 @@ lnet_shutdown_lndnis (void)
 			       libcfs_nid2str(ni->ni_nid));
 
 		lnet_ni_free(ni);
+		i = 2;
+
 		lnet_net_lock(LNET_LOCK_EX);
 	}
 
-- 
1.8.5.3

