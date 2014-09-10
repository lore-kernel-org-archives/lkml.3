Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaIJJn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:43:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:40099 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaIJJn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:43:26 -0400
Date: Wed, 10 Sep 2014 13:43:18 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140910094318.GA19472@paralelels.com>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
 <20140909012712.GV7996@ZenIV.linux.org.uk>
 <20140909085439.GB25034@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140909085439.GB25034@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:54:39AM +0200, Jan Kara wrote:
> On Tue 09-09-14 02:27:12, Al Viro wrote:
> > On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
> > > Currently watchers are removed in dentry_iput(), if n_link is zero.
> > > But other detries can be linked with this inode. For example if we
> > > create two hard links, open the first one and set a watcher on the
> > > second one. Then if we remove both links, the watcher will be removed.
> > > But we will have the alive file descriptor, which allows us to generate
> > > more events.
> > > 
> > > With this patch, watchers will be removed, only if nlink is zero and
> > > i_dentry list is empty.
> > 
> > It changes user-visible ABI.  Worse yet, this "ABI" has no specification,
> > so any (misguided) software using that FPOS has nothing to go by other than
> > "whatever existing kernels do".  As the result, inotify behaviour is cast
> > in concrete.
>   I agree that it changes user-visible ABI and I agree the behavior isn't
> really specified in the manpage. However our position has always been you can
> change stuff unless someone complains. In this case the current behavior
> is: If you just unlink opened file, you keep getting inotify events for that
> inode. Also if you do sequence like:
>         fd = inotify_init1(IN_NONBLOCK);
>         deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
>         link(path, path_link);
>         wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
> 
>         unlink(path_link);
>         unlink(path);
> 
> You will also keep getting inotify events for that inode (the first unlink
> will naturally just generate ATTRIB event, the second unlink will fail the
> test:
> 	if (dentry->d_lockref.count == 1) {
> in d_delete() and thus won't call dentry_unlink_inode() which would delete
> inotify watch.
> 
> However if you do sequence like:
>         fd = inotify_init1(IN_NONBLOCK);
>         deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
>         link(path, path_link);
>         wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
> 
>         unlink(path);	/* Note swapped unlink order */
>         unlink(path_link);
> 
> You will stop getting inotify events for the inode.
> 
> That's so stupid and inconsistent (plus the behavior of this already
> changed in the past as my tests with older kernels show) that I'm convinced
> noone really depends on this. So I'm for fixing the bug even though it has
> userspace visible impact.

I want to support this suggestion. This patch fixes the case, which is
not widely used. And I think it's a reason why it has not fixed before.
In CRIU we have code which is used this behaviour. This code was written
based on the common sense and we have surprised to know that it doesn't work.
I think if something is not in a specification and it doesn't base on the
common sense, it's most likely a bug rather than ABI.

I have executed inotify tastcases form LTP test suite. They say nothing
wrong here. It's just in case if it has some sense for someone.

[root@avagin-fc19-cr inotify]# ./inotify01 
inotify01    1  TPASS  :  get event: wd=1 mask=4 cookie=0 len=0
inotify01    2  TPASS  :  get event: wd=1 mask=20 cookie=0 len=0
inotify01    3  TPASS  :  get event: wd=1 mask=1 cookie=0 len=0
inotify01    4  TPASS  :  get event: wd=1 mask=10 cookie=0 len=0
inotify01    5  TPASS  :  get event: wd=1 mask=20 cookie=0 len=0
inotify01    6  TPASS  :  get event: wd=1 mask=2 cookie=0 len=0
inotify01    7  TPASS  :  get event: wd=1 mask=8 cookie=0 len=0
[root@avagin-fc19-cr inotify]# ./inotify02 
inotify02    1  TPASS  :  get event: wd=1 mask=40000004 cookie=0 len=0 name=""
inotify02    2  TPASS  :  get event: wd=1 mask=100 cookie=0 len=16 name="test_file1"
inotify02    3  TPASS  :  get event: wd=1 mask=20 cookie=0 len=16 name="test_file1"
inotify02    4  TPASS  :  get event: wd=1 mask=8 cookie=0 len=16 name="test_file1"
inotify02    5  TPASS  :  get event: wd=1 mask=40 cookie=1102 len=16 name="test_file1"
inotify02    6  TPASS  :  get event: wd=1 mask=80 cookie=1102 len=16 name="test_file2"
inotify02    7  TPASS  :  get event: wd=1 mask=800 cookie=0 len=0 name=""
inotify02    8  TPASS  :  get event: wd=1 mask=200 cookie=0 len=16 name="test_file2"
inotify02    9  TPASS  :  get event: wd=1 mask=800 cookie=0 len=0 name=""
[root@avagin-fc19-cr inotify]# ./inotify03 
inotify03    0  TINFO  :  Found free device '/dev/loop0'
inotify03    0  TINFO  :  Formatting /dev/loop0 with ext2 extra opts=''
mke2fs 1.42.8 (20-Jun-2013)
inotify03    0  TINFO  :  mount /dev/loop0 to mntpoint fs_type=ext2
inotify03    0  TINFO  :  umount /dev/loop0
inotify03    1  TPASS  :  get event: wd=1 mask=2000 cookie=0 len=0
inotify03    2  TPASS  :  get event: wd=1 mask=8000 cookie=0 len=0
inotify03    3  TPASS  :  inotify_rm_watch (3, 1) returned EINVAL
[root@avagin-fc19-cr inotify]# ./inotify04 
inotify04    1  TPASS  :  got event: wd=1 mask=400 cookie=0 len=0 name=""
inotify04    2  TPASS  :  got event: wd=1 mask=8000 cookie=0 len=0 name=""
inotify04    3  TPASS  :  got event: wd=2 mask=4 cookie=0 len=0 name=""
inotify04    4  TPASS  :  got event: wd=2 mask=400 cookie=0 len=0 name=""
inotify04    5  TPASS  :  got event: wd=2 mask=8000 cookie=0 len=0 name=""
[root@avagin-fc19-cr inotify]# ./inotify05 
inotify05    1  TPASS  :  get event: wd=-1 mask=4000 cookie=0 len=0

Thanks,
Andrew

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
