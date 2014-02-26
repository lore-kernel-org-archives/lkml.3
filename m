Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBZSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:08:00 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:24238 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbaBZSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:07:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcGABEtDlNXQ4FW/2dsb2JhbABagwbCA4EZF3SCVRMcIxiBAiQTh30ByTMXjgdNhD4EmDUBilKHVoMuO4Et
Date: Wed, 26 Feb 2014 19:07:56 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: swhiteho <swhiteho@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/gfs2/quota.c: replace kmalloc - __vmalloc / memset 0
Message-Id: <20140226190756.f2f898b9210e6e4cf48f60f7@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc and __vmalloc __GFP_ZERO for clean sd_quota_bitmap allocation.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/quota.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8bec0e31..1ee4b88 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1242,14 +1242,13 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 	bm_size = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * sizeof(unsigned long));
 	bm_size *= sizeof(unsigned long);
 	error = -ENOMEM;
-	sdp->sd_quota_bitmap = kmalloc(bm_size, GFP_NOFS|__GFP_NOWARN);
+	sdp->sd_quota_bitmap = kzalloc(bm_size, GFP_NOFS | __GFP_NOWARN);
 	if (sdp->sd_quota_bitmap == NULL)
-		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
+		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS |
+						 __GFP_ZERO, PAGE_KERNEL);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
-	memset(sdp->sd_quota_bitmap, 0, bm_size);
-
 	for (x = 0; x < blocks; x++) {
 		struct buffer_head *bh;
 		const struct gfs2_quota_change *qc;
-- 
1.8.1.4

