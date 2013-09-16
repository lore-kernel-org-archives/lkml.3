Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3IPDEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:04:55 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:48311 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab3IPDEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:49 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 0/4] ipc: shm and msg fixes
Date: Sun, 15 Sep 2013 20:04:33 -0700
Message-Id: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset deals with the selinux and rmid races Manfred found on
the ipc scaling work that has been going on. It specifically addresses
shared mem and msg queues. While semaphores still need updated, I want
to make sure these are correct first. Also, Manfred had already sent out
a patchset that deals with a race in sem complex operations. So any changes
should be on top of his.

Patches 1 and 2 deal with shared memory.
Patches 3 and 4 deal with msg queues.
Specific details about each race and its fix are in the corresponding
patches.

Note that Linus suggested a good alternative to patches 1 and 3: use
kfree_rcu() and delay the freeing of the security structure. I would
much prefer that approach to doing security checks with the lock held,
but I want to leave the patches out and ready in case we go with the
later solution.

I have tested these patches with IPC testcases from LTP on both my
quad-core laptop and on a 64 core NUMA server. In both cases, voluntary
and forced preemption have passed the tests -- note that I was not able
to reproduce any of these bugs in the first case, so these tests were
mostly to make sure I didn't further introduce any other issues.

Manfred, could you please give me your feedback on these, as I'd like
to make sure I'm not doing anything stupid.

Davidlohr Bueso (4):
  ipc,shm: fix race with selinux
  ipc,shm: prevent race with rmid in shmat(2)
  ipc,msg: fix race with selinux
  ipc,msg: prevent race with rmid in msgsnd,msgrcv

 ipc/msg.c | 27 +++++++++++++++++++++------
 ipc/shm.c | 31 ++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 15 deletions(-)

-- 
1.7.11.7

