Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3JCDRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 23:17:37 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50168 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3JCDRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 23:17:36 -0400
Date: Wed, 2 Oct 2013 20:17:38 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131003031738.GA27418@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928045909.GA19745@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:59:09AM -0400, Mike Snitzer wrote:
> Hey Kent,
> 
> I haven't been able to pinpoint the issue yet, but using your for-jens
> branch, if I create a dm-thin volume with this lvm command:
> lvcreate -L20G -V20G -T vg/pool --name thinlv
> 
> and try to format /dev/vg/thinlv with XFS the kernel warns and then
> hangs with the following:

Thanks, for whatever reason ext4 wasn't tickling that codepath but xfs
does. I folded the fix into my for-jens branch, here's what changed:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b60b350..79cee1a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1098,7 +1098,7 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
 		bio_integrity_clone(clone, bio, GFP_NOIO);
 
 	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
-	bio->bi_iter.bi_size = to_bytes(len);
+	clone->bi_iter.bi_size = to_bytes(len);
 
 	if (bio_integrity(bio))
 		bio_integrity_trim(clone, 0, len);
@@ -1267,7 +1267,7 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
-	len = min_t(unsigned, max_io_len(ci->sector, ti), bio_sectors(bio));
+	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
 
 	__clone_and_map_data_bio(ci, ti, ci->sector, len);
 
