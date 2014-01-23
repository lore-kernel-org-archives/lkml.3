Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaAWT2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:28:54 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39071 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaAWT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:28:52 -0500
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Matt Rushton <mrushton@amazon.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Anthony Liguori <aliguori@amazon.com>,
        Matt Wilson <msw@amazon.com>
Subject: [PATCH] xen-blkback: fix memory leak when persistent grants are used
Date: Thu, 23 Jan 2014 11:28:46 -0800
Message-Id: <1390505326-9368-1-git-send-email-msw@linux.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Rushton <mrushton@amazon.com>

Currently shrink_free_pagepool() is called before the pages used for
persistent grants are released via free_persistent_gnts(). This
results in a memory leak when a VBD that uses persistent grants is
torn down.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Roger Pau Monné" <roger.pau@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xen.org
Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Matt Rushton <mrushton@amazon.com>
Signed-off-by: Matt Wilson <msw@amazon.com>
---
 drivers/block/xen-blkback/blkback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 6620b73..30ef7b3 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -625,9 +625,6 @@ purge_gnt_list:
 			print_stats(blkif);
 	}
 
-	/* Since we are shutting down remove all pages from the buffer */
-	shrink_free_pagepool(blkif, 0 /* All */);
-
 	/* Free all persistent grant pages */
 	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
 		free_persistent_gnts(blkif, &blkif->persistent_gnts,
@@ -636,6 +633,9 @@ purge_gnt_list:
 	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
 	blkif->persistent_gnt_c = 0;
 
+	/* Since we are shutting down remove all pages from the buffer */
+	shrink_free_pagepool(blkif, 0 /* All */);
+
 	if (log_stats)
 		print_stats(blkif);
 
-- 
1.7.9.5

