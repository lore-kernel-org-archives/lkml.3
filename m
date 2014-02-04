Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaBDK1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:27:07 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37501 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbaBDK0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:26:33 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="99579774"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matt Rushton <mrushton@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: [PATCH v2 4/4] xen-blkif: drop struct blkif_request_segment_aligned
Date: Tue, 4 Feb 2014 11:26:15 +0100
Message-ID: <1391509575-3949-5-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was wrongly introduced in commit 402b27f9, the only difference
between blkif_request_segment_aligned and blkif_request_segment is
that the former has a named padding, while both share the same
memory layout.

Also correct a few minor glitches in the description, including for it
to no longer assume PAGE_SIZE == 4096.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
[Description fix by Jan Beulich]
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reported-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
---
 drivers/block/xen-blkback/blkback.c |    2 +-
 drivers/block/xen-blkback/common.h  |    2 +-
 drivers/block/xen-blkfront.c        |    6 +++---
 include/xen/interface/io/blkif.h    |   34 ++++++++++++++--------------------
 4 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 394fa2e..e612627 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -847,7 +847,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 	struct grant_page **pages = pending_req->indirect_pages;
 	struct xen_blkif *blkif = pending_req->blkif;
 	int indirect_grefs, rc, n, nseg, i;
-	struct blkif_request_segment_aligned *segments = NULL;
+	struct blkif_request_segment *segments = NULL;
 
 	nseg = pending_req->nr_pages;
 	indirect_grefs = INDIRECT_PAGES(nseg);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index e40326a..9eb34e2 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -57,7 +57,7 @@
 #define MAX_INDIRECT_SEGMENTS 256
 
 #define SEGS_PER_INDIRECT_FRAME \
-	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
+	(PAGE_SIZE/sizeof(struct blkif_request_segment))
 #define MAX_INDIRECT_PAGES \
 	((MAX_INDIRECT_SEGMENTS + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
 #define INDIRECT_PAGES(_segs) \
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c4a4c90..7d09dfc 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -162,7 +162,7 @@ static DEFINE_SPINLOCK(minor_lock);
 #define DEV_NAME	"xvd"	/* name in /dev */
 
 #define SEGS_PER_INDIRECT_FRAME \
-	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
+	(PAGE_SIZE/sizeof(struct blkif_request_segment))
 #define INDIRECT_GREFS(_segs) \
 	((_segs + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
 
@@ -393,7 +393,7 @@ static int blkif_queue_request(struct request *req)
 	unsigned long id;
 	unsigned int fsect, lsect;
 	int i, ref, n;
-	struct blkif_request_segment_aligned *segments = NULL;
+	struct blkif_request_segment *segments = NULL;
 
 	/*
 	 * Used to store if we are able to queue the request by just using
@@ -550,7 +550,7 @@ static int blkif_queue_request(struct request *req)
 			} else {
 				n = i % SEGS_PER_INDIRECT_FRAME;
 				segments[n] =
-					(struct blkif_request_segment_aligned) {
+					(struct blkif_request_segment) {
 							.gref       = ref,
 							.first_sect = fsect,
 							.last_sect  = lsect };
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ae665ac..32ec05a 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -113,13 +113,13 @@ typedef uint64_t blkif_sector_t;
  * it's less than the number provided by the backend. The indirect_grefs field
  * in blkif_request_indirect should be filled by the frontend with the
  * grant references of the pages that are holding the indirect segments.
- * This pages are filled with an array of blkif_request_segment_aligned
- * that hold the information about the segments. The number of indirect
- * pages to use is determined by the maximum number of segments
- * a indirect request contains. Every indirect page can contain a maximum
- * of 512 segments (PAGE_SIZE/sizeof(blkif_request_segment_aligned)),
- * so to calculate the number of indirect pages to use we have to do
- * ceil(indirect_segments/512).
+ * These pages are filled with an array of blkif_request_segment that hold the
+ * information about the segments. The number of indirect pages to use is
+ * determined by the number of segments an indirect request contains. Every
+ * indirect page can contain a maximum of
+ * (PAGE_SIZE / sizeof(struct blkif_request_segment)) segments, so to
+ * calculate the number of indirect pages to use we have to do
+ * ceil(indirect_segments / (PAGE_SIZE / sizeof(struct blkif_request_segment))).
  *
  * If a backend does not recognize BLKIF_OP_INDIRECT, it should *not*
  * create the "feature-max-indirect-segments" node!
@@ -135,13 +135,12 @@ typedef uint64_t blkif_sector_t;
 
 #define BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST 8
 
-struct blkif_request_segment_aligned {
-	grant_ref_t gref;        /* reference to I/O buffer frame        */
-	/* @first_sect: first sector in frame to transfer (inclusive).   */
-	/* @last_sect: last sector in frame to transfer (inclusive).     */
-	uint8_t     first_sect, last_sect;
-	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
-} __attribute__((__packed__));
+struct blkif_request_segment {
+		grant_ref_t gref;        /* reference to I/O buffer frame        */
+		/* @first_sect: first sector in frame to transfer (inclusive).   */
+		/* @last_sect: last sector in frame to transfer (inclusive).     */
+		uint8_t     first_sect, last_sect;
+};
 
 struct blkif_request_rw {
 	uint8_t        nr_segments;  /* number of segments                   */
@@ -151,12 +150,7 @@ struct blkif_request_rw {
 #endif
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
-	struct blkif_request_segment {
-		grant_ref_t gref;        /* reference to I/O buffer frame        */
-		/* @first_sect: first sector in frame to transfer (inclusive).   */
-		/* @last_sect: last sector in frame to transfer (inclusive).     */
-		uint8_t     first_sect, last_sect;
-	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 } __attribute__((__packed__));
 
 struct blkif_request_discard {
-- 
1.7.7.5 (Apple Git-26)

