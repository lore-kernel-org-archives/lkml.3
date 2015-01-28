Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbbA1Fe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:34:28 -0500
Received: from mail.kernel.org ([198.145.29.136]:36670 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759403AbbA1ENf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 004/177] UBIFS: fix free log space calculation
Date: Wed, 28 Jan 2015 12:06:14 +0800
Message-Id: <1422418236-12852-7-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit ba29e721eb2df6df8f33c1f248388bb037a47914 upstream.

Hu (hujianyang <hujianyang@huawei.com>) discovered an issue in the
'empty_log_bytes()' function, which calculates how many bytes are left in the
log:

"
If 'c->lhead_lnum + 1 == c->ltail_lnum' and 'c->lhead_offs == c->leb_size', 'h'
would equalent to 't' and 'empty_log_bytes()' would return 'c->log_bytes'
instead of 0.
"

At this point it is not clear what would be the consequences of this, and
whether this may lead to any problems, but this patch addresses the issue just
in case.

Tested-by: hujianyang <hujianyang@huawei.com>
Reported-by: hujianyang <hujianyang@huawei.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ubifs/log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index 7ed9a37..843beda 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -110,10 +110,14 @@ static inline long long empty_log_bytes(const struct ubifs_info *c)
 	h = (long long)c->lhead_lnum * c->leb_size + c->lhead_offs;
 	t = (long long)c->ltail_lnum * c->leb_size;
 
-	if (h >= t)
+	if (h > t)
 		return c->log_bytes - h + t;
-	else
+	else if (h != t)
 		return t - h;
+	else if (c->lhead_lnum != c->ltail_lnum)
+		return 0;
+	else
+		return c->log_bytes;
 }
 
 /**
-- 
1.9.1

