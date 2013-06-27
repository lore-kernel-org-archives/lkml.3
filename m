Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3F0AO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:14:28 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47606 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3F0AOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:14:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard>
Date: Thu, 27 Jun 2013 09:14:07 +0900
In-Reply-To: <20130626231143.GC28426@dastard> (Dave Chinner's message of "Thu,
	27 Jun 2013 09:11:43 +1000")
Message-ID: <87wqpg76ls.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> On another view, wait_sb_inodes() would (arguably) be necessary for
>> legacy FSes. But, for example, if data=journal on ext*, wait_sb_inodes()
>> would be more than useless, because ext* can be done it by own
>> transaction list (and more efficient way).
>> 
>> Likewise, on tux3, the state is same with data=journal.
>> 
>> Also, even if data=ordered, ext* might be able to check in-flight I/O by
>> ordered data list (with some new additional check, I'm not sure).
>
> Why would you bother solving this problem differently in every
> single filesystem? It's solvable at the VFS by tracking inodes that
> are no longer dirty but still under writeback on the BDI. Then
> converting wait_sb_inodes() to walk all the dirty and writeback
> inodes would be sufficient for data integrity purposes, and it would
> be done under the bdi writeback lock, not the inode_sb_list_lock....
>
> Alternatively, splitting up the inode sb list and lock (say via the
> per-node list_lru structures in -mm and -next that are being added
> for exactly this purpose) would also significantly reduce lock
> contention on both the create/evict fast paths and the
> wait_sb_inodes() walk that is currently done....
>
> So I think that you should address the problem properly at the VFS
> level so everyone benefits, not push interfaces that allow
> filesystem specific hacks to work around VFS level deficiencies...

Optimizing wait_sb_inodes() might help lock contention, but it doesn't
help unnecessary wait/check. Since some FSes know about current
in-flight I/O already in those internal, so I think, those FSes can be
done it here, or are already doing in ->sync_fs().

For example, I guess ext4 implement (untested) would be something like
following. If ->sync_fs() does all, ext4 doesn't need to be bothered by
wait_sb_inodes().

static void ext4_wait_inodes(struct super_block *sb)
{
	/* ->sync_fs() guarantees to wait all */
	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
        	return;

	/* FIXME: On data=ordered, we might be able to avoid this too. */
	wait_sb_inodes(sb);
}

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
