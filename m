Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaD0RMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:12:53 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48126 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaD0RIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:35 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ryan Haasken <haasken@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 37/47] staging/lustre/llite: Do not rate limit dirty page discard warning
Date: Sun, 27 Apr 2014 13:07:01 -0400
Message-Id: <1398618431-29757-38-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Haasken <haasken@cray.com>

Messages which are printed by ll_dirty_page_discard_warn() should not
be rate limited.  If they are rate limited, some files which may be
corrupted on client eviction will not be reported to the user.

This patch changes the CWARN to a CDEBUG to disable console message
rate limiting for this message.  The dirty page discard warnings are
already limited on a per-file basis by the function vvp_vmpage_error
which calls ll_dirty_page_discard_warn only if the ccc_object's
cob_discard_page_warned == 0.

Signed-off-by: Ryan Haasken <haasken@cray.com>
Reviewed-on: http://review.whamcloud.com/9752
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4799
Reviewed-by: Cory Spitz <spitzcor@cray.com>
Reviewed-by: Ann Koehler <amk@cray.com>
Reviewed-by: Chris Horn <hornc@cray.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 34df5d9..dbb1413 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -2456,11 +2456,12 @@ void ll_dirty_page_discard_warn(struct page *page, int ioret)
 			path = ll_d_path(dentry, buf, PAGE_SIZE);
 	}
 
-	CWARN("%s: dirty page discard: %s/fid: "DFID"/%s may get corrupted "
-	      "(rc %d)\n", ll_get_fsname(page->mapping->host->i_sb, NULL, 0),
-	      s2lsi(page->mapping->host->i_sb)->lsi_lmd->lmd_dev,
-	      PFID(&obj->cob_header.coh_lu.loh_fid),
-	      (path && !IS_ERR(path)) ? path : "", ioret);
+	CDEBUG(D_WARNING,
+	       "%s: dirty page discard: %s/fid: "DFID"/%s may get corrupted "
+	       "(rc %d)\n", ll_get_fsname(page->mapping->host->i_sb, NULL, 0),
+	       s2lsi(page->mapping->host->i_sb)->lsi_lmd->lmd_dev,
+	       PFID(&obj->cob_header.coh_lu.loh_fid),
+	       (path && !IS_ERR(path)) ? path : "", ioret);
 
 	if (dentry != NULL)
 		dput(dentry);
-- 
1.8.5.3

