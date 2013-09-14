Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3INChU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:37:20 -0400
Received: from alum-mailsec-scanner-3.mit.edu ([18.7.68.14]:49802 "EHLO
	alum-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab3INChS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:37:18 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2013 22:37:17 EDT
X-AuditID: 1207440e-b7fe96d000003c8a-d9-5233ca37e226
Date: Fri, 13 Sep 2013 20:36:55 -0600
From: Chuck Coffing <clc@alum.mit.edu>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] bad bd_fsfreeze_count in freeze_bdev
Message-ID: <20130914023655.GA3212@server.mountain-tech.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsUixO6iqGt+yjjIYOsqPovLu+awWZz/e5zV
	gcnj8yY5j01P3jIFMEVx2yQllpQFZ6bn6dslcGc8nHyPseAkW0X/zpusDYzbWbsYOTgkBEwk
	9v8t62LkBDLFJC7cW8/WxcjFISRwmVFiyotZ7BDOBSaJNe+/M4FUsQioSjTP/MoGYrMJqEk0
	9zWC2SICChKbe5+xgtjMAjoSR54vZAexhQVMJb6vfwcW5xWwkTgwfRs7hC0ocXLmExaIei2J
	G/9eMoEcxCwgLbH8HwdIWFRARWLKyW1sExj5ZiHpmIWkYxZCxwJG5lWMcok5pbm6uYmZOcWp
	ybrFyYl5ealFusZ6uZkleqkppZsYIUHHt4Oxfb3MIUYBDkYlHt4Z3sZBQqyJZcWVuYcYJTmY
	lER5nU4AhfiS8lMqMxKLM+KLSnNSiw8xSnAwK4nwnpgLlONNSaysSi3Kh0lJc7AoifOqLVH3
	ExJITyxJzU5NLUgtgsnKcHAoSfA2nwRqFCxKTU+tSMvMKUFIM3FwgggukA08QBtqQQp5iwsS
	c4sz0yGKTjEqSonzBoAkBEASGaV5cANg6eEVozjQP8K83iBVPMDUAtf9CmgwE9DgzbuNQAaX
	JCKkpBoY7TY8jCs9Pre6rU8ivPjSHsO8Hdnfg16ePrO3IOfTtWUt/3ZUTzm2kvF5fcnit61r
	/rItyWRUqZB9qRXUHFyxQ+fcnoMPQiefuXCOTeH+64eLnj07zX/DQ7dqyrd9h5KlVbKOXM33
	2XHI20KH+fvPPxoebKuEpF5fe8GW+tjQJ/47g3pOcULFSSWW4oxEQy3mouJEAOryfLfqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

An error path in freeze_bdev screws up the freeze count.

Consider:
- call freeze_bdev with a bdev that's unmounted (stupidity or a race)
- bd_fsfreeze_count is unconditionally incremented on entry
- can't get the sb; error out
- bd_fsfreeze_count is not decremented (oops!)
- call freeze_bdev again just for obnoxiousness...
- since bd_fsfreeze_count is already nonzero, sb is assumed good and deref'd

(CC me, I'm not subscribed)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index c3549ed..f1c5561 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -253,6 +253,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 	}
 	deactivate_super(sb);
  out:
+	bdev->bd_fsfreeze_count--;
 	sync_blockdev(bdev);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return sb;	/* thaw_bdev releases s->s_umount */
