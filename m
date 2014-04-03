Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaDCTzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:55:51 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:48161 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaDCTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:55:48 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 15:55:48 EDT
From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
To: tj@kernel.org
Cc: d@falconindy.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        "3.14" <stable@vger.kernel.org>
Subject: [PATCHv2] fs: Don't return 0 from get_anon_bdev
Date: Thu,  3 Apr 2014 21:55:37 +0200
Message-Id: <1396554937-11952-1-git-send-email-thomas@archlinux.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140403195154.GD2472@mtj.dyndns.org>
References: <20140403195154.GD2472@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e30cc9595303b27b48 removed an internal mount. This
has the side-effect that rootfs now has FSID 0. Many
userspace utilities assume that st_dev in struct stat
is never 0, so this change breaks a number of tools in
early userspace.

Since we don't know how many userspace programs are affected,
make sure that FSID is at least 1.

References: http://article.gmane.org/gmane.linux.kernel/1666905
References: http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/8557
Cc: 3.14 <stable@vger.kernel.org>
Signed-off-by: Thomas Bächler <thomas@archlinux.org>
---
 fs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 80d5cf2..7624267 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -802,7 +802,10 @@ void emergency_remount(void)
 
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
1.9.1

