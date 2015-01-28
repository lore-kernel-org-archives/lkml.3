Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbbA2KYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:24:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756495AbbA2JAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 145/176] drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES
Date: Wed, 28 Jan 2015 15:29:35 +0100
Message-Id: <159544d674449fef4f9e862501ae4d6f80f2adce.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 226e5ae9e5f9108beb0bde4ac69f68fe6210fed9 upstream.

If CONFIG_DEBUG_MUTEXES is set, the mutex->owner field is only cleared
if the mutex debugging is enabled which introduces a race in our
mutex_is_locked_by() - i.e. we may inspect the old owner value before it
is acquired by the new task.

This is the root cause of this error:

# diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
# index 5cf6731..3ef3736 100644
# --- a/kernel/locking/mutex-debug.c
# +++ b/kernel/locking/mutex-debug.c
# @@ -80,13 +80,13 @@ void debug_mutex_unlock(struct mutex *lock)
# 			DEBUG_LOCKS_WARN_ON(lock->owner != current);
#
# 		DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
# -		mutex_clear_owner(lock);
# 	}
#
# 	/*
# 	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
# 	 * mutexes so that we can do it here after we've verified state.
# 	 */
# +	mutex_clear_owner(lock);
# 	atomic_set(&lock->count, 1);
#  }

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=87955
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index ef5fe7e9d86c..7e4e6896fa81 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4795,7 +4795,7 @@ static bool mutex_is_locked_by(struct mutex *mutex, struct task_struct *task)
 	if (!mutex_is_locked(mutex))
 		return false;
 
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
 	return mutex->owner == task;
 #else
 	/* Since UP may be pre-empted, we cannot assume that we own the lock */
-- 
2.2.2

