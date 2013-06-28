Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3F1IWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:22:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54873 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3F1IW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:22:29 -0400
Date: Fri, 28 Jun 2013 09:22:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628082213.GE4165@ZenIV.linux.org.uk>
References: <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 07:59:50PM -1000, Linus Torvalds wrote:

> Also, looking some more now at that wait_sb_inodes logic, I have to
> say that if the problem is primarily the inode->i_lock, then that's
> just crazy.


Looks more like contention on inode_sb_list_lock, actually...

> And no, I don't think really need the i_lock for checking
> "mapping->nrpages == 0" or the magical "inode is being freed" bits
> either. Or at least we could easily do some of this optimistically for
> the common cases.

> I'm attaching a pretty trivial patch, which may obviously be trivially
> totally flawed. I have not tested this in any way, but half the new
> lines are comments about why it's doing what it is doing.  And I
> really think that it should make the "actually take the inode lock" be
> something quite rare.
> 
> And quite frankly, I'd much rather get *rid* of crazy i_lock accesses,
> than try to be clever and use a whole different list at this point.
> Not that I disagree that it wouldn't be much nicer to use a separate
> list in the long run, but for a short-term solution I'd much rather
> keep the old logic and just tweak it to be much more usable..
> 
> Hmm? Al? Jan? Comments?

Patch seems to be sane, but I'm not sure how much will it buy in that
case.
