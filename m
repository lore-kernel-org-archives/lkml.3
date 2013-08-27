Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3H0XNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:13:35 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:52056 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3H0XNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:13:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130827230827.GI27005@ZenIV.linux.org.uk>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
 <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net> <20130827230827.GI27005@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Aug 2013 16:13:12 -0700
Message-ID: <CALCETrWi7_ObM58oeSUahzvNVsrjGSgsqfRSXWoUcEpYVby=Ng@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 4:08 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 27, 2013 at 12:16:34PM -0700, Andy Lutomirski wrote:
>> This is an experiment to see if we can get nice semantics for all syscalls
>> that either follow symlinks or allow AT_EMPTY_PATH without jumping through
>> enormous hoops.  This converts truncate (although you can't tell using
>> truncate from coreutils, because it actually uses open + ftruncate).
>>
>> The basic idea is that there's a new helper function
>> user_file_or_path_at.  It takes an fd and a path and, depending on
>> flags, the emptiness of the path, and whether path is a magic /proc
>> symlink (or a symlink to a magic /proc/symlink), it returns either a
>> struct path or a struct file *.
>
> No.

I'm curious what's wrong with the general concept.  (I agree that the
implementation is heinous.)

If I ever wanted to add a new *at syscall, I'd like to be able to do:

int sys_whateverat(int dfd, const char __user *name, int flags)
{
  resolve_the_thing(dfd, name, flags);
  if (it's a file) {
    check fmode;
  } else {
    inode_permission();
  }

  actually_do_something(inode);

  unreference_whatever_i_got();

  return ret;
}

thereby killing the fwhatever and whateverat birds with one stone.


>
>> +     path_get(&nd->path);
>> +     if (nd->flags & LOOKUP_FILE) {
>> +             if (nd->last_symlink_file)
>> +                     fput(nd->last_symlink_file);
>> +             nd->last_symlink_file = file;
>
> This is ugly (and costs quite a bit of overhead)
>
>> -static int proc_cwd_link(struct dentry *dentry, struct path *path)
>> +static int proc_cwd_link(struct dentry *dentry, struct file_or_path *link)
>
> ... and this is even more vile.  Vetoed, for being too ugly to live.

...phew.  I wasn't looking forward to testing and debugging my crap :)

--Andy
