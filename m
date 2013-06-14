Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3FNSBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:01:02 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58043 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3FNSBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:01:00 -0400
Date: Fri, 14 Jun 2013 14:00:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
Message-ID: <20130614180054.GB1017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614170028.GA21544@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 01:00:28AM +0800, Zheng Liu wrote:
> > I have a suggestion for how to address this: Keep a timestamp of when
> > the list last has been sorted in struct ext4_super_info.  When
> > iterating over the list, looking for a candidate inode, if inode's
> > i_touch_when is greater than the last time sorted, skip the inode.  If
> > there are no inodes left in the list, or more than some threshold
> > inodes have been skipped, only then resort the list (and update the
> > timestamp in the ext4_super_info structure).
> > 
> 
> Thanks for your suggestion.  I fully agree with you.  What I concern is
> how to define this threshold.  A fixed value is very simple but too
> inflexible.  If this value is too big, this lru list could never be
> sorted.

In my proposal, if the list is never sorted before, we would
definitely sort the list the first time there is a request to shrink
the number of extent caches.  So the list would always be sorted at
least once.

If an inode gets accessed after the time when the list has been
sorted, then the last_touch time will be greater than the last_sorted
time, right?  And our goal is to use the least recently used inode, so
as long as we know they have been used more recently than the time the
list was sorted, and there are still inodes on the list where the
last_touch time is older than the last_sort time, we don't have a
problem.  So we will evict all of the non-delalloc extent cache items
from that inode, and remove it from the list.

The original reason for having the threshold at all is so that if we
skip a huge number of inodes on the list, this would take a long time.
But thinking about this some more, we don't even need a threshold.
What we do instead is if the the last_touch time is newer than the
last_sort time, we just move the inode to the end of the list.  That
means the end of the list will be unsorted, but that's OK, because the
oldest inodes are still at the beginning of the list.  Once the head
of the list is newer than the last_sorted time, then we know we need
to resort the entire list.

Does that make sense to you?

					- Ted
