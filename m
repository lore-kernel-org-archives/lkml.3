Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaE2Sqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:46:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50376 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaE2Sqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:46:48 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 0/3] ipc: Further updates to sysv/mqueue limits
Date: Thu, 29 May 2014 20:46:37 +0200
Message-Id: <1401389200-6758-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a) If we increase SHMMAX/SHMALL, then it makes sense to
   increase MSGMNI, too.
   And: This allows to remove the automatic scaling (~300 lines)

b) We can also increase SEMMSL, SEMMNI and SEMOPM

c) I think it would make more sense if a namespace starts with the
   limits from it's parent:
   If an admin set the limits, then he probably wants that these limits also
   apply for a new child namespace.

All patches are RFC - they compile, but that's it.

TODO:
- check if the sysv sem limits are sane.
  Especially the SEMOPM - if real users exist that pass > 1k ops, then
  switch from kmalloc to vmalloc.

  @the Redhat developers: Do you have any idea where this "often
  recommended" comes from?
  https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-The_SEMOPM_Parameter.html

- copy Davidlohrs explanation for the sysv shm limits to sysv msg and
  sysv sem.

- check if we should also increase the limits for posix mqueue

- decide if it would make sense to increase IPCMNI:

  Right now, it is 32768. This means that after 65536 pairs of
  semget()/semctl(IPC_RMID), semget() will return the same identifier
  again - and a semop(old_id) won't return -EINVAL, instead it will
  access the "new" array, which is probably now what the caller
  intended to do.

  The split is arbitrary - we could also split it 1048576/2048 or any
  other split we want.

- test everything.

--
	Manfred
