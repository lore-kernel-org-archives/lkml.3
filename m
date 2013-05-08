Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3EHVsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:48:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32327 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3EHVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:48:50 -0400
Date: Wed, 8 May 2013 14:48:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: dm-cache not writing out cache metadata at reboot?
Message-ID: <20130508214845.GA7729@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I've been watching the hit/miss counters in dmcache and I've noticed a
couple of things that look like errors to me:

First, I noticed that if I reboot the system, neither cache_postsuspend nor
cache_dtr get called.  This might simply be expected behavior, but it means
that the in-memory superblock structure doesn't get written out to disk upon
reboot.  Just to be sure, I put a printk into __commit_transaction.  It prints
out for 'dmsetup info' and 'dmsetup remove' but nothing at reboot.

Second, cache_status calls dm_cache_commit, which writes out a superblock to
the metadata device.  However, there's no call to save_stats to copy the
current values of the counters out to the disk's copy prior to calling
dm_cache_commit.  Therefore, we seem to be writing out stale copies of
superblock fields.

The second one seems fixable with the attached patch, but the first one I don't
know about.  Any ideas?

---
Subject: [PATCH] dmcache: flush superblock when retrieving status info

When userspace queries dmcache for stats info, we should ensure that all the
metadata gets flushed out of memory to disk.  The current code neglects to
update at least the hit/miss counters, so take care of everything.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-cache-target.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1074409..f476ada 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2451,8 +2451,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_INFO:
 		/* Commit to ensure statistics aren't out-of-date */
 		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti)) {
-			r = dm_cache_commit(cache->cmd, false);
-			if (r)
+			if (!sync_metadata(cache))
 				DMERR("could not commit metadata for accurate status");
 		}
 
