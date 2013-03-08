Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab3CHSBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:01:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759889Ab3CHSBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:01:16 -0500
Date: Fri, 8 Mar 2013 18:59:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] coredump: change wait_for_dump_helpers() to use
	wait_event_interruptible()
Message-ID: <20130308175920.GA26332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308175852.GA26300@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_dump_helpers() calls wake_up/kill_fasync from inside the
wait_event-like loop. This is not needed and in fact this is not
strictly correct, we can/should do this only once after we change
pipe->writers. We could even check if it becomes zero.

Change this code to use use wait_event_interruptible(), this can
also help to make this wait freezable.

With this patch we check pipe->readers without pipe_lock(), this
is fine. Once we see pipe->readers == 1 we know that the handler
decremented the counter, this is all we need.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 477f393..667413c 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -439,17 +439,20 @@ static void wait_for_dump_helpers(struct file *file)
 	pipe_lock(pipe);
 	pipe->readers++;
 	pipe->writers--;
+	wake_up_interruptible_sync(&pipe->wait);
+	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+	pipe_unlock(pipe);
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
-		wake_up_interruptible_sync(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		pipe_wait(pipe);
-	}
+	/*
+	 * We actually want wait_event_freezable() but then we need
+	 * to clear TIF_SIGPENDING and improve dump_interrupted().
+	 */
+	wait_event_interruptible(pipe->wait, pipe->readers == 1);
 
+	pipe_lock(pipe);
 	pipe->readers--;
 	pipe->writers++;
 	pipe_unlock(pipe);
-
 }
 
 /*
-- 
1.5.5.1

