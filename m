Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3CRKse (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 18 Mar 2013 06:48:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64552 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3CRKsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:48:31 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 18 Mar 2013 16:18:11 +0530
Message-ID: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
Subject: Beyond inotify recursive watches
To: linux-kernel@vger.kernel.org
Cc: Junio C Hamano <gitster@pobox.com>, Thomas Rast <trast@inf.ethz.ch>,
        =?UTF-8?B?RHV5IE5ndXnhu4Vu?= <pclouds@gmail.com>,
        Jeff King <peff@peff.net>, Karsten Blees <karsten.blees@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We, the Git folks, were wondering how to speed things up.  In an
strace of "git status" on linux-2.6.git, we found:

  top syscalls sorted     top syscalls sorted
  by acc. time            by number
  ----------------------------------------------
  0.401906 40950 lstat    0.401906 40950 lstat
  0.190484 5343 getdents  0.150055 5374 open
  0.150055 5374 open      0.190484 5343 getdents
  0.074843 2806 close     0.074843 2806 close
  0.003216 157 read       0.003216 157 read

Most of this happens when we try to build the index, querying for
changes in tracked files and discovering untracked files.  It was
suggested that we can use inotify to speed things up: we'll write a
user-wide daemon (like ssh_client) that will set up watches on each
directory of each git repository.  A repository-wide daemon wouldn't
work because /proc/sys/fs/inotify/max_user_instances reads 128 on
typical linux-3.8 systems, and this is problematic.

However, Karsten and Junio point out that our efforts might be futile
as we are trying to do what the VFS caching already does, and doing it
poorly.  Speedups, if any, would be minor and certainly not worth the
effort.

I think inotify is a poorly suited solution for our needs, as setting
up recursive watches is horribly inelegant.  I think it's a
well-suited solution for something like Dropbox, which just executes
something when there's a change in a specified directory.  Also, I
suspect VFS caching works by optimizing filesystem calls for
frequently used directory entries.  A git repository is not a
collection of frequently-used directory entries, but a frequently used
unit.  I know very little about how VFS works, but I'm wondering if we
can make any changes in VFS to make it perform better with git
repositories.  We won't need something as fine-grained as inotify: if
the tree hash of a directory entry changes frequently enough, optimize
all filesystem calls to inodes in the directory recursively.
Recursively optimizing a directory is useless in the general case, and
I would imagine something like a new rwatch() syscall for git to
register the repository with VFS.  All system calls will then be
magically optimized, and few changes need to be made to git.  The
added side-benefit is that all other version control systems can use
it too.

Thanks for reading.

Ram
