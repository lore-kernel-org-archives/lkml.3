Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaF1Rxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaF1Rx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 131/139] btrfs: fix use of uninit "ret" in end_extent_writepage()
Date: Sat, 28 Jun 2014 10:48:12 -0700
Message-Id: <20140628174611.388170386@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 3e2426bd0eb980648449e7a2f5a23e3cd3c7725c upstream.

If this condition in end_extent_writepage() is false:

	if (tree->ops && tree->ops->writepage_end_io_hook)

we will then test an uninitialized "ret" at:

	ret = ret < 0 ? ret : -EIO;

The test for ret is for the case where ->writepage_end_io_hook
failed, and we'd choose that ret as the error; but if
there is no ->writepage_end_io_hook, nothing sets ret.

Initializing ret to 0 should be sufficient; if
writepage_end_io_hook wasn't set, (!uptodate) means
non-zero err was passed in, so we choose -EIO in that case.

Signed-of-by: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2354,7 +2354,7 @@ int end_extent_writepage(struct page *pa
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
-	int ret;
+	int ret = 0;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 


