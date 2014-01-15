Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaAOAdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:33:17 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:1477 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:33:14 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Subject: [RFC 0/3] mutex: Reduce spinning contention when there is no lock owner
Date: Tue, 14 Jan 2014 16:33:07 -0800
Message-Id: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While optimistic spinning is beneficial to performance, I have found that
threads can potentially spin for a long time while there is no lock owner
during high contention cases. In these scenarios, too much spinning can reduce
performance. This RFC patchset attempts to address some of the issues with
spinning too much with no owner.

Patch 1 changes the mutex_can_spin_on_owner() function to address the
need_resched() case. Patch 2 modifies the way mutex spinners are queued to
reduce mspin_lock and mspin_unlock overhead when there is no owner, and is also
necessary patch for patch 3. Patch 3 limits the number of times each thread
can spin on lock->count when there is no lock owner.

This change benefit the AIM7 fserver (run on disk) at 1000-2000 users
on an 8 socket (80 core) box, with a +19.5% gain with 3.13-rc7 + patchset
compared to the baseline 3.13-rc7 kernel. At 100-900 users, the
% gain was about 4.9%, and there wasn't much performance difference
at 10-90 users. On a 2 socket (8 core) box, there was about a 5.5%
improvement at 1000-2000 users.

