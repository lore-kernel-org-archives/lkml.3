Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaCaNXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:23:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaCaNXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 10/71] firewire: net: fix use after free
Date: Mon, 31 Mar 2014 14:22:16 +0100
Message-Id: <1396272197-13394-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
index 638e1f7..7cff7f7 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1014,8 +1014,6 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
 	} else {
-		fwnet_transmit_packet_failed(ptask);
-
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
 			dev_err(&ptask->dev->netdev->dev,
 				"fwnet_write_complete failed: %x (skipped %d)\n",
@@ -1023,8 +1021,10 @@ static void fwnet_write_complete(struct fw_card *card, int rcode,
 
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

