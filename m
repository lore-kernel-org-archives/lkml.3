Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbaCEOZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbaCEOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/131] jbd2: fix use after free in jbd2_journal_start_reserved()
Date: Wed,  5 Mar 2014 14:22:50 +0000
Message-Id: <1394029455-23128-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 92e3b40537707001d17bbad800d150ab04e53bf4 upstream.

If start_this_handle() fails then it leads to a use after free of
"handle".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index b0b74e5..7272cc6 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -514,11 +514,13 @@ int jbd2_journal_start_reserved(handle_t *handle, unsigned int type,
 	 * similarly constrained call sites
 	 */
 	ret = start_this_handle(journal, handle, GFP_NOFS);
-	if (ret < 0)
+	if (ret < 0) {
 		jbd2_journal_free_reserved(handle);
+		return ret;
+	}
 	handle->h_type = type;
 	handle->h_line_no = line_no;
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(jbd2_journal_start_reserved);
 
-- 
1.9.0

