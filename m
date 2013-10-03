Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3JCTny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:43:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43655 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3JCTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:43:53 -0400
Date: Thu, 3 Oct 2013 20:43:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131003194351.GK13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <20131003174439.GG13318@ZenIV.linux.org.uk>
 <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 12:06:04PM -0700, Linus Torvalds wrote:
> On Thu, Oct 3, 2013 at 10:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Anyway, I've done nicer variants of that protection for everything except
> > fuse (hadn't gotten around to it yet); see vfs.git#experimental now:
> 
> Ok, I did a quick test, and it looks ok here, so looking good for 3.13.
> 
> However, the new smp_mb() in mntput_no_expire() is quite noticeable in
> the path lookup stress-test profiles. And I'm not seeing what that
> allegedly protects against, especially if mnt_ns is NULL (ie all the
> common important cases).

In the common case it's ->mnt_ns is *not* NULL; that's what we get if
the damn thing is still mounted.

What we need to avoid is this:

mnt_ns non-NULL, mnt_count is 2
CPU1: umount -l					CPU2: mntput
umount_tree() clears mnt_ns
drop mount_lock.lock
namespace_unlock() calls mntput()
decrement mnt_count
see that mnt_ns is NULL
grab mount_lock.lock
check mnt_count
						decrement mnt_count
						see old value of mnt_ns
						decide to bugger off
see it equal to 1 (i.e. miss decrement on CPU2)
decide to bugger off

The barrier in mntput() is to prevent that combination, so that either CPU2
would see mnt_ns cleared by CPU1, or CPU1 would see mnt_count decrement done
by CPU2.  Its counterpart on CPU1 is provided by spin_unlock/spin_lock we've
done between clearing mnt_ns and checking mnt_count.  Note that
synchronize_rcu() in namespace_unlock() and rcu_read_lock() in mntput() are
irrelevant here - the latter on CPU2 might very well have happened after the
former on CPU1, so umount -l did *not* wait for CPU2 to do anything.

Any suggestions re getting rid of that barrier?
