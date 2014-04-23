Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaDWV4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:56:47 -0400
Received: from mout.gmx.net ([212.227.17.20]:53961 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaDWV4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:56:46 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fanotify: for FAN_MARK_FLUSH check flags
Date: Wed, 23 Apr 2014 23:55:51 +0200
Message-Id: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.9.2
X-Provags-ID: V03:K0:Cj2Q/xunml2Ia+c6jmhAl4MEiRUEtLCExPC6otPxMQbDgSpCDri
 ELF/yMPlyZ+SfR3SKlnUpxzbb07sVdQqrBG+7qo2+E7VaIUkYwo4DVlH7c6YpFCiTKeNNzm
 3iLk7Q1oeua873CdQ5bpwZ6uKLU95oFwRN83DysA1eZFVC70VZ7tpQhU1bIBkPQUdvMtL8G
 jijfbaTtZAmAmDo9ehsjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fanotify_mark is called with illegal value of arguments flags and marks
it usually returns EINVAL.

When fanotify_mark is called with FAN_MARK_FLUSH the argument flags is not
checked for irrelevant flags like FAN_MARK_IGNORED_MASK.

The patch removes this inconsistency.

If an irrelevant flag is set error EINVAL is returned.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 287a22c..8bba549 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -819,7 +819,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 	case FAN_MARK_REMOVE:
 		if (!mask)
 			return -EINVAL;
+		break;
 	case FAN_MARK_FLUSH:
+		if (flags & ~(FAN_MARK_MOUNT | FAN_MARK_FLUSH))
+			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.2

