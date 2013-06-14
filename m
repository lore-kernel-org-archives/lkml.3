Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3FNOC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:02:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57985 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FNOCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:02:25 -0400
Date: Fri, 14 Jun 2013 10:02:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
Message-ID: <20130614140215.GA1017@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614140940.GA20401@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:09:40PM +0800, Zheng Liu wrote:
> This commit tries to fix this problem.  Now a new member called
> i_touch_when is added into ext4_inode_info to record the last access
> time for an inode.  Meanwhile we never need to keep a proper in-order
> LRU list.  So this can avoid to burns some CPU time.  When we try to
> reclaim some entries from extent status tree, we use list_sort() to get
> a proper in-order list.  Then we traverse this list to discard some
> entries.

I think this approach is very sound.  I have one reservation, however.
If there are a large number of inodes on this list, list_sort() could
burn a lot of CPU time, especially if the shrinker is called a very
large number of times in a short time period (i.e., when the system is
thrashing, or when one or more memory containers are under a large
amount of memory pressure).

I have a suggestion for how to address this: Keep a timestamp of when
the list last has been sorted in struct ext4_super_info.  When
iterating over the list, looking for a candidate inode, if inode's
i_touch_when is greater than the last time sorted, skip the inode.  If
there are no inodes left in the list, or more than some threshold
inodes have been skipped, only then resort the list (and update the
timestamp in the ext4_super_info structure).

What do you think?

					- Ted
