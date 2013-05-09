Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3EIUoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:44:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33151 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3EIUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:44:43 -0400
Date: Thu, 9 May 2013 13:44:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Joe Thornber <thornber@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dmcache: flush superblock stats when retrieving status
 info
Message-ID: <20130509204437.GA5712@blackbox.djwong.org>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509203616.GA5713@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When userspace queries dmcache for stats info, we should ensure that all the
metadata gets flushed out of memory to disk.  The current code neglects to
update the disk copy of the hit/miss counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1074409..4fb7b4c 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2451,6 +2451,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_INFO:
 		/* Commit to ensure statistics aren't out-of-date */
 		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti)) {
+			save_stats(cache);
 			r = dm_cache_commit(cache->cmd, false);
 			if (r)
 				DMERR("could not commit metadata for accurate status");
