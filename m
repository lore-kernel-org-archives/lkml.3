Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618AbaICW3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:29:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaICW3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:29:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.16 089/125] Btrfs: fix crash on endio of reading corrupted block
Date: Wed,  3 Sep 2014 15:07:26 -0700
Message-Id: <20140903220626.346231505@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 38c1c2e44bacb37efd68b90b3f70386a8ee370ee upstream.

The crash is

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:2124!
[...]
Workqueue: btrfs-endio normal_work_helper [btrfs]
RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]

This is in fact a regression.

It is because we forgot to increase @offset properly in reading corrupted block,
so that the @offset remains, and this leads to checksum errors while reading
left blocks queued up in the same bio, and then ends up with hiting the above
BUG_ON.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2532,6 +2532,7 @@ static void end_bio_extent_readpage(stru
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
+				offset += len;
 				continue;
 			}
 		}


