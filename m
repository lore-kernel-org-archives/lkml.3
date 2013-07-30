Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3G3INr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:13:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52442 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3G3INo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:13:44 -0400
Message-ID: <51F775B5.201@canonical.com>
Date: Tue, 30 Jul 2013 10:13:41 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] mutex: fix deadlock injection
References: <20130701082221.GA14112@gmail.com> <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com> <51D3C4C8.8060701@canonical.com> <20130705062345.GA29487@gmail.com>
In-Reply-To: <20130705062345.GA29487@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check needs to be for > 1, because ctx->acquired is already incremented.
This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
the mutex. It caused a lot of false gpu lockups on radeon with
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
to return -EDEADLK did.

Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
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
