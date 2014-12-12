Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbaLLGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:16:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51688 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757942AbaLLGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>,
        "hujianyang" <hujianyang@huawei.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.918431290@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 004/164] UBIFS: fix free log space calculation
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -110,10 +110,14 @@ static inline long long empty_log_bytes(
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

