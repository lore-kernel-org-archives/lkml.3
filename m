Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3B0GI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:08:56 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59371 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab3B0GIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:09 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Charndeep Grewal <csgrewa@tycho.ncsc.mil>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5/5] staging: android: logger: enforce GID and CAP check on log flush
Date: Tue, 26 Feb 2013 22:07:38 -0800
Message-Id: <1361945258-24420-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charndeep Grewal <csgrewa@tycho.ncsc.mil>

Restrict log flushing to those in the logs group, or
anyone with CAP_SYSLOG.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Charndeep Grewal <csgrewa@tycho.ncsc.mil>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Charndeep Grewal <csgrewa@tycho.ncsc.mil>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/logger.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index cfa6061..b14a557 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -695,6 +695,11 @@ static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			ret = -EBADF;
 			break;
 		}
+		if (!(in_egroup_p(file->f_dentry->d_inode->i_gid) ||
+				capable(CAP_SYSLOG))) {
+			ret = -EPERM;
+			break;
+		}
 		list_for_each_entry(reader, &log->readers, list)
 			reader->r_off = log->w_off;
 		log->head = log->w_off;
-- 
1.7.10.4

