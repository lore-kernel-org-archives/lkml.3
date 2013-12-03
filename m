Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3LCK5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:57:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:19738 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3LCK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:57:52 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="77666364"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC] xen-block: correctly define structures in public headers
Date: Tue, 3 Dec 2013 11:57:34 +0100
Message-ID: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __packed__ on the public interface is not correct, this
structures should be compiled using the native ABI, and __packed__
should only be used in the backend counterpart of those structures
(which needs to handle different ABIs).

This was even worse in the ARM case, where the Linux kernel was
incorrectly using the X86_32 protocol ABI. This patch fixes it, but
also breaks compatibility, so an ARM DomU kernel compiled with
this patch will fail to communicate with PV disk devices unless the
Dom0 also has this patch.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Julien Grall <julien.grall@linaro.org>
Cc: Julien Grall <julien.grall@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 include/xen/interface/io/blkif.h |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 65e1209..002ea22 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -141,14 +141,11 @@ struct blkif_request_segment_aligned {
 	/* @last_sect: last sector in frame to transfer (inclusive).     */
 	uint8_t     first_sect, last_sect;
 	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
-} __attribute__((__packed__));
+};
 
 struct blkif_request_rw {
 	uint8_t        nr_segments;  /* number of segments                   */
 	blkif_vdev_t   handle;       /* only for read/write requests         */
-#ifdef CONFIG_X86_64
-	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
-#endif
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
 	struct blkif_request_segment {
@@ -157,47 +154,36 @@ struct blkif_request_rw {
 		/* @last_sect: last sector in frame to transfer (inclusive).     */
 		uint8_t     first_sect, last_sect;
 	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-} __attribute__((__packed__));
+};
 
 struct blkif_request_discard {
 	uint8_t        flag;         /* BLKIF_DISCARD_SECURE or zero.        */
 #define BLKIF_DISCARD_SECURE (1<<0)  /* ignored if discard-secure=0          */
 	blkif_vdev_t   _pad1;        /* only for read/write requests         */
-#ifdef CONFIG_X86_64
-	uint32_t       _pad2;        /* offsetof(blkif_req..,u.discard.id)==8*/
-#endif
 	uint64_t       id;           /* private guest value, echoed in resp  */
 	blkif_sector_t sector_number;
 	uint64_t       nr_sectors;
 	uint8_t        _pad3;
-} __attribute__((__packed__));
+};
 
 struct blkif_request_other {
 	uint8_t      _pad1;
 	blkif_vdev_t _pad2;        /* only for read/write requests         */
-#ifdef CONFIG_X86_64
-	uint32_t     _pad3;        /* offsetof(blkif_req..,u.other.id)==8*/
-#endif
 	uint64_t     id;           /* private guest value, echoed in resp  */
-} __attribute__((__packed__));
+};
 
 struct blkif_request_indirect {
 	uint8_t        indirect_op;
 	uint16_t       nr_segments;
-#ifdef CONFIG_X86_64
-	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
-#endif
 	uint64_t       id;
 	blkif_sector_t sector_number;
 	blkif_vdev_t   handle;
 	uint16_t       _pad2;
 	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST];
-#ifdef CONFIG_X86_64
-	uint32_t      _pad3;         /* make it 64 byte aligned */
-#else
+#ifdef CONFIG_X86_32
 	uint64_t      _pad3;         /* make it 64 byte aligned */
 #endif
-} __attribute__((__packed__));
+};
 
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
@@ -207,7 +193,7 @@ struct blkif_request {
 		struct blkif_request_other other;
 		struct blkif_request_indirect indirect;
 	} u;
-} __attribute__((__packed__));
+};
 
 struct blkif_response {
 	uint64_t        id;              /* copied from request */
-- 
1.7.7.5 (Apple Git-26)

