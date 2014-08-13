Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaHMIYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:24:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaHMIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:24:49 -0400
Date: Wed, 13 Aug 2014 01:23:54 -0700
From: tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-e708d7ad80737496870fd0b6794704d063fb0cdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1407159068-1478-1-git-send-email-bigeasy@linutronix.de>
References: <1407159068-1478-1-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Do poll_wait()
  before checking condition in perf_poll()
Git-Commit-ID: e708d7ad80737496870fd0b6794704d063fb0cdc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e708d7ad80737496870fd0b6794704d063fb0cdc
Gitweb:     http://git.kernel.org/tip/e708d7ad80737496870fd0b6794704d063fb0cdc
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Mon, 4 Aug 2014 15:31:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:11 +0200

perf: Do poll_wait() before checking condition in perf_poll()

One should first enqueue to the waitqueue and then check for the
condition. If the condition gets true after mutex_unlock() but before
poll_wait() then we lose it and would have wait for another wakeup.

This has been like this since v2.6.31-rc1 commit c7138f37f9 ("perf_counter:
fix perf_poll()"). Before that it was slightly worse. I guess we get enough
wakeups so if we miss here one it doesn't really matter. It is still a
bad example.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1407159068-1478-1-git-send-email-bigeasy@linutronix.de
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a254605..2d7363a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3629,6 +3629,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
+	poll_wait(file, &event->waitq, wait);
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
@@ -3638,9 +3639,6 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
 	mutex_unlock(&event->mmap_mutex);
-
-	poll_wait(file, &event->waitq, wait);
-
 	return events;
 }
 
