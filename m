Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaJQNYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:24:41 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33712 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaJQNYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:24:40 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] fs: make generic_block_fiemap sig-tolerant
Date: Fri, 17 Oct 2014 17:24:29 +0400
Message-Id: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__generic_block_fiemap may spin very long time for large sparse files.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ioctl.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..6fbeb68 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
 				past_eof = true;
 		}
 		cond_resched();
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
 	} while (1);
 
 	/* If ret is 1 then we just hit the end of the extent array */
-- 
1.7.1

