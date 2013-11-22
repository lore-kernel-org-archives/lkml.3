Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3KVTRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:17:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3KVTRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:17:19 -0500
Date: Fri, 22 Nov 2013 20:18:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] signals: change do_signal_stop/do_sigaction to use
	while_each_thread()
Message-ID: <20131122191822.GA16943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122191803.GA16919@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change do_signal_stop() and do_sigaction() to avoid next_thread()
and use while_each_thread() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ded28b9..086071d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2047,8 +2047,8 @@ static bool do_signal_stop(int signr)
 		if (task_set_jobctl_pending(current, signr | gstop))
 			sig->group_stop_count++;
 
-		for (t = next_thread(current); t != current;
-		     t = next_thread(t)) {
+		t = current;
+		while_each_thread(current, t) {
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
@@ -3125,8 +3125,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				t = next_thread(t);
-			} while (t != current);
+			} while_each_thread(current, t);
 		}
 	}
 
-- 
1.5.5.1

