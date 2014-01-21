Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaAUA74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:59:56 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46374 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaAUA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:59:45 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Jan 2014 16:59:23 -0800
Message-ID: <CALCETrVT29DULWg16_oKpGgSSBwZh-yWtygV1oYjH5iQH5jGyg@mail.gmail.com>
Subject: Dirty deleted files cause pointless I/O storms (unless truncated first)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code below runs quickly for a few iterations, and then it slows
down and the whole system becomes laggy for far too long.

Removing the sync_file_range call results in no I/O being performed at
all (which means that the kernel isn't totally screwing this up), and
changing "4096" to SIZE causes lots of I/O but without
the going-out-to-lunch bit (unsurprisingly).

Surprisingly, uncommenting the ftruncate call seems to fix the
problem.  This suggests that all the necessary infrastructure to avoid
wasting time writing to deleted files is there but that it's not
getting used.


#define _GNU_SOURCE
#include <sys/mman.h>
#include <err.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define SIZE (16 * 1048576)

static void hammer(const char *name)
{
  int fd = open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
  if (fd == -1)
    err(1, "open");

  fallocate(fd, 0, 0, SIZE);

  void *addr = mmap(NULL, SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
  if (addr == MAP_FAILED)
    err(1, "mmap");

  memset(addr, 0, SIZE);

  if (munmap(addr, SIZE) != 0)
    err(1, "munmap");

  if (sync_file_range(fd, 0, 4096,
              SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE |
              SYNC_FILE_RANGE_WAIT_AFTER) != 0)
    err(1, "sync_file_range");

  if (unlink(name) != 0)
    err(1, "unlink");

  //  if (ftruncate(fd, 0) != 0)
  //    err(1, "ftruncate");

  close(fd);
}

int main(int argc, char **argv)
{
  if (argc != 2) {
    printf("Usage: hammer_and_delete FILENAME\n");
    return 1;
  }

  while (true) {
    hammer(argv[1]);
    write(1, ".", 1);
  }
}
