Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3GKLHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:07:45 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50877 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3GKLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:07:43 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: viro@ZenIV.linux.org.uk
Cc: linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/2] partial revoke implementation for procfs
Date: Thu, 11 Jul 2013 19:07:19 +0800
Message-Id: <1373540841-30807-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071111-8256-0000-0000-0000084C205F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al Viro, 

I tried to implement what you proposed in:
https://lkml.org/lkml/2013/4/5/15

When you have time, would you please help to take a look at it, and give your 
comments? 
I sent the draft early, just want to make sure I didn't misunderstand anything
in your proposal, and what I did and next step plan are not heading the wrong
direction.

This is only an initial draft to do only what procfs is needed

1. didn't do anything about kick, mmap, fasync, ... and something you mentioned
in following mails

2. I only wrapped f_ops in vfs which are used by procfs ( but maybe I still
missed something). 

3. It seems all f_ops are const, so I couldn't easliy clear the pointer of
->owner, maybe that needs every calling site of proc_create(_data) to make sure
the proc_fops doesn't have ->owner set? 

Currently, I added an ugly check in __fput, so if if ->f_revoke is set in file,
we don't call fput_ops; and in proc_reg_open(), restore the old ->f_op if
make_revokable() fails.

patch 1: adding the implementation proposed in your mail
patch 2: convert procfs to use this implementation

If there aren't any big issues, I plan to look for another file system 
(with backing device) to try other things that's not implemented this time.

Thanks, Zhong

Li Zhong (2):
  vfs: partial revoke implementation suggested by Al Viro
  proc: covert procfs to use the general revoke implementation

 fs/Makefile            |    2 +-
 fs/compat_ioctl.c      |    8 +-
 fs/eventpoll.c         |   10 ++-
 fs/file_table.c        |   13 ++-
 fs/ioctl.c             |    7 +-
 fs/proc/generic.c      |   12 +--
 fs/proc/inode.c        |  229 ++++--------------------------------------------
 fs/proc/internal.h     |    9 +-
 fs/read_write.c        |   30 +++++--
 fs/revoke.c            |  133 ++++++++++++++++++++++++++++
 fs/select.c            |   11 ++-
 include/linux/fs.h     |    2 +
 include/linux/revoke.h |   50 +++++++++++
 mm/mmap.c              |    8 +-
 mm/nommu.c             |   16 +++-
 15 files changed, 297 insertions(+), 243 deletions(-)
 create mode 100644 fs/revoke.c
 create mode 100644 include/linux/revoke.h

-- 
1.7.9.5

