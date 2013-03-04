Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3CDEEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:04:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180Ab3CDDnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:33 -0500
Message-Id: <20130304033716.895610888@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Lukas Czerner <lczerner@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 094/153] ext4: fix free clusters calculation in bigalloc filesystem
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 304e220f0879198b1f5309ad6f0be862b4009491 upstream.

ext4_has_free_clusters() should tell us whether there is enough free
clusters to allocate, however number of free clusters in the file system
is converted to blocks using EXT4_C2B() which is not only wrong use of
the macro (we should have used EXT4_NUM_B2C) but it's also completely
wrong concept since everything else is in cluster units.

Moreover when calculating number of root clusters we should be using
macro EXT4_NUM_B2C() instead of EXT4_B2C() otherwise the result might be
off by one. However r_blocks_count should always be a multiple of the
cluster ratio so doing a plain bit shift should be enough here. We
avoid using EXT4_B2C() because it's confusing.

As a result of the first problem number of free clusters is much bigger
than it should have been and ext4_has_free_clusters() would return 1 even
if there is really not enough free clusters available.

Fix this by removing the EXT4_C2B() conversion of free clusters and
using bit shift when calculating number of root clusters. This bug
affects number of xfstests tests covering file system ENOSPC situation
handling. With this patch most of the ENOSPC problems with bigalloc file
system disappear, especially the errors caused by delayed allocation not
having enough space when the actual allocation is finally requested.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/balloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -420,11 +420,16 @@ static int ext4_has_free_clusters(struct
 
 	free_clusters  = percpu_counter_read_positive(fcc);
 	dirty_clusters = percpu_counter_read_positive(dcc);
-	root_clusters = EXT4_B2C(sbi, ext4_r_blocks_count(sbi->s_es));
+
+	/*
+	 * r_blocks_count should always be multiple of the cluster ratio so
+	 * we are safe to do a plane bit shift only.
+	 */
+	root_clusters = ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
 
 	if (free_clusters - (nclusters + root_clusters + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
-		free_clusters  = EXT4_C2B(sbi, percpu_counter_sum_positive(fcc));
+		free_clusters  = percpu_counter_sum_positive(fcc);
 		dirty_clusters = percpu_counter_sum_positive(dcc);
 	}
 	/* Check whether we have space after accounting for current


