Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaDSLpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:45:18 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38813 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaDSLn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:43:59 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/4] ipc/shm.c: check for ulong overflows in shmat
Date: Sat, 19 Apr 2014 13:43:38 +0200
Message-Id: <1397907821-29319-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397907821-29319-1-git-send-email-manfred@colorfullife.com>
References: <1397907821-29319-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_vma_intersection does not work properly if addr+size overflows.
The patch adds a manual check before the call to find_vma_intersection.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/shm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7645961..382e2fb 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1160,6 +1160,9 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 	down_write(&current->mm->mmap_sem);
 	if (addr && !(shmflg & SHM_REMAP)) {
 		err = -EINVAL;
+		if (addr + size < addr)
+			goto invalid;
+
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
 		/*
-- 
1.9.0

