Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaBDRXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:23:51 -0500
Received: from sh.osrg.net ([192.16.179.4]:60340 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaBDRXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:23:47 -0500
Date: Wed, 05 Feb 2014 02:23:09 +0900 (JST)
Message-Id: <20140205.022309.85397785.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Rohner <andreas.rohner@gmx.net>, linux-kernel@vger.kernel.org,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 3/4] nilfs2: add nilfs_sufile_set_suinfo to update
 segment usage
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20140205.014137.417300930.konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140203133818.5b78761c08846f2d1216b6e2@linux-foundation.org>
	<20140205.014137.417300930.konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Wed, 05 Feb 2014 02:23:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb 2014 01:41:37 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 3 Feb 2014 13:38:18 -0800, Andrew Morton wrote:
>> On Tue,  4 Feb 2014 01:50:43 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
>> 
>>> From: Andreas Rohner <andreas.rohner@gmx.net>
>>> 
>>> This patch introduces the nilfs_sufile_set_suinfo function, which
>>> expects an array of nilfs_suinfo_update structures and updates the
>>> segment usage information accordingly.
>>> 
>>> This is basically a helper function for the newly introduced
>>> NILFS_IOCTL_SET_SUINFO ioctl.
>>> 
>>> ..
>>> +		sup = (void *)sup + supsz;
>>> +		if (sup >= supend)
>>> +			break;
>>> +
>>> +		prev_blkoff = blkoff;
>>> +		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
>>> +		if (blkoff == prev_blkoff)
>>> +			continue;
>>> +
>>> +		/* get different block */
>>> +		mark_buffer_dirty(bh);
>>> +		brelse(bh);
>> 
>> put_bh() will suffice - we know bh != NULL.
> 
> Agreed.  I will fix it later.

Here is the fix.

Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] nilfs2: add nilfs_sufile_set_suinfo to update segment usage
 fix

Use put_bh() instead of brelse() because we know bh != NULL.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sufile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index c37b5f0..5628b99 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -978,13 +978,13 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 
 		/* get different block */
 		mark_buffer_dirty(bh);
-		brelse(bh);
+		put_bh(bh);
 		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
 		if (unlikely(ret < 0))
 			goto out_mark;
 	}
 	mark_buffer_dirty(bh);
-	brelse(bh);
+	put_bh(bh);
 
  out_mark:
 	if (ncleaned || ndirtied) {
@@ -994,7 +994,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
 	}
 	nilfs_mdt_mark_dirty(sufile);
  out_header:
-	brelse(header_bh);
+	put_bh(header_bh);
  out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
-- 
1.7.9.3


