Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaKYLir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:38:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaKYKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 088/254] UBIFS: fix free log space calculation
Date: Tue, 25 Nov 2014 10:37:18 +0000
Message-Id: <1416912004-5928-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index 3edc4a3dcca3..8d59de86dc9a 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -106,10 +106,14 @@ static inline long long empty_log_bytes(const struct ubifs_info *c)
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
2.1.0

