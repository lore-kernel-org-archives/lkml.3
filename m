Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3DWPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:21:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52294 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3DWPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:21:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] libcxgbi: supress warning when we request to much space from kmalloc
Date: Tue, 23 Apr 2013 11:20:47 -0400
Message-Id: <1366730447-32428-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cxgbi_alloc_big_mem allocates large chunks of memory, and can occasionally
request amounts from kmalloc that exceed the allocators capacity.  This
typically leads to a stack trace from the zoned buddy allocator in the message
log.  But if kmalloc fails, cxgbi_alloc_big_mem backs off and uses vmalloc
instead.  Given that, and the fact that the two calls sites have their own error
messages if both kmalloc and vmalloc fail, I think the stack trace printing
isn't really needed.

Modify the call to kmalloc to pass __GFP_NOWARN in as well, so that internal
kmalloc warnings are suppressed.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Honggang LI <honli@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/cxgbi/libcxgbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 80fa99b..3daf996 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -658,7 +658,7 @@ static inline u32 cxgbi_tag_nonrsvd_bits(struct cxgbi_tag_format *tformat,
 static inline void *cxgbi_alloc_big_mem(unsigned int size,
 					gfp_t gfp)
 {
-	void *p = kmalloc(size, gfp);
+	void *p = kmalloc(size, gfp | __GFP_NOWARN);
 	if (!p)
 		p = vmalloc(size);
 	if (p)
-- 
1.8.1.4

