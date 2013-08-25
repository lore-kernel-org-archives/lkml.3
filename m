Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3HYGuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 02:50:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35589 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab3HYGuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 02:50:51 -0400
Date: Sun, 25 Aug 2013 08:50:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130825065039.GB9299@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825052317.GZ27005@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 06:23:17AM +0100, Al Viro wrote:
> On Sat, Aug 24, 2013 at 11:24:32PM +0200, Willy Tarreau wrote:
> 
> > I doubt it. It seems to me that most such entries are implemented
> > for completeness while most valid uses only concern /proc/self/fd.
> > Maybe if we had an option so that only /proc/self/fd would actually
> > allow to access the fds while all /proc/pid/fd would only show what
> > they map to, it would be a good step forward.
> 
> How?  The fundamental problem is not visibility of that stuff, it's
> new opened file for the same object (Linux behaviour) vs. new descriptor
> refering to the same opened file (*BSD and friends).  We can't get
> anon_... sanely reopened in the former semantics and they are very
> visibly different for regular files, so switching to *BSD one is not
> feasible - too high odds of userland breakage.  The difference in
> semantics, of course, is that on Linux opening /dev/stdin gives you
> a descriptor with independent current IO position; on *BSD you get
> a descriptor sharing the current IO position with stdin.  IOW, it's
> independent open() of the same file vs. dup().
> 
> We are really stuck with the current semantics here - switching to
> *BSD one would not only mean serious surgery on descriptor handling
> (it's one of the wartier areas in *BSD VFS, in large part because
> of magic-open-really-a-dup kludges they have to do), it would change
> a long-standing userland API that had been there for nearly 20 years
> _and_ one that tends to be used in corner cases of hell knows how many
> scripts.

Thanks for explaining Al, that really helps me understand. However
there's still a difference between /proc/pid called from the process
itself (=/proc/self) and called from other processes that seems to
suit the situation :

  willy@eeepc:~$ ls -la /tmp/bash 
  -r-x--x--x 1 root users 916852 2013-08-25 08:19 /tmp/bash*
  willy@eeepc:~$ exec /tmp/bash -i
  willy@eeepc:~$ echo $$
  22678
  willy@eeepc:~$ ls -la /proc/22678/fd
  ls: cannot open directory /proc/22678/fd: Permission denied
  willy@eeepc:~$ ls -la /proc/22678/exe 
  ls: cannot read symbolic link /proc/22678/exe: Permission denied
  willy@eeepc:~$ cat /proc/22678/fd/0 
  cat: /proc/22678/fd/0: Permission denied

but :
  willy@eeepc:~$ read < /proc/22678/fd/0 
  azerazerazer
  willy@eeepc:~$ echo $REPLY
  azerazerazer

strace clearly shows that the process was allowed to inspect itself
and the other ones were not :

  willy@eeepc:~$ strace -p 22678
  open("/proc/22678/fd/0", O_RDONLY|O_LARGEFILE) = 3

  willy@eeepc:~$ strace cat /proc/22678/fd/0 
  open("/proc/22678/fd/0", O_RDONLY|O_LARGEFILE) = -1 EACCES (Permission denied)

It looks like this difference was introduced by this patch (which also fixes
this issue we've been having for a very long time on 2.4 and early 2.6) :

    8948e11 Allow access to /proc/$PID/fd after setuid()

Thus I'm wondering if something like this could help, the idea would be
that a with the appropriate mount option, a task could only look at its
own descriptors unless it's running with privileges :

    static int proc_fd_permission(struct inode *inode, int mask,
                                  struct nameidata *nd)
    {
       if (task_pid(current) == proc_pid(inode))
             return 0;
       if (capable(CAP_DAC_OVERRIDE))
             return 0;
       if (proc_mounted_with_strict_option)
             return -EACCES;
       return generic_permission(inode, mask, NULL);
    }

Thus it would not change the default behaviour except for people who would
mount /proc with a special option.

Thanks,
Willy

