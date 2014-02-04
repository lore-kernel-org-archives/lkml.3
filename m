Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaBDK1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:27:14 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:32870 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaBDK0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:26:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="97665478"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Matt Rushton <mrushton@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <xen-devel@lists.xen.org>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: [PATCH v2 1/4] xen-blkback: fix memory leak when persistent grants are used
Date: Tue, 4 Feb 2014 11:26:12 +0100
Message-ID: <1391509575-3949-2-git-send-email-roger.pau@citrix.com>
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

