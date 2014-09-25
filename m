Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaIYIaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:30:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaIYIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:30:16 -0400
Date: Thu, 25 Sep 2014 10:30:10 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.debian@gmx.de>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s (v2)
Message-ID: <20140925083010.GA3096@quack.suse.cz>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
 <20140924105155.GA24411@quack.suse.cz>
 <20140924131947.bc083e7f34981bbf73a364f1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924131947.bc083e7f34981bbf73a364f1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-09-14 13:19:47, Andrew Morton wrote:
> On Wed, 24 Sep 2014 12:51:55 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> >   Hello,
> > 
> >   Andrew, what do you think about the patch below? Al objected that it
> > changes userspace visible behavior some time ago and then he didn't react
> > to our explanations...
> 
> Difficult situation.  There's some really important information missing
> from the changelog:
> 
> - Who cares?  Is there some real application which is hurting from
>   the current situation?  If so, who, what, how and why.  If not, then
>   why change anything?
  I believe Openvz guys hit this in their application but I'll defer to
them for more details.

> - A description of the userspace API change impact.  How did the
>   interface change?  What is the risk of this change causing damage to
>   real applications?
  I believe this was covered in the changelog. Without the patch depending
on the order of unlinks for hardlinked file you sometimes get events:
4       (IN_ATTRIB)
400     (IN_DELETE_SELF)
8000    (IN_IGNORED)

and sometimes you get events:
4       (IN_ATTRIB)
<possibly more events happening for unlinked file>
8       (IN_CLOSE_WRITE)
400     (IN_DELETE_SELF)
8000    (IN_IGNORED)

With the patch you'll always have the second case. So without the patch you
don't receive some events if the file has at least 2 hardlinks and then
gets unlinked. I think the risk that some application relies on *not* getting
those events is pretty low (especially since in the common case of file
without hardlinks you will get all those events).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
