Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab3DGXh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:37:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46768 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934801Ab3DGXbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Josef Bacik" <jbacik@fusionio.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.41588149@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [37/74] Btrfs: limit the global reserve to 512mb
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit fdf30d1c1b386e1b73116cc7e0fb14e962b763b0 upstream.

A user reported a problem where he was getting early ENOSPC with hundreds of
gigs of free data space and 6 gigs of free metadata space.  This is because the
global block reserve was taking up the entire free metadata space.  This is
ridiculous, we have infrastructure in place to throttle if we start using too
much of the global reserve, so instead of letting it get this huge just limit it
to 512mb so that users can still get work done.  This allowed the user to
complete his rsync without issues.  Thanks

Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3996,7 +3996,7 @@ static void update_global_block_rsv(stru
 	spin_lock(&block_rsv->lock);
 	spin_lock(&sinfo->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +

