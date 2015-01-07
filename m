Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbbAGDDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:03:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbbAGBv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.18 26/84] dm cache: fix spurious cell_defer when dealing with partial block at end of device
Date: Tue,  6 Jan 2015 17:49:29 -0800
Message-Id: <20150107014029.856048256@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit f824a2af3dfbbb766c02e19df21f985bceadf0ee upstream.

We never bother caching a partial block that is at the back end of the
origin device.  No cell ever gets locked, but the calling code was
assuming it was and trying to release it.

Now the code only releases if the cell has been set to a non NULL
value.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2554,11 +2554,11 @@ static int __cache_map(struct cache *cac
 static int cache_map(struct dm_target *ti, struct bio *bio)
 {
 	int r;
-	struct dm_bio_prison_cell *cell;
+	struct dm_bio_prison_cell *cell = NULL;
 	struct cache *cache = ti->private;
 
 	r = __cache_map(cache, bio, &cell);
-	if (r == DM_MAPIO_REMAPPED) {
+	if (r == DM_MAPIO_REMAPPED && cell) {
 		inc_ds(cache, bio, cell);
 		cell_defer(cache, cell, false);
 	}


