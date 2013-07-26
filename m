Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab3GZB5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:57:14 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63666 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3GZB5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:57:11 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 25 Jul 2013 18:56:50 -0700
Message-ID: <CALCETrUTyLO4BKX0SrmRd=nb2jvvZEhD9iTyFpSM23OUdQLhsA@mail.gmail.com>
Subject: Should unprivileged linkat(..., AT_EMPTY_PATH) work on O_TMPFILE files?
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change:

commit f4e0c30c191f87851c4a53454abb55ee276f4a7e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Jun 11 08:34:36 2013 +0400

    allow the temp files created by open() to be linked to

    O_TMPFILE | O_CREAT => linkat() with AT_SYMLINK_FOLLOW and /proc/self/fd/<n>
    as oldpath (i.e. flink()) will create a link
    O_TMPFILE | O_CREAT | O_EXCL => ENOENT on attempt to link those guys

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

makes it possible to hardlink an O_TMPFILE file using procfs.  Should
linkat(fd, "", newdirfd, newpath, AT_EMPTY_PATH) also work?

AFAICS it currently requires CAP_DAC_READ_SEARCH, but I'm a bit
confused as to why linkat(..., AT_EMPTY_PATH) should have a stricter
check than linkat(AT_FDCWD, "/proc/self/fd/n", ...,
AT_SYMLINK_FOLLOW),  (The relevant change is
11a7b371b64ef39fc5fb1b6f2218eef7c4d035e3.)

FWIW, this program works on Linux 3.9, which makes me doubt that the
security restriction on linkat is doing any good:

#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  char buf[128];

  if (argc != 3)
    errx(1, "Usage: flink FD PATH");

  sprintf(buf, "/proc/self/fd/%d", atoi(argv[1]));
  if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[2], AT_SYMLINK_FOLLOW) != 0)
    err(1, "linkat");
  return 0;
}


Removing the check from the AT_EMPTY_PATH case would simplify code
that wants to write a file, fsync it, and then flink it in.


--Andy

P.S. For even more fun, I'd *love* a linkat flag that would allow the
destination to be overwritten, but that's a different can of worms.
