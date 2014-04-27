Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaD0RNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:13:46 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48119 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaD0RIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:32 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bob Glossman <bob.glossman@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 38/47] staging/lustre/lloop: avoid panic during blockdev_info
Date: Sun, 27 Apr 2014 13:07:02 -0400
Message-Id: <1398618431-29757-39-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Glossman <bob.glossman@intel.com>

Change the LL_IOC_LLOOP_INFO ioctl in the lustre lloop
device driver to return an error instead of causing
panics with LASSERT().

Signed-off-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-on: http://review.whamcloud.com/9888
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4863
Reviewed-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/lloop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index f78eda2..437adaf 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -624,7 +624,10 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	case LL_IOC_LLOOP_INFO: {
 		struct lu_fid fid;
 
-		LASSERT(lo->lo_backing_file != NULL);
+		if (lo->lo_backing_file == NULL) {
+			err = -ENOENT;
+			break;
+		}
 		if (inode == NULL)
 			inode = lo->lo_backing_file->f_dentry->d_inode;
 		if (lo->lo_state == LLOOP_BOUND)
-- 
1.8.5.3

