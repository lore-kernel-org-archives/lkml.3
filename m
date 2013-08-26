Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3HZPjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:39:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab3HZPjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:39:23 -0400
Date: Mon, 26 Aug 2013 17:33:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130826153301.GA15890@redhat.com>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Linus Torvalds wrote:
>
> On Sun, Aug 25, 2013 at 12:48 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > pid_revalidate() does inode->i_*id = GLOBAL_ROOT_*ID if task_dumpable()
> > fails, but it can fail simply because ->mm = NULL.
> >
> > This means that almost everything in /proc/zombie-pid/ becomes root.
> > Doesn't really hurt, but for what? Looks a bit strange imho.
>
> The zombie case shouldn't be relevant, because a zombie will have
> closed all the file descriptors anyway, so they no longer exist.

I specially mentioned that this is off-topic ;)

> That said, task_dumpable isn't wonderful, and I suspect we could drop
> that logic entirely in the tid-fd case if we just use f_cred.

Probably yes, but I do not understand this S_IFLNK && uid/chmod magic
in tid_fd_revalidate(). And afaics this should not affect readlink()
anyway. So yes, ->f_cred makes more sense to me, but I can't comment.


But, afaics, speaking of task_dumpable() this doesn't matter. Please
forget about /proc/fd or zombies. I can't even understand
proc_pid_make_inode() or pid_revalidate().

	$ id
	uid=1000(tst) gid=100(users) groups=100(users)
	$ cp `which ls` ls
	$ chmod a-r ./ls
	$
	$ ./ls -l /proc/self/
	total 0
	-r-------- 1 root root  0 Aug 26 06:35 auxv
	-r--r--r-- 1 root root  0 Aug 26 06:35 cgroup
	--w------- 1 root root  0 Aug 26 06:35 clear_refs
	-r--r--r-- 1 root root  0 Aug 26 06:35 cmdline
	-rw-r--r-- 1 root root  0 Aug 26 06:35 comm
	-rw-r--r-- 1 root root  0 Aug 26 06:35 coredump_filter
	lrwxrwxrwx 1 root root  0 Aug 26 06:35 cwd -> /home/tst
	-r-------- 1 root root  0 Aug 26 06:35 environ
	lrwxrwxrwx 1 root root  0 Aug 26 06:35 exe -> /home/tst/ls
	dr-x------ 2 root root  0 Aug 26 06:35 fd
	dr-x------ 2 root root  0 Aug 26 06:35 fdinfo
	-rw-r--r-- 1 root root  0 Aug 26 06:35 gid_map
	-r--r--r-- 1 root root  0 Aug 26 06:35 limits
	-r--r--r-- 1 root root  0 Aug 26 06:35 maps
	-rw------- 1 root root  0 Aug 26 06:35 mem
	-r--r--r-- 1 root root  0 Aug 26 06:35 mountinfo
	-r--r--r-- 1 root root  0 Aug 26 06:35 mounts
	-r-------- 1 root root  0 Aug 26 06:35 mountstats
	dr-xr-xr-x 4 tst  users 0 Aug 26 06:35 net
	dr-x--x--x 2 root root  0 Aug 26 06:35 ns
	-rw-r--r-- 1 root root  0 Aug 26 06:35 oom_adj
	-r--r--r-- 1 root root  0 Aug 26 06:35 oom_score
	-rw-r--r-- 1 root root  0 Aug 26 06:35 oom_score_adj
	-r--r--r-- 1 root root  0 Aug 26 06:35 pagemap
	-r--r--r-- 1 root root  0 Aug 26 06:35 personality
	-rw-r--r-- 1 root root  0 Aug 26 06:35 projid_map
	lrwxrwxrwx 1 root root  0 Aug 26 06:35 root -> /
	-r--r--r-- 1 root root  0 Aug 26 06:35 smaps
	-r--r--r-- 1 root root  0 Aug 26 06:35 stack
	-r--r--r-- 1 root root  0 Aug 26 06:35 stat
	-r--r--r-- 1 root root  0 Aug 26 06:35 statm
	-r--r--r-- 1 root root  0 Aug 26 06:35 status
	-r--r--r-- 1 root root  0 Aug 26 06:35 syscall
	dr-xr-xr-x 3 tst  users 0 Aug 26 06:35 task
	-rw-r--r-- 1 root root  0 Aug 26 06:35 uid_map
	-r--r--r-- 1 root root  0 Aug 26 06:35 wchan

For what? Say,

	-r--r--r-- 1 root root  0 Aug 26 06:35 status

but it is S_IRUGO anyway, why do we need to change the owner?

	dr-x------ 2 root root  0 Aug 26 06:35 fd

OK, this means that I can't access this dir from another process.
Not sure we really want this in this case but

	$ ./ls /proc/self/fd
	0  1  2  3

still works, I guess thanks to proc_fd_permission().

However, say,

	-r-------- 1 root root  0 Aug 26 06:35 mountstats

actually becomes unreadable even via /proc/self/.

Imho, this all is confusing. Perhaps it makes sense to "chmod", say,
/proc/pid/maps if !task_dumpable(), but "chown" looks strange.

Oleg.

