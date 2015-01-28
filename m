Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbbA1B76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:59:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbbA1BiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 07/77] drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES
Date: Tue, 27 Jan 2015 17:26:45 -0800
Message-Id: <20150128012746.192009633@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4978,7 +4978,7 @@ static bool mutex_is_locked_by(struct mu
 	if (!mutex_is_locked(mutex))
 		return false;
 
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
 	return mutex->owner == task;
 #else
 	/* Since UP may be pre-empted, we cannot assume that we own the lock */


