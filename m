Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3HYSvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:51:09 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:49102 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3HYSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130825065039.GB9299@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
	<CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
	<20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
	<CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com>
	<20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
Date: Sun, 25 Aug 2013 11:51:06 -0700
X-Google-Sender-Auth: vaUg7vfbpbFFIb_zzunXUGkGny4
Message-ID: <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
Subject: Re: /proc/pid/fd && anon_inode_fops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 11:50 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> Thanks for explaining Al, that really helps me understand. However
> there's still a difference between /proc/pid called from the process
> itself (=/proc/self) and called from other processes that seems to
> suit the situation :

/proc/self has magic special properties, as you noticed.

> Thus I'm wondering if something like this could help, the idea would be
> that a with the appropriate mount option, a task could only look at its
> own descriptors unless it's running with privileges :

I'd much rather try to do it in general, and use "file->f_cred" more
aggressively for /proc/<pid>/fd/ security.

We don't use f_cred at all in /proc, but that's because /proc predates
that whole thing. So instead we use the credentials of the task when
we want to look at credentials of the file, because that was the
closest approximation we used to have.

Look at the code that creates the fd stat information, for example.
It's in tid_fd_revalidate(), and it really doesn't make much sense to
use the task credentials for it. I wonder if we should do something
like the appended (whitespace-damaged and totally untested) patch.

                Linus

---
  diff --git a/fs/proc/fd.c b/fs/proc/fd.c
  index 75f2890abbd8..2a5a53cc7a0a 100644
  --- a/fs/proc/fd.c
  +++ b/fs/proc/fd.c
  @@ -74,7 +74,6 @@ static int tid_fd_revalidate(struct dentry
*dentry, unsigned int flags)
   {
          struct files_struct *files;
          struct task_struct *task;
  -       const struct cred *cred;
          struct inode *inode;
          int fd;

  @@ -95,19 +94,17 @@ static int tid_fd_revalidate(struct dentry
*dentry, unsigned int flags)
                          if (file) {
                                  unsigned f_mode = file->f_mode;

  -                               rcu_read_unlock();
  -                               put_files_struct(files);
  -
                                  if (task_dumpable(task)) {
  -                                       rcu_read_lock();
  -                                       cred = __task_cred(task);
  +                                       const struct cred *cred =
file->f_cred;
                                          inode->i_uid = cred->euid;
                                          inode->i_gid = cred->egid;
  -                                       rcu_read_unlock();
                                  } else {
                                          inode->i_uid = GLOBAL_ROOT_UID;
                                          inode->i_gid = GLOBAL_ROOT_GID;
                                  }
  +                               rcu_read_unlock();
  +                               put_files_struct(files);
  +

                                  if (S_ISLNK(inode->i_mode)) {
                                          unsigned i_mode = S_IFLNK;
