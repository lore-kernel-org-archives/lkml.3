Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaFCIMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:12:41 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:39888 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbaFCIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:12:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AopxALSCjVN5LL1sPGdsb2JhbABZgweDRYUIoxMBAgaYGwGBCxcDAQEBATg1giUBAQQBJxMcIwULCAMYCSUPBSUDBxoTiDoH0ToXFoU/iH0HgyuBFQSZf5Z4Kw
Date: Tue, 3 Jun 2014 18:12:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603081235.GE14410@dastard>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <877g4yv3h3.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877g4yv3h3.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:47:52PM +0900, OGAWA Hirofumi wrote:
> Daniel Phillips <daniel@phunq.net> writes:
> 
> > Hi Dave,
> > On 06/02/2014 08:33 PM, Dave Chinner wrote:
> >> On Mon, Jun 02, 2014 at 01:02:29PM -0700, Daniel Phillips wrote:
> >>>
> >>> Redirty_tail nearly works, but "if (!list_empty(&wb->b_dirty))" is
> >>> not correct because the inode needs to end up on the dirty list
> >>> whether it was already there or not.
> >> redirty_tail() always moves the inode to the end of the dirty
> >> list.
> 
> It doesn't move inode to end of the dirty if wb.b_dirty is empty
> (I.e. it can move from wb.b_io to wb.b_dirty too).

Um, really?  What code are you reading? From 3.15-rc8:

static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
{
        assert_spin_locked(&wb->list_lock);
        if (!list_empty(&wb->b_dirty)) {
                struct inode *tail;

                tail = wb_inode(wb->b_dirty.next);
                if (time_before(inode->dirtied_when, tail->dirtied_when))
                        inode->dirtied_when = jiffies;
        }
        list_move(&inode->i_wb_list, &wb->b_dirty);
}

The list_move() is not conditional at all and so the inode is
*always* moved to the tail of wb->b_dirty....

> It has difference.
> 
> Say, tail->dirtied_when == 1, inode->dirtied_when == 2, and now == 30
> (tail->dirtied_when is expired at 31 with default config). In this case,
> redirty_tail() doesn't update ->dirtied_when.

OK, that's a different issue, and is actually handled by
requeue_inode(), which is called to put inodes back on the correct
dirty list when IO completes. I think that if you are going to use
the wb dirty inode lists, you should probably use the existing
functions to manage the inode lists appropriately rather than
creating your own writeback list lifecycle.

If tux3 wants it's own dirty inode list lifecycles, then that's
where avoiding the wb lists completely is an appropriate design
point. I don't want to hack little bits and pieces all over the
writeback code to support what tux3 is doing right now if it's going
to do something else real soon. When tux3 moves to use it's own
internal lists these new funcitons just have to be removed again, so
let's skip the hack step we are at right now and go straight for
supporting the "don't need the fs-writeback lists" infrstructure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
