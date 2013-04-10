Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965208Ab3DJW4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:56:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937570Ab3DJWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Todd Poynor <toddpoynor@google.com>, "Theodore Tso" <tytso@mit.edu>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        Lukas Czerner <lczerner@redhat.com>
Subject: [ 06/19] ext4: fixup 64-bit divides in 3.0-stable backport of upstream fix
Date: Wed, 10 Apr 2013 15:50:29 -0700
Message-Id: <20130410225027.476235073@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Poynor <toddpoynor@google.com>

Replace C division operators with div64_u64 for divides introduced in:
commit 503f4bdcc078e7abee273a85ce322de81b18a224
ext4: use atomic64_t for the per-flexbg free_clusters count

Specific to the 3.0-stable backport of the upstream patch.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -22,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
+#include <linux/math64.h>
 #include <asm/byteorder.h>
 
 #include "ext4.h"
@@ -356,7 +357,7 @@ static int find_group_flex(struct super_
 
 find_close_to_parent:
 	flexbg_free_blocks = atomic64_read(&flex_group[best_flex].free_blocks);
-	flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
+	flex_freeb_ratio = div64_u64(flexbg_free_blocks * 100, blocks_per_flex);
 	if (atomic_read(&flex_group[best_flex].free_inodes) &&
 	    flex_freeb_ratio > free_block_ratio)
 		goto found_flexbg;
@@ -371,7 +372,7 @@ find_close_to_parent:
 			continue;
 
 		flexbg_free_blocks = atomic64_read(&flex_group[i].free_blocks);
-		flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
+		flex_freeb_ratio = div64_u64(flexbg_free_blocks * 100, blocks_per_flex);
 
 		if (flex_freeb_ratio > free_block_ratio &&
 		    (atomic_read(&flex_group[i].free_inodes))) {


