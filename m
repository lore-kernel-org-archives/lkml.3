Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3KYN7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58892 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637Ab3KYNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alasdair G Kergon" <agk@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.134523985@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 69/87] dm snapshot: fix data corruption
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit e9c6a182649f4259db704ae15a91ac820e63b0ca upstream.

This patch fixes a particular type of data corruption that has been
encountered when loading a snapshot's metadata from disk.

When we allocate a new chunk in persistent_prepare, we increment
ps->next_free and we make sure that it doesn't point to a metadata area
by further incrementing it if necessary.

When we load metadata from disk on device activation, ps->next_free is
positioned after the last used data chunk. However, if this last used
data chunk is followed by a metadata area, ps->next_free is positioned
erroneously to the metadata area. A newly-allocated chunk is placed at
the same location as the metadata area, resulting in data or metadata
corruption.

This patch changes the code so that ps->next_free skips the metadata
area when metadata are loaded in function read_exceptions.

The patch also moves a piece of code from persistent_prepare_exception
to a separate function skip_metadata to avoid code duplication.

CVE-2013-4299

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-snap-persistent.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -269,6 +269,14 @@ static chunk_t area_location(struct psto
 	return NUM_SNAPSHOT_HDR_CHUNKS + ((ps->exceptions_per_area + 1) * area);
 }
 
+static void skip_metadata(struct pstore *ps)
+{
+	uint32_t stride = ps->exceptions_per_area + 1;
+	chunk_t next_free = ps->next_free;
+	if (sector_div(next_free, stride) == NUM_SNAPSHOT_HDR_CHUNKS)
+		ps->next_free++;
+}
+
 /*
  * Read or write a metadata area.  Remembering to skip the first
  * chunk which holds the header.
@@ -502,6 +510,8 @@ static int read_exceptions(struct pstore
 
 	ps->current_area--;
 
+	skip_metadata(ps);
+
 	return 0;
 }
 
@@ -616,8 +626,6 @@ static int persistent_prepare_exception(
 					struct dm_exception *e)
 {
 	struct pstore *ps = get_info(store);
-	uint32_t stride;
-	chunk_t next_free;
 	sector_t size = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
 	/* Is there enough room ? */
@@ -630,10 +638,8 @@ static int persistent_prepare_exception(
 	 * Move onto the next free pending, making sure to take
 	 * into account the location of the metadata chunks.
 	 */
-	stride = (ps->exceptions_per_area + 1);
-	next_free = ++ps->next_free;
-	if (sector_div(next_free, stride) == 1)
-		ps->next_free++;
+	ps->next_free++;
+	skip_metadata(ps);
 
 	atomic_inc(&ps->pending_count);
 	return 0;

