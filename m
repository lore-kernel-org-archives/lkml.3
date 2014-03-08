Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaCHBjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:39:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaCHBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:06:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH 3.4 02/99] ext4: fix online resize with a non-standard blocks per group setting
Date: Fri,  7 Mar 2014 17:06:58 -0800
Message-Id: <20140308010611.691011923@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3d2660d0c9c2f296837078c189b68a47f6b2e3b5 upstream.

The set_flexbg_block_bitmap() function assumed that the number of
blocks in a blockgroup was sb->blocksize * 8, which is normally true,
but not always!  Use EXT4_BLOCKS_PER_GROUP(sb) instead, to fix block
bitmap corruption after:

mke2fs -t ext4 -g 3072 -i 4096 /dev/vdd 1G
mount -t ext4 /dev/vdd /vdd
resize2fs /dev/vdd 8G

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Jon Bernard <jbernard@tuxion.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -377,7 +377,7 @@ static int set_flexbg_block_bitmap(struc
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
-		count2 = sb->s_blocksize * 8 - (block - start);
+		count2 = EXT4_BLOCKS_PER_GROUP(sb) - (block - start);
 		if (count2 > count)
 			count2 = count;
 


