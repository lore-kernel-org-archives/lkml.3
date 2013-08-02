Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3HBBv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:51:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52277 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3HBBvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:51:54 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 Aug 2013 18:51:33 -0700
Message-ID: <CALCETrUJHDHcB8TEYOBfbOp=xSZYzghiTtMxsDr9rhV0eUJj=A@mail.gmail.com>
Subject: O_TMPFILE and linkat(/proc/self/fd/...) on tmpfs creates a weird file
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test program:

#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>

#define __O_TMPFILE 020000000
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
#define AT_EMPTY_PATH 0x1000

int main(int argc, char **argv)
{
  char buf[128];

  if (argc != 3)
    errx(1, "Usage: flinktest PATH linkat|proc");

  int fd = open(".", O_TMPFILE | O_RDWR);
  if (fd == -1)
    err(1, "O_TMPFILE");
  write(fd, "test", 4);

  if (!strcmp(argv[2], "linkat")) {
    if (linkat(fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) != 0)
      err(1, "linkat");
  } else if (!strcmp(argv[2], "proc")) {
    sprintf(buf, "/proc/self/fd/%d", fd);
    if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[1], AT_SYMLINK_FOLLOW) != 0)
      err(1, "linkat");
  } else {
    errx(1, "invalid mode");
  }
  return 0;
}


run on tmpfs results in a "weird file".   stat thinks it has "Access:
(0000/?--------) and cat says "Invalid argument".

This is on -linus from a couple minutes ago.

--Andy
