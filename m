Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaIPVMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:12:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaIPVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:12:16 -0400
Date: Tue, 16 Sep 2014 23:12:11 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.debian@gmx.de>
Cc: Andrew Vagin <avagin@parallels.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140916211211.GG1205@quack.suse.cz>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
 <20140909012712.GV7996@ZenIV.linux.org.uk>
 <20140909085439.GB25034@quack.suse.cz>
 <20140910094318.GA19472@paralelels.com>
 <54146D8D.9090708@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54146D8D.9090708@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 13-09-14 18:15:09, Heinrich Schuchardt wrote:
> On Tue 09-09-14 02:27:12, Al Viro wrote:
> http://lkml.org/lkml/2014/9/8/762
> > I agree that it changes user-visible ABI and I agree the behavior
> > isn't really specified in the manpage.
> 
> Shouldn't we start with putting the expected behavior into the
> manpage before patching the code? I am missing a patch for
> man7/inotify.7.
  Good idea. Thanks for bringing this up. And ideally we should write it
down before settling for a solution to this problem. Because when thinking
about it again, some details of the behavior are still vague.

> On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
> http://lkml.org/lkml/2014/9/8/219
> >
> > 	fd = inotify_init1(IN_NONBLOCK);
> > 	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
> > 	link(path, path_link);
> >
> > 	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
> >
> > 	unlink(path);
> > 	unlink(path_link);
> >
> > 	printf(" --- unlink\n");
> > 	read_evetns(fd);
> >
> > 	close(deleted);
> > 	printf(" --- close\n");
> > 	read_evetns(fd);
> >
> > Without this patch:
> >   --- unlink
> > 4	(IN_ATTRIB)
> > 400	(IN_DELETE_SELF)
> > 8000	(IN_IGNORED)
> >   --- close
> > FAIL
> >
> > With this patch:
> >   --- unlink
> > 4	(IN_ATTRIB)
> > 400	(IN_DELETE_SELF)
> >   --- close
> > 8	(IN_CLOSE_WRITE)
> > 400	(IN_DELETE_SELF)
> > 8000	(IN_IGNORED)
> > PASS
> 
> Shouldn't the second IN_DELETE_SELF occur before
> --- close ?
> Why is IN_CLOSE_WRITE created?
  So I would like events to be generated until the watched inode really
gets deleted. This way simple (non-hardlinked) file behaves and that's what
seems "natural". In this light generating IN_CLOSE_WRITE is what we want to
do.

Generation of IN_DELETE_SELF is less obvious I think. Do we want to
generate IN_DELETE_SELF for each hardlink to the inode that gets removed? I
don't think so (this actually would be too visible user API change IMHO).
To match the single link case I think we want to generate IN_DELETE_SELF
when the last link to the file is removed. But then generating it twice
like we would do with the above patch is wrong... Opinions?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
