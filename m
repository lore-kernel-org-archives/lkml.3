Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaJCWXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:23:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaJCWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 215/238] md/raid1:  be more cautious where we read-balance during resync.
Date: Fri,  3 Oct 2014 14:32:10 -0700
Message-Id: <20141003212920.534945756@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit c6d119cf1b5a778e9ed60a006e2a434fcc4471a2 upstream.

commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 made
it possible for reads to happen concurrently with resync.
This means that we need to be more careful where read_balancing
is allowed during resync - we can no longer be sure that any
resync that has already started will definitely finish.

So keep read_balancing to before recovery_cp, which is conservative
but safe.

This bug makes it possible to read from a device that doesn't
have up-to-date data, so it can cause data corruption.
So it is suitable for any kernel since 3.11.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -540,11 +540,7 @@ static int read_balance(struct r1conf *c
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
 
-	if (conf->mddev->recovery_cp < MaxSector &&
-	    (this_sector + sectors >= conf->next_resync))
-		choose_first = 1;
-	else
-		choose_first = 0;
+	choose_first = (conf->mddev->recovery_cp < this_sector + sectors);
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		sector_t dist;


