Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaD0RIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:02 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48015 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbaD0RH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:58 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Peng Tao <bergwolf@gmail.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 17/47] staging/lustre/hsm: count NULL terminator in hai_zero/hal_size
Date: Sun, 27 Apr 2014 13:06:41 -0400
Message-Id: <1398618431-29757-18-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

If fsname is 8-byte aligned, hai_zero fails to count the ending NULL
terminator causing hai to directly attached after fsname and future
hai_zero will return a different position for first hai.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Reviewed-on: http://review.whamcloud.com/9431
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4689
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre/lustre_user.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index f5f369e..95c754f 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1106,7 +1106,8 @@ static inline struct hsm_action_item * hai_zero(struct hsm_action_list *hal)
 {
 	return (struct hsm_action_item *)(hal->hal_fsname +
 					  cfs_size_round(strlen(hal-> \
-								hal_fsname)));
+								hal_fsname)
+							 + 1));
 }
 /* Return pointer to next hai */
 static inline struct hsm_action_item * hai_next(struct hsm_action_item *hai)
@@ -1121,7 +1122,7 @@ static inline int hal_size(struct hsm_action_list *hal)
 	int i, sz;
 	struct hsm_action_item *hai;
 
-	sz = sizeof(*hal) + cfs_size_round(strlen(hal->hal_fsname));
+	sz = sizeof(*hal) + cfs_size_round(strlen(hal->hal_fsname) + 1);
 	hai = hai_zero(hal);
 	for (i = 0; i < hal->hal_count; i++, hai = hai_next(hai))
 		sz += cfs_size_round(hai->hai_len);
-- 
1.8.5.3

