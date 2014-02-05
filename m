Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaBEUI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:55629 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaBEUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Zach Brown <zab@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 198/213] fuse: verify all ioctl retry iov elements
Date: Wed, 5 Feb 2014 15:02:33 -0500
Message-ID: <1391630568-49251-199-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fb6ccff667712c46b4501b920ea73a326e49626a upstream.

Commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 attempted to verify that
the total iovec from the client doesn't overflow iov_length() but it
only checked the first element.  The iovec could still overflow by
starting with a small element.  The obvious fix is to check all the
elements.

The overflow case doesn't look dangerous to the kernel as the copy is
limited by the length after the overflow.  This fix restores the
intention of returning an error instead of successfully copying less
than the iovec represented.

I found this by code inspection.  I built it but don't have a test case.
I'm cc:ing stable because the initial commit did as well.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f6104a958812..102d58297174 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1664,7 +1664,7 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
 	size_t n;
 	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
 
-	for (n = 0; n < count; n++) {
+	for (n = 0; n < count; n++, iov++) {
 		if (iov->iov_len > (size_t) max)
 			return -ENOMEM;
 		max -= iov->iov_len;
-- 
1.8.5.2

