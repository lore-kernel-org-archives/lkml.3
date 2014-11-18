Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaKRPMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:12:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaKROJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:34 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/206] UBIFS: fix free log space calculation
Date: Tue, 18 Nov 2014 15:06:59 +0100
Message-Id: <4f111bbc16e4d6c657c8f53f50d7a9cfa7f37e4f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ubifs/log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index be67120fb919..06649d21b056 100644
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
2.1.3

