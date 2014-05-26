Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaEZNjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:39:42 -0400
Received: from numidia.opendz.org ([98.142.220.152]:52182 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaEZNjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:39:41 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 0/9] procfs: smooth steps to secure some /proc/<pid>/*
Date: Mon, 26 May 2014 14:27:21 +0100
Message-Id: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series to apply on top of next-20140526

Some /proc/<pid>/* are sensitive files that need appropriate permission
checks.

Currently there are two issues with these files, to summarize:
1) unprivileged process:
   open("/proc/1/*", O_RDONLY)
   and passes the fd to something privileged.

   This affects already running deamons and processes.

2) unprivileged process:
   open("/proc/self/*", O_RDONLY) and forks.
   The parent execve a privileged process.

   This affects processes that are executed by that user...

   The only restriction: is to find a privileged program that reads
   from the specified input. Determined attackers may find one...

   Some distro just don't chip these suid binaries.


A months ago I've sent a series to use file->f_cred during ->read()
to protect the sensitive entries:
https://lkml.org/lkml/2013/10/1/371

That solution was rejected, Ok.

It seems that every body is busy, and in the mean time these files are
exposed, and can be used to bypass ASLR. So I propose here smooth steps
to secure at least issue (1) and it works without breaking userspace,
but it does not cover all files. If this series is Ack-ed I'll send
another series to handle the left ones.


For issue (2) from the file->f_cred discussion:
https://lkml.org/lkml/2013/10/1/371

Every one seems to want a mechanism to revoke the fd. Yes I do agree, it
should be the best solution. However it should not stop us from handling
issue (1).


So to solve issue (1) of *already* *running* processes:

I start with the entries that contain sensitive info and at the same
time are world readable:
/proc/<pid>/stat
/proc/<pid>/wchan
/proc/<pid>/maps  (will be handled in next patches).

/proc/<pid>/{stack|syscall} I add the ptrace capability check and cache
it.


The following scheme is used in order to prevent ASLR leaks:
a) Perform permission checks during ->open()
b) Cache the result of a) and return succes
c) Recheck the cached result during ->read()
d) If cached == DENY:
   then we replace the sensitive fields with zeros, userspace won't
   break and sensitive fields are protected.

   As proposed by Ingo and as it's currently done for /proc/*/stat:
   https://lkml.org/lkml/2013/10/3/203


Some of these files use sequence iterators, and have their proper
internal logic. I've made sure that we don't change this logic nor the
handlers. The only change is: make the cached permission check done
during ->open() available during ->read().

This design will also cover every one concerns about LSM, especially
the YAMA module.


As I've said the logic of the handlers of these files did not change, I
just made the cached permission available. This should work with any
future improvements.


Please, if time permits do review!

Thanks!


Patches:

1) Preparation for the whole series:
Patch 1/9: preparation patch to add flags to deny or allow access.
Patch 2/9: preparation patch to unify the permission checks.
           The new pid_entry_access() can be used by other code too.

2) Preparation to handle /proc/<pid>/{wchan|syscall}
Patch 3/9: add helpers to handle shared code between wchan and syscall.
           This patch makes sure that the internal handlers will keep
	   their semantic.

3) Improve /proc/<pid>/{wchan|syscall} protections:
Patch 4/9: improve /proc/<pid>/whcan protection.
Patch 5/9: improve /proc/<pid>/syscall protection.

4) Preparation to handle /proc/<pid>/{stat|stack}
Patch 6/9: add shared struct 'pid_seq_private' that will be used by both
           /proc/<pid>/{stat|stack} to have access to the cached
	   permission checks.
Patch 7/9: add helper to handle shared code between stat and stack.
           This patch makes sure that these entries will continue to use
	   sequence iterators and that the semantic of their internal
	   handlers wont change.

5): Improve /proc/<pid>/{stat|stack} protections:
Patch 8/9: improve /proc/<pid>/stat protection.
Patch 9/9: improve /proc/<pid>/stack protection.


Djalal Harouni (9)
 procfs: use flags to deny or allow access to /proc/<pid>/$entry
 procfs: add pid_entry_access() for proper checks on /proc/<pid>/*
 procfs: add proc_read_from_buffer() and pid_entry_read() helpers
 procfs: improve /proc/<pid>/wchan protection
 procfs: improve /proc/<pid>/syscall protection
 procfs: add pid_seq_private struct to handle /proc/<pid>/{stat|stack}
 procfs: add pid_entry_show() helper to handle /proc/<pid>/{stat|stack}
 procfs: improve /proc/<pid>/stat protection
 procfs: improve /proc/<pid>/stack protection

 fs/proc/array.c    |  90 ++++++++++++++++++++++++++++++++++++++++---
 fs/proc/base.c     | 248 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/proc/generic.c  |  22 +++++++++++
 fs/proc/internal.h |  34 ++++++++++++++--
 4 files changed, 361 insertions(+), 33 deletions(-)
