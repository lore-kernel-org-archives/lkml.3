Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaF1Rsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:48:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaF1Rsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 67/77] Btrfs: mark mapping with error flag to report errors to userspace
Date: Sat, 28 Jun 2014 10:47:00 -0700
Message-Id: <20140628174525.121978414@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 5dca6eea91653e9949ce6eb9e9acab6277e2f2c4 upstream.

According to commit 865ffef3797da2cac85b3354b5b6050dc9660978
(fs: fix fsync() error reporting),
it's not stable to just check error pages because pages can be
truncated or invalidated, we should also mark mapping with error
flag so that a later fsync can catch the error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2371,6 +2371,8 @@ int end_extent_writepage(struct page *pa
 	if (!uptodate) {
 		ClearPageUptodate(page);
 		SetPageError(page);
+		ret = ret < 0 ? ret : -EIO;
+		mapping_set_error(page->mapping, ret);
 	}
 	return 0;
 }


