Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaFEAjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:39:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaFDXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>,
        Kent Overstreet <kmo@daterainc.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 055/228] md/raid10: call wait_barrier() for each request submitted.
Date: Wed,  4 Jun 2014 16:21:24 -0700
Message-Id: <20140604232349.837812550@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit cc13b1d1500656a20e41960668f3392dda9fa6e2 upstream.

wait_barrier() includes a counter, so we must call it precisely once
(unless balanced by allow_barrier()) for each request submitted.

Since
commit 20d0189b1012a37d2533a87fb451f7852f2418d1
    block: Introduce new bio_split()
in 3.14-rc1, we don't call it for the extra requests generated when
we need to split a bio.

When this happens the counter goes negative, any resync/recovery will
never start, and  "mdadm --stop" will hang.

Reported-by: Chris Murphy <lists@colorremedies.com>
Fixes: 20d0189b1012a37d2533a87fb451f7852f2418d1
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1172,6 +1172,13 @@ static void __make_request(struct mddev
 	int max_sectors;
 	int sectors;
 
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
+	wait_barrier(conf);
+
 	sectors = bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
@@ -1552,12 +1559,6 @@ static void make_request(struct mddev *m
 
 	md_write_start(mddev, bio);
 
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-	wait_barrier(conf);
 
 	do {
 


