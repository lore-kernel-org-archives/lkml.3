Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab3GaJBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:01:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3GaI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:24 -0400
Date: Wed, 31 Jul 2013 01:55:38 -0700
From: tip-bot for Maarten Lankhorst <tipbot@zytor.com>
Message-ID: <tip-85f4896123d0299128f2c95cc40f3b8b01d4b0f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, alexander.deucher@amd.com,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, alexander.deucher@amd.com,
        tglx@linutronix.de, maarten.lankhorst@canonical.com
In-Reply-To: <51F775B5.201@canonical.com>
References: <51F775B5.201@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Fix w/w mutex deadlock injection
Git-Commit-ID: 85f4896123d0299128f2c95cc40f3b8b01d4b0f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:55:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85f4896123d0299128f2c95cc40f3b8b01d4b0f6
Gitweb:     http://git.kernel.org/tip/85f4896123d0299128f2c95cc40f3b8b01d4b0f6
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Tue, 30 Jul 2013 10:13:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:16:40 +0200

mutex: Fix w/w mutex deadlock injection

The check needs to be for > 1, because ctx->acquired is already incremented.
This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
the mutex. It caused a lot of false gpu lockups on radeon with
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
to return -EDEADLK did.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/51F775B5.201@canonical.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/mutex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index ff05f4b..a52ee7bb 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -686,7 +686,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
 				   0, &ctx->dep_map, _RET_IP_, ctx);
-	if (!ret && ctx->acquired > 0)
+	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
 	return ret;
@@ -702,7 +702,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
 				  0, &ctx->dep_map, _RET_IP_, ctx);
 
-	if (!ret && ctx->acquired > 0)
+	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
 	return ret;
