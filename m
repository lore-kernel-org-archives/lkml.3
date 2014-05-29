Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbaE2F2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:28:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbaE2EfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Alexandre Demers <alexandre.f.demers@gmail.com>
Subject: [PATCH 3.14 053/140] fs: Dont return 0 from get_anon_bdev
Date: Wed, 28 May 2014 21:33:12 -0700
Message-Id: <20140529043056.256883830@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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


