Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3LMO2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:07 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49522 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3LMO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:04 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 0/5] xfs: add O_TMPFILE support
Date: Fri, 13 Dec 2013 22:27:48 +0800
Message-Id: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121314-7164-0000-0000-000004378947
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

HI, folks

  It's time to post out the first formal version, welcome to any constructive comment, thanks.

  If anyone is interested in playing with it, you can get this patchset from my dev git on github:
  git://github.com/wuzhy/kernel.git xfs_tmpfile

  The patchset was tests agaist the code snippet from Andy Lutomirski and other test cases:
  http://lwn.net/Articles/562296/
  If you have any other better test cases, please let me know, thanks.

#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define __O_TMPFILE 020000000
#define O_DIRECTORY 0200000
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
#define AT_EMPTY_PATH 0x1000

int main(int argc, char **argv)
{
   char buf[128];

   if (argc != 3)
     errx(1, "Usage: flinktest PATH linkat|proc");

   int fd = open(".", O_TMPFILE | O_RDWR, 0600);
   if (fd == -1)
     err(1, "O_TMPFILE");
   else
     printf("fd #: %d\n", fd);

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


Changelog from rfc:
 - Addressed the comments from Dave Chinner and Christoph Hellwig.

Zhi Yong Wu (5):
  xfs: factor prid related codes into xfs_get_initial_prid()
  xfs: adjust the interface of xfs_qm_vop_dqalloc()
  xfs: add xfs_create_tmpfile() for O_TMPFILE support
  xfs: add a new method xfs_vn_tmpfile()
  xfs: allow linkat() on O_TMPFILE files

 fs/xfs/xfs_inode.c      |  142 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h      |    2 +
 fs/xfs/xfs_ioctl.c      |    2 +-
 fs/xfs/xfs_iops.c       |   25 ++++++++-
 fs/xfs/xfs_qm.c         |   50 ++++++++++------
 fs/xfs/xfs_quota.h      |    6 +-
 fs/xfs/xfs_shared.h     |    4 +-
 fs/xfs/xfs_symlink.c    |    2 +-
 fs/xfs/xfs_trans_resv.c |   51 +++++++++++++++++
 fs/xfs/xfs_trans_resv.h |    4 +
 10 files changed, 255 insertions(+), 33 deletions(-)

-- 
1.7.6.5

