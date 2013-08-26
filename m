Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3HZJp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:45:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:1994 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3HZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:45:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,957,1367996400"; 
   d="scan'208";a="286783644"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, "Ed L. Cashin" <ecashin@coraid.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] aoe: suppress compiler warnings
Date: Mon, 26 Aug 2013 12:45:28 +0300
Message-Id: <1377510328-25939-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compiler warnings:

drivers/block/aoe/aoecmd.c: In function ‘aoecmd_ata_rw’:
drivers/block/aoe/aoecmd.c:383:17: warning: variable ‘t’ set but not used [-Wunused-but-set-variable]
  struct aoetgt *t;
                 ^
drivers/block/aoe/aoecmd.c: In function ‘resend’:
drivers/block/aoe/aoecmd.c:488:21: warning: variable ‘ah’ set but not used [-Wunused-but-set-variable]
  struct aoe_atahdr *ah;
                     ^
drivers/block/aoe/aoedev.c: In function 'user_req':
drivers/block/aoe/aoedev.c:252:174: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
                                                               ^

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/block/aoe/aoecmd.c | 4 ----
 drivers/block/aoe/aoedev.c | 3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 4d45dba..d251543 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -380,7 +380,6 @@ aoecmd_ata_rw(struct aoedev *d)
 {
 	struct frame *f;
 	struct buf *buf;
-	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	ulong bcnt, fbcnt;
@@ -391,7 +390,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	f = newframe(d);
 	if (f == NULL)
 		return 0;
-	t = *d->tgt;
 	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
@@ -485,7 +483,6 @@ resend(struct aoedev *d, struct frame *f)
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	struct aoetgt *t;
 	char buf[128];
 	u32 n;
@@ -500,7 +497,6 @@ resend(struct aoedev *d, struct frame *f)
 		return;
 	}
 	h = (struct aoe_hdr *) skb_mac_header(skb);
-	ah = (struct aoe_atahdr *) (h+1);
 
 	if (!(f->flags & FFL_PROBE)) {
 		snprintf(buf, sizeof(buf),
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 6f68095..29dcea3 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -249,7 +249,8 @@ user_req(char *s, size_t slen, struct aoedev *d)
 	if (!d->gd)
 		return 0;
 	p = kbasename(d->gd->disk_name);
-	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
+	lim = min_t(size_t, sizeof(d->gd->disk_name) - (p - d->gd->disk_name),
+		slen);
 
 	return !strncmp(s, p, lim);
 }
-- 
1.8.4.rc3

