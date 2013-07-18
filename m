Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3GRNS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:18:26 -0400
Received: from science.horizon.com ([71.41.210.146]:21140 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754507Ab3GRNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:18:25 -0400
Date: 18 Jul 2013 09:18:24 -0400
Message-ID: <20130718131824.10653.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the interest of more useful Kconfig help, could I recommend the
following text:

config QUEUE_RWLOCK
	bool "Generic queue read/write lock"
	depends on ARCH_QUEUE_RWLOCK
	help
	  Use an alternative reader-writer lock (rwlock) implementation,
	  optimized for larger NUMA systems.  These locks use more memory,
	  but perform better under high contention.  (Specifically, readers
	  waiting for a writer to release the lock will be queued rather
	  than all spinning on the same cache line.)

	  The kernel will operate correctly either way; this only
	  affects performance.

	  For common desktop and server systems systems with only one
	  or two CPU sockets, the performance benefits are not worth
	  the additional memory; say N here.

My goal is to give someone stumbling across this question for the first
time in "make oldconfig" the information htey need to answer it.


That said, I think Ingo's idea for simplfying the waiting reader side
is excellent and should be tried before bifurcating the implementation.

Looking at the lock system, it *seems* like that patch to __read_lock_failed
is literally the *only* thing that needs changing, since the write
lock/unlock is all done with relative add/sub anyway.  But I keep thinking
"there must have been a reason why it wasn't done that way in the first
place".
