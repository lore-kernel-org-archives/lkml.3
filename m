Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaCJKnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:43:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaCJKnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:43:52 -0400
Date: Mon, 10 Mar 2014 11:43:50 +0100
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140310104350.GB28797@quack.suse.cz>
References: <52B23CEA.7090405@oracle.com>
 <52CD762B.7020600@oracle.com>
 <53123D81.6080003@oracle.com>
 <20140303214040.GA15265@quack.suse.cz>
 <53166920.709@oracle.com>
 <20140305124536.GA32371@quack.suse.cz>
 <53189BF8.1010308@oracle.com>
 <531A7CFD.9030603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531A7CFD.9030603@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-03-14 21:14:21, Sasha Levin wrote:
> On 03/06/2014 11:02 AM, Sasha Levin wrote:
> >On 03/05/2014 07:45 AM, Jan Kara wrote:
> >>On Tue 04-03-14 19:00:32, Sasha Levin wrote:
> >>>On 03/03/2014 04:40 PM, Jan Kara wrote:
> >>>>On Sat 01-03-14 15:05:21, Sasha Levin wrote:
> >>>>>>ping again?
> >>>>>>
> >>>>>>I've been working on it, but don't see an obvious issue.
> >>>>>>
> >>>>>>It does look like an access to invalid memory easily doable from
> >>>>>>userspace, so it should probably get fixed soon...
> >>>>   Hum, can you maybe dump the name in dentry passed to simple_setattr()? Or
> >>>>maybe even the whole path using dentry_path() (but not sure if that will
> >>>>be workable on half-torn-down fs)? Maybe it will give us a hint at which
> >>>>filesystem to look...
> >>>
> >>>It's just garbage, this is why I'm having a hard time making any progress with
> >>>this bug.
> >>   OK, but that is strange because we hold a reference to the dentry so
> >>noone should free it. So dentry->d_name should be valid... Is the rest of
> >>the dentry also garbage? E.g. does dentry->d_inode still point to the inode
> >>we call __mark_inode_dirty() on? Is dentry->d_sb == dentry->d_inode->i_sb?
> >>Also if the inode isn't completely garbage, we can maybe infer something
> >>from inode->i_op - that should point to some statically allocated
> >>operations struct so we should be able to guess fs type from that.
> >
> >It's actually pretty tricky. This issue being a race makes catching it at the right time
> >difficult.
> >
> >I've tried catching it in simple_setattr() before calling mark_inode_dirty() by testing
> >for the poison values inside inode, but they seem to be perfectly fine there and still
> >show up as bad within mark_inode_dirty().
> >
> >Then I tried trapping it inside mark_inode_dirty(), but at that point I usually get garbage
> >inside inode, and have no way to go back to dentry.
> >
> >Right now I'm just trying to dump everything that goes through simple_setattr() in hopes that
> >I could easily figure out what went wrong by looking at the log, but that just stops the bug
> >from reproducing.
> 
> I've tried the following code in simple_setattr() right before the call to mark_inode_dirty():
> 
>         p = dentry_path(dentry, pth, 200);
>         printk(KERN_ERR "doh: %s %s\n", p, inode->i_sb->s_type->name);
> 
> but it seems that while 'p' ends up being "/", inode->i_sb is garbage and we can't pull out anything
> about the file system.
  By garbage, do you mean that it is a poison, completely random data or does
inode->i_sb look like a valid pointer but just superblock isn't where it
points to?

> Any way I could get anything useful any other way?
  Hum, can you dump the whole contents of 'dentry' at that place? Maybe it
will tell us something.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
