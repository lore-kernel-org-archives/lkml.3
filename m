Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbaA1RoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:44:06 -0500
Received: from smtp.citrix.com ([66.165.176.89]:20187 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbaA1RoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:44:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97353081"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Matt Rushton <mrushton@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <xen-devel@lists.xen.org>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: [PATCH 1/3] xen-blkback: fix memory leak when persistent grants are used
Date: Tue, 28 Jan 2014 18:43:33 +0100
Message-ID: <1390931015-5490-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
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
 1 files changed, 3 insertions(+), 3 deletions(-)

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
1.7.7.5 (Apple Git-26)

