Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3GXC10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:27:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3GXC1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:27:24 -0400
X-IronPort-AV: E=Sophos;i="4.89,731,1367942400"; 
   d="scan'208";a="7999482"
Message-ID: <51EF3AB0.6030808@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 10:23:44 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/bio-integrity: fix a potential mem leak
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 10:25:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 10:25:21,
	Serialize complete at 2013/07/24 10:25:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free the bio_integrity_pool in the fail path of biovec_create_pool
in function bioset_integrity_create().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/bio-integrity.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8fb4291..6025084 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -716,13 +716,14 @@ int bioset_integrity_create(struct bio_set *bs, int pool_size)
 		return 0;
 
 	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size, bip_slab);
-
-	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
-	if (!bs->bvec_integrity_pool)
+	if (!bs->bio_integrity_pool)
 		return -1;
 
-	if (!bs->bio_integrity_pool)
+	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
+	if (!bs->bvec_integrity_pool) {
+		mempool_destroy(bs->bio_integrity_pool);
 		return -1;
+	}
 
 	return 0;
 }
-- 
1.7.7

