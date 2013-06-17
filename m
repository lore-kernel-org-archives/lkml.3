Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab3FQKMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:12:47 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:49220 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277Ab3FQKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:12:45 -0400
Message-ID: <1371463963.26299.9.camel@x61.thuisdomein>
Subject: [PATCH] rbd: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@inktank.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 12:12:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jun 2013 10:12:43.0664 (UTC) FILETIME=[35023100:01CE6B43]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building rbd.o triggers two GCC warnings:
    drivers/block/rbd.c: In function ‘rbd_img_request_fill’:
    drivers/block/rbd.c:1272:22: warning: ‘bio_list’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/block/rbd.c:2170:14: note: ‘bio_list’ was declared here
    drivers/block/rbd.c:2231:10: warning: ‘pages’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Apparently GCC has trouble determining that "bio_list" is unused if "type"
is "OBJ_REQUEST_PAGES" and, conversely, that "pages" will be unused if
"type" is "OBJ_REQUEST_BIO". Add harmless initializations to NULL to
help GCC.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) These warnings were introduced in v3.10-rc1, apparently through
commit f1a4739f33 ("rbd: support page array image requests"). 

2) Note that
    rbd_assert(type == OBJ_REQUEST_PAGES);

seems redundant. I see no way that this assertion could ever be false. 

 drivers/block/rbd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3063452..b8a58178 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2185,9 +2185,11 @@ static int rbd_img_request_fill(struct rbd_img_request *img_request,
 	if (type == OBJ_REQUEST_BIO) {
 		bio_list = data_desc;
 		rbd_assert(img_offset == bio_list->bi_sector << SECTOR_SHIFT);
+		pages = NULL;
 	} else {
 		rbd_assert(type == OBJ_REQUEST_PAGES);
 		pages = data_desc;
+		bio_list = NULL;
 	}
 
 	while (resid) {
-- 
1.8.1.4

