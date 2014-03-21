Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbaCUAOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:14:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966193AbaCUAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3.4 19/35] firewire: net: fix use after free
Date: Thu, 20 Mar 2014 17:11:10 -0700
Message-Id: <20140321001054.803303910@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 8987583366ae9e03c306c2b7d73bdb952df1d08d upstream.

Commit 8408dc1c14c1 "firewire: net: use dev_printk API" introduced a
use-after-free in a failure path.  fwnet_transmit_packet_failed(ptask)
may free ptask, then the dev_err() call dereferenced it.  The fix is
straightforward; simply reorder the two calls.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/net.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1014,8 +1014,6 @@ static void fwnet_write_complete(struct
 	if (rcode == RCODE_COMPLETE) {
 		fwnet_transmit_packet_done(ptask);
 	} else {
-		fwnet_transmit_packet_failed(ptask);
-
 		if (printk_timed_ratelimit(&j,  1000) || rcode != last_rcode) {
 			dev_err(&ptask->dev->netdev->dev,
 				"fwnet_write_complete failed: %x (skipped %d)\n",
@@ -1023,8 +1021,10 @@ static void fwnet_write_complete(struct
 
 			errors_skipped = 0;
 			last_rcode = rcode;
-		} else
+		} else {
 			errors_skipped++;
+		}
+		fwnet_transmit_packet_failed(ptask);
 	}
 }
 


