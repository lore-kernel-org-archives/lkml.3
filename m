Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3EIUr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:47:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34584 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3EIUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:47:56 -0400
Date: Thu, 9 May 2013 13:47:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Joe Thornber <thornber@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dmcache: Implement a flush message
Message-ID: <20130509204751.GB5712@blackbox.djwong.org>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509203616.GA5713@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new 'flush' message that causes the dmcache to write all of its
metadata out to disk.  This enables us to ensure that the disk reflects
whatever's in memory without having to tear down the cache device.  This helps
me in the case where I have a cached ro fs that I can't umount and therefore
can't tear down the cache device, but want to save the cache metadata anyway.
The command syntax is as follows:

# dmsetup message mycache 0 flush now

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/md/dm-cache-target.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 4fb7b4c..e26e5d2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2522,6 +2522,7 @@ err:
 
 static int process_config_option(struct cache *cache, char **argv)
 {
+	bool res;
 	unsigned long tmp;
 
 	if (!strcasecmp(argv[0], "migration_threshold")) {
@@ -2530,6 +2531,9 @@ static int process_config_option(struct cache *cache, char **argv)
 
 		cache->migration_threshold = tmp;
 		return 0;
+	} else if (!strcasecmp(argv[0], "flush")) {
+		res = sync_metadata(cache);
+		return res ? 0 : -EIO;
 	}
 
 	return NOT_CORE_OPTION;
