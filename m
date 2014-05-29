Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbaE2OPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:15:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59371 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933228AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/103] fs: Don't return 0 from get_anon_bdev
Date: Thu, 29 May 2014 15:48:36 +0200
Message-Id: <c36604fe10ee69babe452bf5f888185ef163cd39.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Bächler <thomas@archlinux.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a2a4dc494a7b7135f460e38e788c4a58f65e4ac3 upstream.

Commit 9e30cc9595303b27b48 removed an internal mount. This
has the side-effect that rootfs now has FSID 0. Many
userspace utilities assume that st_dev in struct stat
is never 0, so this change breaks a number of tools in
early userspace.

Since we don't know how many userspace programs are affected,
make sure that FSID is at least 1.

References: http://article.gmane.org/gmane.linux.kernel/1666905
References: http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/8557
Signed-off-by: Thomas Bächler <thomas@archlinux.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 0225c20f8770..d127de207376 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -845,7 +845,10 @@ void emergency_remount(void)
 
 static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
-static int unnamed_dev_start = 0; /* don't bother trying below it */
+/* Many userspace utilities consider an FSID of 0 invalid.
+ * Always return at least 1 from get_anon_bdev.
+ */
+static int unnamed_dev_start = 1;
 
 int get_anon_bdev(dev_t *p)
 {
-- 
1.9.3

