Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaIIIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:54:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaIIIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:54:43 -0400
Date: Tue, 9 Sep 2014 10:54:39 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140909085439.GB25034@quack.suse.cz>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
 <20140909012712.GV7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909012712.GV7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-09-14 02:27:12, Al Viro wrote:
> On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
> > Currently watchers are removed in dentry_iput(), if n_link is zero.
> > But other detries can be linked with this inode. For example if we
> > create two hard links, open the first one and set a watcher on the
> > second one. Then if we remove both links, the watcher will be removed.
> > But we will have the alive file descriptor, which allows us to generate
> > more events.
> > 
> > With this patch, watchers will be removed, only if nlink is zero and
> > i_dentry list is empty.
> 
> It changes user-visible ABI.  Worse yet, this "ABI" has no specification,
> so any (misguided) software using that FPOS has nothing to go by other than
> "whatever existing kernels do".  As the result, inotify behaviour is cast
> in concrete.
  I agree that it changes user-visible ABI and I agree the behavior isn't
really specified in the manpage. However our position has always been you can
change stuff unless someone complains. In this case the current behavior
is: If you just unlink opened file, you keep getting inotify events for that
inode. Also if you do sequence like:
        fd = inotify_init1(IN_NONBLOCK);
        deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
        link(path, path_link);
        wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);

        unlink(path_link);
        unlink(path);

You will also keep getting inotify events for that inode (the first unlink
will naturally just generate ATTRIB event, the second unlink will fail the
test:
	if (dentry->d_lockref.count == 1) {
in d_delete() and thus won't call dentry_unlink_inode() which would delete
inotify watch.

However if you do sequence like:
        fd = inotify_init1(IN_NONBLOCK);
        deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
        link(path, path_link);
        wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);

        unlink(path);	/* Note swapped unlink order */
        unlink(path_link);

You will stop getting inotify events for the inode.

That's so stupid and inconsistent (plus the behavior of this already
changed in the past as my tests with older kernels show) that I'm convinced
noone really depends on this. So I'm for fixing the bug even though it has
userspace visible impact.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
