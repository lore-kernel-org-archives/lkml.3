Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161956Ab3DEPzk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 5 Apr 2013 11:55:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161724Ab3DEPzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:55:39 -0400
Date: Fri, 5 Apr 2013 17:55:34 +0200
From: Jan Kara <jack@suse.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Thomas Rast <trast@inf.ethz.ch>,
        Duy =?utf-8?B?Tmd1eeG7hW4=?= <pclouds@gmail.com>,
        Jeff King <peff@peff.net>, Karsten Blees <karsten.blees@gmail.com>
Subject: Re: Beyond inotify recursive watches
Message-ID: <20130405155534.GC21852@quack.suse.cz>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Mon 18-03-13 16:18:11, Ramkumar Ramachandra wrote:
> We, the Git folks, were wondering how to speed things up.  In an
> strace of "git status" on linux-2.6.git, we found:
> 
>   top syscalls sorted     top syscalls sorted
>   by acc. time            by number
>   ----------------------------------------------
>   0.401906 40950 lstat    0.401906 40950 lstat
>   0.190484 5343 getdents  0.150055 5374 open
>   0.150055 5374 open      0.190484 5343 getdents
>   0.074843 2806 close     0.074843 2806 close
>   0.003216 157 read       0.003216 157 read
> 
> Most of this happens when we try to build the index, querying for
> changes in tracked files and discovering untracked files.  It was
> suggested that we can use inotify to speed things up: we'll write a
> user-wide daemon (like ssh_client) that will set up watches on each
> directory of each git repository.  A repository-wide daemon wouldn't
> work because /proc/sys/fs/inotify/max_user_instances reads 128 on
> typical linux-3.8 systems, and this is problematic.
> 
> However, Karsten and Junio point out that our efforts might be futile
> as we are trying to do what the VFS caching already does, and doing it
> poorly.  Speedups, if any, would be minor and certainly not worth the
> effort.
> 
> I think inotify is a poorly suited solution for our needs, as setting
> up recursive watches is horribly inelegant.  I think it's a
> well-suited solution for something like Dropbox, which just executes
> something when there's a change in a specified directory.  Also, I
> suspect VFS caching works by optimizing filesystem calls for
> frequently used directory entries.  A git repository is not a
> collection of frequently-used directory entries, but a frequently used
> unit.  I know very little about how VFS works, but I'm wondering if we
> can make any changes in VFS to make it perform better with git
> repositories.  We won't need something as fine-grained as inotify: if
> the tree hash of a directory entry changes frequently enough, optimize
> all filesystem calls to inodes in the directory recursively.
> Recursively optimizing a directory is useless in the general case, and
> I would imagine something like a new rwatch() syscall for git to
> register the repository with VFS.  All system calls will then be
> magically optimized, and few changes need to be made to git.  The
> added side-benefit is that all other version control systems can use
> it too.
  Hum, I have somewhat hard time to understand what do you mean by
'magically optimized syscalls'. What should happen in VFS to speedup your
load?

What your question reminds me is an idea of recursive modification time
stamp on directories. That is a time stamp that gets updated whenever
anything in the tree under the directory changes. Now this would be too
expensive to maintain so there's also a trick implemented that you update
the time stamp (and continue updating recursive time stamps upwards) only
if a special flag is set on the directory. And you clear the flag at that
moment. So until someone checks the time stamp and resets the flag no
further updates of the recursive modification time happen.

This scheme works for arbitrary number of processes interested in recursive
time stamps (only updates of the time stamps get more frequent). What is
somewhat inconvenient is that this only tells you something in the
directory or its subtree changed so you still have to scan all the
directories on the path to modified file. So I'm not sure of how much use
this would be to you.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
