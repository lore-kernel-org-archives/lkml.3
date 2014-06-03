Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaFCI51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:57:27 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58021 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFCI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:57:25 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard>
	<538CD855.90804@phunq.net> <20140603033322.GA14410@dastard>
	<538D72B7.3010700@phunq.net> <877g4yv3h3.fsf@devron.myhome.or.jp>
	<20140603081235.GE14410@dastard>
Date: Tue, 03 Jun 2014 17:57:21 +0900
In-Reply-To: <20140603081235.GE14410@dastard> (Dave Chinner's message of "Tue,
	3 Jun 2014 18:12:35 +1000")
Message-ID: <8738fmv09a.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> It doesn't move inode to end of the dirty if wb.b_dirty is empty
>> (I.e. it can move from wb.b_io to wb.b_dirty too).
>
> Um, really?  What code are you reading? From 3.15-rc8:
>
> static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> {
>         assert_spin_locked(&wb->list_lock);
>         if (!list_empty(&wb->b_dirty)) {
>                 struct inode *tail;
>
>                 tail = wb_inode(wb->b_dirty.next);
>                 if (time_before(inode->dirtied_when, tail->dirtied_when))
>                         inode->dirtied_when = jiffies;
>         }
>         list_move(&inode->i_wb_list, &wb->b_dirty);
> }
>
> The list_move() is not conditional at all and so the inode is
> *always* moved to the tail of wb->b_dirty....

Oh, you are right.

>> It has difference.
>> 
>> Say, tail->dirtied_when == 1, inode->dirtied_when == 2, and now == 30
>> (tail->dirtied_when is expired at 31 with default config). In this case,
>> redirty_tail() doesn't update ->dirtied_when.
>
> OK, that's a different issue, and is actually handled by
> requeue_inode(), which is called to put inodes back on the correct
> dirty list when IO completes. I think that if you are going to use
> the wb dirty inode lists, you should probably use the existing
> functions to manage the inode lists appropriately rather than
> creating your own writeback list lifecycle.

See __mark_inode_dirty() what does. We can consolidate that with
__mark_inode_dirty() if you want.

In our case, dirty while inode has I_DIRTY needs to handle new dirty
sometime, because of data=journal behavior.

> If tux3 wants it's own dirty inode list lifecycles, then that's
> where avoiding the wb lists completely is an appropriate design
> point. I don't want to hack little bits and pieces all over the
> writeback code to support what tux3 is doing right now if it's going
> to do something else real soon. When tux3 moves to use it's own
> internal lists these new funcitons just have to be removed again, so
> let's skip the hack step we are at right now and go straight for
> supporting the "don't need the fs-writeback lists" infrstructure.

Is it agreed with someone? There was bdflush, pdflush, and now bdi
flush. Why changed to bdi flush? This respects the intent of change
"pdflush to bdi flush" more or less.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
