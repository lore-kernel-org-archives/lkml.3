Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaDAMRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:17:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaDALQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/144] firewire: net: fix use after free
Date: Tue,  1 Apr 2014 12:13:47 +0100
Message-Id: <1396350948-29910-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 8987583366ae9e03c306c2b7d73bdb952df1d08d upstream.

Commit 8408dc1c14c1 "firewire: net: use dev_printk API" introduced a
use-after-free in a failure path.  fwnet_transmit_packet_failed(ptask)
may free ptask, then the dev_err() call dereferenced it.  The fix is
straightforward; simply reorder the two calls.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firewire/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 6b89598..4af0a7b 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -929,8 +929,6 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
 	} else {
-		fwnet_transmit_packet_failed(ptask);
-
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
 			dev_err(&ptask->dev->netdev->dev,
 				"fwnet_write_complete failed: %x (skipped %d)\n",
@@ -938,8 +936,10 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 
 			errors_skipped = 0;
 			last_rcode = rcode;
-		} else
+		} else {
 			errors_skipped++;
+		}
+		fwnet_transmit_packet_failed(ptask);
 	}
 }
 
-- 
1.9.1

