Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaBHTlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:41:55 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:48396 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaBHTly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:41:54 -0500
Date: Sat, 8 Feb 2014 13:37:38 -0600
From: David Fries <David@Fries.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert ds1wm.c from "w1: hold bus_mutex in netlink and
 search"
Message-ID: <20140208193738.GV5342@spacedout.fries.net>
References: <20140208074733.GZ26776@mwanda>
 <20140208160358.GQ5342@spacedout.fries.net>
 <20140208182846.GD10892@kroah.com>
 <20140208183055.GT5342@spacedout.fries.net>
 <20140208184450.GA5400@kroah.com>
 <20140208191859.GU5342@spacedout.fries.net>
 <20140208193513.GA13359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208193513.GA13359@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sat, 08 Feb 2014 13:37:40 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts ds1wm.c from commit d3a8a9dbb903c73a7ec2deae4c9b7d74b6834f4c.
Of the three files changed ds1wm.c ds2490.c and w1_netlink.c, it turns out
ds1wm.c was locking bus_mutex, but inside the loop and I missed it.
Reverting ds1wm.c to the previous version.

Signed-off-by: David Fries <David@Fries.net>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/w1/masters/ds1wm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index b077b8b..02df3b1 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -326,14 +326,13 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 	unsigned slaves_found = 0;
 	unsigned int pass = 0;
 
-	mutex_lock(&master_dev->bus_mutex);
 	dev_dbg(&ds1wm_data->pdev->dev, "search begin\n");
 	while (true) {
 		++pass;
 		if (pass > 100) {
 			dev_dbg(&ds1wm_data->pdev->dev,
 				"too many attempts (100), search aborted\n");
-			break;
+			return;
 		}
 
 		mutex_lock(&master_dev->bus_mutex);
@@ -440,7 +439,6 @@ static void ds1wm_search(void *data, struct w1_master *master_dev,
 	dev_dbg(&ds1wm_data->pdev->dev,
 		"pass: %d total: %d search done ms d bit pos: %d\n", pass,
 		slaves_found, ms_discrep_bit);
-	mutex_unlock(&master_dev->bus_mutex);
 }
 
 /* --------------------------------------------------------------------- */
-- 
1.7.10.4

