Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaCYRdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:33:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbaCYRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:33:45 -0400
Date: Tue, 25 Mar 2014 18:33:40 +0100
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140325173340.GB17292@quack.suse.cz>
References: <20140303214040.GA15265@quack.suse.cz>
 <53166920.709@oracle.com>
 <20140305124536.GA32371@quack.suse.cz>
 <53189BF8.1010308@oracle.com>
 <531A7CFD.9030603@oracle.com>
 <20140310104350.GB28797@quack.suse.cz>
 <531DC89A.9010601@oracle.com>
 <53304451.7030800@oracle.com>
 <20140324214851.GB10057@quack.suse.cz>
 <5330D15E.2000702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5330D15E.2000702@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24-03-14 20:44:14, Sasha Levin wrote:
> On 03/24/2014 05:48 PM, Jan Kara wrote:
> >>>[  339.948946] ** 4194304 ffff8805ac03ba38 [eventpoll] ffff8806ec051fe0
> >>>[eventpoll] ffffffff84666040 ffff88056c73e7b0           (null)
> >   OK, great. So finally we have something useful. We know we have problems
> >with [eventpoll] dentry. That is actually a special filesystem not mounted
> >anywhere - likely you get to that dentry through/proc/<pid>/fd/. Now
> >eventpoll is interesting because it uses single anon inode for all
> >eventpoll instances. And that inode should stay in place as long as
> >eventpoll filesystem exists. So it's not clear how come that inode is
> >freed. The basic check of handling of inode use count didn't find anything
> >suspicious. But I can check in more detail and if I fail, we now have a
> >pretty narrow area where to look...
> 
> Seems like it's not specific to eventpoll, I saw the same error message with
> "eventfd" and "perf_event".
  Yup, all these use anon_inode_getfile() so it all points to the fact that
for some reason we freed anon_inode_inode. But I don't see where the
problem is. Can you maybe make 'anon_inode_inode' external to
fs/anon_inodes.c and dump stack for all iput() calls to anon_inode_inode?
There must be some suckers which don't belong there...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
