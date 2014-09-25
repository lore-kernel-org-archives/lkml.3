Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaIYUio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:38:44 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59962 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIYUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:38:41 -0400
Date: Fri, 26 Sep 2014 00:38:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.debian@gmx.de>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s (v2)
Message-ID: <20140925203837.GP2227@moon>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
 <20140924105155.GA24411@quack.suse.cz>
 <20140924131947.bc083e7f34981bbf73a364f1@linux-foundation.org>
 <20140925083010.GA3096@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925083010.GA3096@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:30:10AM +0200, Jan Kara wrote:
> On Wed 24-09-14 13:19:47, Andrew Morton wrote:
> > On Wed, 24 Sep 2014 12:51:55 +0200 Jan Kara <jack@suse.cz> wrote:
> > 
> > >   Hello,
> > > 
> > >   Andrew, what do you think about the patch below? Al objected that it
> > > changes userspace visible behavior some time ago and then he didn't react
> > > to our explanations...
> > 
> > Difficult situation.  There's some really important information missing
> > from the changelog:
> > 
> > - Who cares?  Is there some real application which is hurting from
> >   the current situation?  If so, who, what, how and why.  If not, then
> >   why change anything?
>   I believe Openvz guys hit this in their application but I'll defer to
> them for more details.

Hi, sorry for delay! Indeed we found this weird behaviour while been testing
the results of restore of deleted files. When criu observes opened descriptor on
deleted file its contents get written into criu image file which we call "ghost"
files. On restore we create a temporary ghost file with some unique name. Then
we restore file descriptors which were opened at the moment of checkpoint:
we create a hardlink to this ghost file, then open it and this is done for every
descriptor we need to recover. Then if there were a watch mark on the ghost
file we restore them as well but at the end we need to do a cleanup and finally
remove the ghost file itself which cause the problem mentioned in Andrew's changelog
to appear -- when we remove ghost file inode->n_link becomes 0 thus our restored
inotify are dropped off by the kernel while here still opened files are floating
around. I can't say that it's catastrophical but if there a chance to fix it
on kernel level making events flow more sane, this would be just great, also
our primary target is to make c/r process transparent to the userspace and
without the patch i fear we can't reach it.
